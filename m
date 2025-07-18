Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001210942;
	Fri, 18 Jul 2025 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752838116; cv=none; b=dWJm6NGCl7gwfC7H43+ydRmsmCaD9sHAaptuYIfEXAyvGPCLdrbrJprN0dR5chQGS8/PZ92CKdVbobdcXICLWRxlEPbiJ3hu5aqfXbUTULGDLwOPYsYqq8gbn/OK+XORJ9jEF/qmm6j0U2OFOV3EKPxB9cmmPHQBny8iqiGTttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752838116; c=relaxed/simple;
	bh=UdfgYmxgbbQPgJz6TBepSGeCZJFYhos4mqQ6v8IJ8zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIgSr+RMS/waitDy/bgphNI1X0JdmXMnufrASB44DAf8qJEVe9Hp6Am8VkpdqeVuxhLXO6u9vNB0Q4btFq2jRQV+ofYzzrS6WtedmjORY17rW/EK2ja+R6a3gVaoUV+RxgtnGIf+eEbWh7ZDPDBvlB5A52TR9uzykbPtBw29Z90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 78C1460528; Fri, 18 Jul 2025 13:28:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	<netdev@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: xt_nfacct: don't assume acct name is null-terminated
Date: Fri, 18 Jul 2025 13:27:13 +0200
Message-ID: <20250718112735.16188-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <68799e14.a00a0220.3af5df.0025.GAE@google.com>
References: <68799e14.a00a0220.3af5df.0025.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BUG: KASAN: slab-out-of-bounds in .. lib/vsprintf.c:721
Read of size 1 at addr ffff88801eac95c8 by task syz-executor183/5851
[..]
 string+0x231/0x2b0 lib/vsprintf.c:721
 vsnprintf+0x739/0xf00 lib/vsprintf.c:2874
 [..]
 nfacct_mt_checkentry+0xd2/0xe0 net/netfilter/xt_nfacct.c:41
 xt_check_match+0x3d1/0xab0 net/netfilter/x_tables.c:523

nfnl_acct_find_get() handles non-null input, but the error
printk relied on its presence.

Reported-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4ff165b9251e4d295690
Tested-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Fixes: ceb98d03eac5 ("netfilter: xtables: add nfacct match to support extended accounting")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Probably apply to nf-next instead due to late stage and this not
 being a big deal.

 net/netfilter/xt_nfacct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 7c6bf1c16813..0ca1cdfc4095 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -38,8 +38,8 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 
 	nfacct = nfnl_acct_find_get(par->net, info->name);
 	if (nfacct == NULL) {
-		pr_info_ratelimited("accounting object `%s' does not exists\n",
-				    info->name);
+		pr_info_ratelimited("accounting object `%.*s' does not exist\n",
+				    NFACCT_NAME_MAX, info->name);
 		return -ENOENT;
 	}
 	info->nfacct = nfacct;
-- 
2.49.1

