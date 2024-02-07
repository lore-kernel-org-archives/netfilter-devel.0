Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2FB59B76
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707308898; cv=none; b=M0Ebp1R8l7mPFASBTv9jDIGsmSvJqiMNuhjpsoinj6qc9v09zzhzy05nkWYOnRJtwZ/unkf2gtQZtzXIbUc4nLscKeFZcYNSF62xNINP1qS2XYJ+SZH6p4dQXIUe7ASjWmnuUxPcf18HXvi7jxhrxXioqqEAhJUscMG+VdHba7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707308898; c=relaxed/simple;
	bh=m9PQ3kqyRf3lkf2YBkAYpZi/MXcC/qMt3zcF8g9LpF0=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=iIbam+0mIbonRUNB3ARjBWCmPjxNC/CENHmaCd3cwqsKE6+2LumiNwqmAplq0ou1LuPmHNFUBwxP+zXiEBQiOPkw8DKUzLnK8A5IpVrSOLSA8AGq8jeGrvjdyxiHAMg72qTSUnBAeyHWrOvHifL69FBPENvZpFPX14ivImg5WrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Z5k2snH2; arc=none smtp.client-ip=203.205.221.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Z5k2snH2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1707308888; bh=lrfmvvUSgrbZdew1s+1v39DLCOsBx70jpEpJDVkGZIc=;
	h=From:To:Cc:Subject:Date;
	b=Z5k2snH26RMAcALiNVT3Yfdz5Ajmk5VOeQqUr6hhwSBkoe+P1AfubJv0vtqeQdPBc
	 7sxLoc2OYD5ZlUgwLLCmeeT7loaZ7Enfcd6ETPudW3Z8Q8AmFEq5qdEK6yOXFu/iKs
	 luYFnxGHBno7ChJEZP3B7RQnejZFKo1OQ2eGnd5Q=
Received: from mail.red54.com ([2a09:bac5:80cd:137d::1f1:1ef])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id 700A943A; Wed, 07 Feb 2024 20:28:00 +0800
X-QQ-mid: xmsmtpt1707308880t7foiurdg
Message-ID: <tencent_4CE98729F09EB6B547CF9AE06FF119AF7D05@qq.com>
X-QQ-XMAILINFO: NyTsQ4JOu2J2Hx1ik+C/qCGNtkW6AbzorwTjEwlQ6JhLkq5enhUqy0/iSOWs73
	 Rm96H0PJ6IunZBOqjV9RoTHbByxDVaxFAjMoC4osE+50jqj53YGdgqwI3N34zOab2yFDkqKWDKNU
	 tA/cqxadPrnD5hOj1YWhFc3egi434rdRnKc4a2YhdbcvvtSk5yX/Ng6pM5qRSJMuy0+ZNs00XgU8
	 9RX1+OlIsdIAPT6mIT115n1Y0OXjgCoLP86DtwPEpsWFyF3W2tO+7pz3HhNEIRuoOImXJDCTD9yn
	 qBm7BSsI+zqZyA74ceyJHu7mQA+twvTS0LV1H0q5mjKFHwkvx+vjLHt37/RlGDfarzvBFUmq2J6P
	 lynGEmIi5kX+S6UizmRVswlOpGGF0ajUopLyB+Hm2f7+Y2AcNWrlbQUygkTBuhEROjor/lmcGgPW
	 1gYVv+74CMvIGeT+7wQIOkVBxVdvlt83gktjZ3Oym2l2o1fi3ix+gRNo9BPpOhFZo4dPkceG+2z4
	 ZJI74QRJ70iRrjc/rqk8gkAXTXWVfY3BphlfTvh8r43CHKesiXTGNzC3/XNiBCAFk3WfpTQ247GQ
	 NVk+s4yni6KqBQZm2i2vTRgOZ0qfced8k2KXkhqIZD/XBXJMnlbLvGk0M5a40NBa8WAm2pi+bFmS
	 QmBlYbjjOwnTtFUSAK64Z8icxuwz4C/c7X1XoiybE5Tw4+v9F4+NdxhB5pDMscZ5mRXfkjATkM7u
	 S6M+h7ckBHjma6H0XZod6ajwDxktJSKF8nRZWAa5qdlAOeJigDPNLhQc4g5r/lAKTVMvypn94kcg
	 U2AIfI3PSux6a8tAHH5xvcWU8xQYlqS0wPb4JMFU/sZ7sqhDrN2JeMXm2kTEDdHbEy/9pQ1fvNBu
	 b0nJEFJcGXsqaWgcVEEZ6w/fci1ZrsrRKoLsRudSkN1Jkz4Be61AawuRaoWcx6m2ApEEG289faDE
	 p1knElMSJca4KDsMwpV1OgO2LFMEpe9kTauYdZafGTz4MjlEmh0g2/kmyf8dK4d3tI3m5qT3cCGW
	 StxN+JJz2bERkYhp2Fzs29M1IPI0WNwRL20TSAhK6N/9Z0i/QKLlxGSpuJMsEz0s4O9MgGWQ==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [nft PATCH v2] evaluate: fix check for unknown in cmd_op_to_name
Date: Wed,  7 Feb 2024 12:27:57 +0000
X-OQ-MSGID: <20240207122757.5672-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Example:
nft --debug=all destroy table ip missingtable

Before:
Evaluate unknown

After:
Evaluate destroy

Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
V1 -> V2: Update subject and message

 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 68cfd7765381..57da4044e8c0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6048,7 +6048,7 @@ static const char * const cmd_op_name[] = {
 
 static const char *cmd_op_to_name(enum cmd_ops op)
 {
-	if (op > CMD_DESCRIBE)
+	if (op > CMD_DESTROY)
 		return "unknown";
 
 	return cmd_op_name[op];
-- 
2.43.0

