From: Feng Gao <gfree.wind@outlook.com>
Subject: [PATCH 1/1] netfilter: ftp: Check data size before copy them into FTP buffer
Date: Tue, 29 Sep 2015 16:49:32 +0800
Message-ID: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s28.hotmail.com ([65.54.190.39]:50009 "EHLO
	BAY004-OMC1S28.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933706AbbI2Itf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 04:49:35 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When TCP endpoint supports the windows scale option, the data size could
be more than 65536 easily. And there are some network interface features
which could aggregate multiple packets. So we need to check the datalen
before copy data into the FTP buffer.

Signed-off-by: Feng Gao <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_ftp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index b666959..79ae8a9 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -35,6 +35,7 @@ MODULE_ALIAS_NFCT_HELPER("ftp");
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
+#define NF_FTP_BUF_SIZE		(65536)
 
 static DEFINE_SPINLOCK(nf_ftp_lock);
 
@@ -422,6 +423,11 @@ static int help(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 	datalen = skb->len - dataoff;
+	if (unlikely(datalen > NF_FTP_BUF_SIZE)) {
+		pr_warn("ftp: Data len(%u) is more than ftp buffer(%u)\n",
+			datalen, NF_FTP_BUF_SIZE);
+		return NF_ACCEPT;
+	}
 
 	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
@@ -600,7 +606,7 @@ static int __init nf_conntrack_ftp_init(void)
 {
 	int i, j = -1, ret = 0;
 
-	ftp_buffer = kmalloc(65536, GFP_KERNEL);
+	ftp_buffer = kmalloc(NF_FTP_BUF_SIZE, GFP_KERNEL);
 	if (!ftp_buffer)
 		return -ENOMEM;
 
-- 

Best Regards
Feng
