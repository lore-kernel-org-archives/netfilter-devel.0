From: John Haxby <john.haxby@oracle.com>
Subject: [RESEND] [PATCH] Fix a couple of problems with xt_SYSRQ
Date: Fri, 25 Jun 2010 10:38:03 +0100
Message-ID: <4C2478FB.5080602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43425 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0FYJjg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:39:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The first problem is that the error response from crypto_alloc_hash()
should be extracted from the pointer before setting the pointer to NULL.

The second error is that only the first half of the password hash is
checked which slightly weakens the password checking.

Signed-off-by: John Haxby <john.haxby@oracle.com>
---
  extensions/xt_SYSRQ.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index e0b6aa0..30fc112 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -135,13 +135,13 @@ static unsigned int sysrq_tg(const void *pdata, 
uint16_t len)
  			"0123456789abcdef"[sysrq_digest[i] & 0xf];
  	}
  	sysrq_hexdigest[2*sysrq_digest_size] = '\0';
-	if (len - n < sysrq_digest_size) {
+	if (len - n < sysrq_digest_size*2) {
  		if (sysrq_debug)
  			printk(KERN_INFO KBUILD_MODNAME ": Short digest,"
  			       " expected %s\n", sysrq_hexdigest);
  		return NF_DROP;
  	}
-	if (strncmp(data + n, sysrq_hexdigest, sysrq_digest_size) != 0) {
+	if (strncmp(data + n, sysrq_hexdigest, sysrq_digest_size*2) != 0) {
  		if (sysrq_debug)
  			printk(KERN_INFO KBUILD_MODNAME ": Bad digest,"
  			       " expected %s\n", sysrq_hexdigest);
@@ -324,8 +324,8 @@ static int __init sysrq_crypto_init(void)
  		printk(KERN_WARNING KBUILD_MODNAME
  			": Error: Could not find or load %s hash\n",
  			sysrq_hash);
-		sysrq_tfm = NULL;
  		ret = PTR_ERR(sysrq_tfm);
+		sysrq_tfm = NULL;
  		goto fail;
  	}
  	sysrq_digest_size = crypto_hash_digestsize(sysrq_tfm);
-- 
1.7.0.1

