Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE8280036
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Feb 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708528652; cv=none; b=MWqSjXZjNFaUXIfbmJhJewvU/9G/PjtIU6eKdjgA2nmthLU4YAUf8ByIG78LriVcD7XDq4aYRpI8K6/vky7npvm139TYgr2bChodyTG+ogvU26Nzzkep6H8eooCSqv7CpVWhjlXRJ59JFeKp679t1zEIk1bu+WKZZD/V0UzX8NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708528652; c=relaxed/simple;
	bh=udl4t8FrUgE1le11pZW4HvSrj3tfF0Bbb3I8HT4Ifhk=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=sGGc+dvhb5gb0YZwfYPJUqS3mTNOVTokHrNI03Ur7OwxOYxTtOgfb8bJzaejGBlBbjOQGJXn/ksoP0WsIRnYFMx8onePsinYaoJdm1675YZFegqWr4ZRnfr4c5uc+7jRudfe+A4wWSYryAWvkNeeuxK7wx2AirxtTJvux2YFahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=UAH6Qe8I; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="UAH6Qe8I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1708528645; bh=+iwP28SXlyj+RQJ4NtBkEaNUvJRUnIGvsbqIcR1WhaA=;
	h=From:To:Cc:Subject:Date;
	b=UAH6Qe8ILZmCMeDYyo9vcADK4TVzSFx4dy8EM4NzuAJe1SzbT4ayvjhd5XnNhn9rk
	 uy2AMZ9ob+2JxKx9V8p/NCN50AdeP9+MW1TyFkDHoxn1H246+QB8laWYvGBQ29ucXj
	 ngBOSLOwrMX9e88aginu4qgUT6FvERFZ+zvgzs9M=
Received: from mail.red54.com ([2a09:bac5:a6c3:18d2::279:93])
	by newxmesmtplogicsvrszc5-1.qq.com (NewEsmtp) with SMTP
	id 450A98BF; Wed, 21 Feb 2024 23:17:16 +0800
X-QQ-mid: xmsmtpt1708528636tor6amcup
Message-ID: <tencent_C3F5D0594FFF293E6BB4DFFD3004D6D2860A@qq.com>
X-QQ-XMAILINFO: MmpliBmRb3iCTSG374GHDrrfL35V8UvatvPIuZgmppQYhoQnRrPEpuVemN1R6j
	 4F30v6VVeetLlVGDfRkcYVYHlyFBymTki7yju51s3sbWQhx08PDZZnCCobcZZH1k5abDu20K7OpD
	 nqu+OYDgwy9JthDqiaErE7Sak9ehbJhQUFNZoSB9YbjyIQtA+0dns17aNQBm8EhnHmIkXeehANJg
	 O9cCi4Ei/qaw8IGGGvAqvAh8qNpTkoFRiEO6Nem1rx/pncZAGL0XgIBGUQIxT7nIhSnD8vIhzmIn
	 eL++oQfOIqqt4jUR2Txnk2E+/0z3QeDIBC3nDJBKEfpSYLl7AQEP4N7ngczMfN3MKfSpnT4xCYqd
	 PCABzCSXK+gPb5qDMHQw/i60GsHeWen89g+4enXnKHX2oI+xPOfnveajGzXc+lM6J/Lsb7FKX9Tx
	 SdTqEhHSU05SivL/NRU8ueg9AD1sTDhJcY/lBDkjMINNvJ+AA7h9R5uvJolE4zKHgrEH2IsQNFIB
	 9LevR/pNJQcyg2ejfhk9pIFWrT3XQfhlTOlE9eU9cdUvokCj3pnYvtke+SZiCBoQDA+GYySM62Sq
	 WbUTI/ggQCQ8jbh99gz0KJMzTvvWCRcsmwxuAMQw183qAIyeHznRQ1Sm/lPuv0S4zgY/95OD7NVE
	 ifmxlsr/Llps81ny+UOEvvmas675EIQL0oQLDSdUzvRw3TXfz9MZu8Q0jzyQ+Eg+qcjoiGf35mQn
	 GzoIm8Eb32TKPk9Lmxma76txwdlqR9ygwQ5bnJjnrcRm+fs3MwfwkjstdXIMg3mdjR5fiaqk/2TM
	 dRrdVkHWvHKilLfchBfSrmGjswXnOTnq8r67qm1kTxIFGW4slrF43b83BW4uPwvcUz2tY7NW1ahx
	 iKhnpR+Yjub4bikW9XMup7OxXQmlC1obKHqiIPXEwzL7Esb4o2JrW3dRdMC4XA1BNmUKKezYd64H
	 JcuKNPmvRFXvwO1rbtGs8Ic/xUfTsjO5XxpKusZRZEW6fFvcQBdM7ePMiAg6uQ21fueKQXsvgWjr
	 LyP5tbjritQzTfPujeHUdHosNEyDAHLKMA9DJs2g9TS79zZfQp+Y9wflAt6IE=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [nft PATCH] src: improve error reporting for destroy command
Date: Wed, 21 Feb 2024 15:17:09 +0000
X-OQ-MSGID: <20240221151709.344050-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Example for older kernels (<6.3):
nft destroy table ip missingtable

Before:
Error: Could not process rule: Invalid argument

After:
Error: "destroy" command is not supported, perhaps kernel support is
missing?

Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
 src/cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index 68c476c6..21533e0e 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -311,6 +311,12 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		break;
 	}
 
+	if (cmd->op == CMD_DESTROY && err->err == EINVAL) {
+		netlink_io_error(ctx, loc,
+				 "\"destroy\" command is not supported, perhaps kernel support is missing?");
+		return;
+	}
+
 	netlink_io_error(ctx, loc, "Could not process rule: %s",
 			 strerror(err->err));
 }
-- 
2.34.1

