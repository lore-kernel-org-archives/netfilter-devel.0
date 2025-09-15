Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7C2F99B5
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2025 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757940063; cv=none; b=piVhZ/CHVfYBkUjfkZXxLFexCOPPkysEDOk4VrAEi3NaI1MDRPRLZrNmUgenq8Jt+xMy0MYoJILb18ma/YEQxuT3ujFMH469AUJOsmn/RaQ6cLeEuOLHV4BqUCdBjxKIExY3f0Gl1aQt1PQR9Z/wZSbS6JZ+kmSp4DULIq0DHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757940063; c=relaxed/simple;
	bh=aO+Ji32ZS3zfUQKYOkHYq7iXG/HQ+HQQceG7Is5TNrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZu0QNwX8AbNw7U4A3uag+d0/4xT5qlxFF+LDK8/HV0hJVRLV9cSQZMikRz9WwKA36ytEPsd5VsSkfV1ev+3ZWEN23G1skZJVhM1SrRjUbHiQ1arJJ1TOfDXN+uYT8Q7jqoC3Hqrq94PAp/kcgEEBlUhOnGCg4xUYWNWoCFNOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B833E605CE; Mon, 15 Sep 2025 14:40:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Sudha.Ranganathan@bmwtechworks.in,
	Florian Westphal <fw@strlen.de>,
	Divyanshu Rathore <Divyanshu.Rathore@bmwtechworks.in>
Subject: [PATCH libmnl] examples: genl: fix wrong attribute size
Date: Mon, 15 Sep 2025 14:40:30 +0200
Message-ID: <20250915124049.331477-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <MA0P287MB33783620765E4FC9131E161DF915A@MA0P287MB3378.INDP287.PROD.OUTLOOK.COM>
References: <MA0P287MB33783620765E4FC9131E161DF915A@MA0P287MB3378.INDP287.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This example no longer works on more recent kernels:

genl-family-get
error: Invalid argument

dmesg says:
netlink: 'genl-family-get': attribute type 1 has an invalid length.

Fix this and also zero out the reserved field in the genl header,
while not validated yet for dumps this could change.

Reported-by: Divyanshu Rathore <Divyanshu.Rathore@bmwtechworks.in>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I will push this out later today.

 examples/genl/genl-family-get.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index ba8de122094c..0c2006755e30 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -199,8 +199,9 @@ int main(int argc, char *argv[])
 	genl = mnl_nlmsg_put_extra_header(nlh, sizeof(struct genlmsghdr));
 	genl->cmd = CTRL_CMD_GETFAMILY;
 	genl->version = 1;
+	genl->reserved = 0;
 
-	mnl_attr_put_u32(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
+	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
 	if (argc >= 2)
 		mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
 	else
-- 
2.51.0

