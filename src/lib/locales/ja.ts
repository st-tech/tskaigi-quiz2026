import type { Messages } from '../i18n';

export const ja: Messages = {
	quizPanelAriaLabel: 'クイズ画面',
	introTitle: '全10問のTypeScriptクイズ！',
	introLead:
		'テックリードお手製、社内でも実施しているTypeScriptクイズの特別版。何問正解できるかな？',
	statusAriaLabel: '回答状況',
	startButtonAriaLabel: 'クイズを開始',
	resumeButtonAriaLabel: '未回答の問題から再開',
	choiceLegend: (index) => `第${index + 1}問の回答を選択`,
	answerListAriaLabel: '回答一覧',
	unanswered: '未回答',
	reviewItemLabel: (index, title, answer) =>
		`第${index + 1}問: ${title}。現在の回答: ${answer}。回答を編集`,
	boothTitle: 'ブースで結果を確認してください',
	boothLead: '「Start camera」からスタッフが提示するQRコードをこの端末で読み取ると、あなたの回答の正誤を確認できます。',
	answerResultListAriaLabel: '正誤結果',
	scoreAriaLabel: (correct, total) => `正解数 ${correct} / ${total}`,
	resultMeta: (date) => `${date} / 詳しい説明は後日公開予定です。`,
	codeExpandHint: 'タップでコードを展開',
	codeCollapseHint: 'タップでコードを閉じる',
	shareLabel: '結果をシェア',
	shareCta: '感想を添えてXでポスト！',
	sharePostButton: 'Xでポスト',
	shareCopyButton: 'テキストコピー',
	shareCopiedButton: 'コピーしました！',
	shareCopyFailedButton: 'コピー失敗',
	buildShareText: (day, correctCount, total, isPerfect) => {
		const hashtags = '#TSKaigi #TSKaigi2026 #zozo_engineer';
		if (correctCount < 5) {
			return [
				'TSKaigi 2026のZOZOブースでTypeScriptクイズにチャレンジしました！',
				'',
				hashtags,
			].join('\n');
		}
		const score = isPerfect ? `${total}問全問正解！🎉` : `${correctCount}問正解！🙌`;
		return [
			'TSKaigi 2026のZOZOブースでTypeScriptクイズに挑戦しました！',
			`Day${day}の結果は...${score}`,
			'',
			hashtags,
		].join('\n');
	},
	cameraStarting: 'カメラを起動しています',
	qrScanned: 'QRを読み取りました',
	qrReadFailed: 'QRの読み取りに失敗しました',
	cameraUnavailable: 'このブラウザではカメラを利用できません',
	qrPrompt: 'スタッフのQRをカメラにかざしてください',
	cameraStartFailed: 'カメラを起動できませんでした',
	cameraError: 'カメラエラー',
	cameraAriaLabel: 'スタッフQR読み取り用カメラプレビュー',
	invalidQrError: '正答QRを読み取れませんでした。スタッフ画面のQRを読み取ってください。',
	wrongDayQrError: 'この日の正答QRではありません。スタッフに当日のQRを表示してもらってください。',
	missingQuestionQrError:
		'正答QRに必要な問題が含まれていません。スタッフにQRを確認してもらってください。',
	unknownChoiceQrError:
		'正答QRに不明な選択肢が含まれています。スタッフにQRを確認してもらってください。',
};
