Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D86C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2BF420737
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390902AbgDCME2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:04:28 -0400
Received: from correo.us.es ([193.147.175.20]:58060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390889AbgDCME2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 08:04:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 703891878AD
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 14:04:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44EC1132CB3
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 14:04:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3BE83132C8D; Fri,  3 Apr 2020 14:04:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB27ADA3C4;
        Fri,  3 Apr 2020 14:03:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Apr 2020 14:03:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9E73F42EF42C;
        Fri,  3 Apr 2020 14:03:51 +0200 (CEST)
Date:   Fri, 3 Apr 2020 14:03:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sbrivio@redhat.com
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403120351.cxhcdcwfpylven4k@salvia>
References: <20200402214941.60097-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wgnkgo5akan5t2ym"
Content-Disposition: inline
In-Reply-To: <20200402214941.60097-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wgnkgo5akan5t2ym
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 02, 2020 at 11:49:41PM +0200, Pablo Neira Ayuso wrote:
> This patch adds a lazy check to validate that the first element is not a
> concatenation. The segtree code does not support for concatenations,
> bail out with EOPNOTSUPP.
>
>  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
>  Error: Could not process rule: Operation not supported
>  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Otherwise, the segtree code barfs with:
>
>  BUG: invalid range expression type concat

Hm.

I'm afraid this patch is not enough, the following ruleset crashes
in old kernels with recent nft:

flush ruleset

table inet filter {
        set test {
                type ipv4_addr . ipv4_addr . inet_service
                flags interval,timeout
                elements = { 1.1.1.1 . 2.2.2.2 . 30 ,
                             2.2.2.2 . 3.3.3.3 . 40 ,
                             3.3.3.3 . 4.4.4.4 . 50 }
        }

        chain output {
                type filter hook output priority 0; policy accept;
                ip saddr . ip daddr . tcp dport @test counter
        }
}

Old kernel obviously does not support for concatenation with intervals.

I think Stefano's NFT_SET_CONCAT flag needs to be restored in the
kernel (see attached patch) to deal with old kernel properly.

On set creation, old kernels bail out since they do not know what to
do with this patch.

Then, the next problem is that the kernel says -EINVAL in this case,
this error code is bad. It should only be used for malformed messages,
if NFT_SET_CONCAT is set on and kernel does not support this, it
should instead just report EOPNOTSUPP (see the second patch in this
email). I'm also updating the error code for the object maps since
there might be a need to introduce new objects in the future.

Thanks.

--wgnkgo5akan5t2ym
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 30f2a87270dc..4565456c0ef4 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -276,6 +276,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
+ * @NFT_SET_CONCAT: set contains a concatenation
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -285,6 +286,7 @@ enum nft_set_flags {
 	NFT_SET_TIMEOUT			= 0x10,
 	NFT_SET_EVAL			= 0x20,
 	NFT_SET_OBJECT			= 0x40,
+	NFT_SET_CONCAT			= 0x80,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0ab5ffa1e2c..235762b91dd4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3961,7 +3961,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 			      NFT_SET_MAP | NFT_SET_EVAL |
-			      NFT_SET_OBJECT))
+			      NFT_SET_OBJECT | NFT_SET_CONCAT))
 			return -EINVAL;
 		/* Only one of these operations is supported */
 		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
-- 
2.11.0


--wgnkgo5akan5t2ym
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="y.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0ab5ffa1e2c..63e38ac1c0f8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3962,7 +3962,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 			      NFT_SET_MAP | NFT_SET_EVAL |
 			      NFT_SET_OBJECT | NFT_SET_CONCAT))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		/* Only one of these operations is supported */
 		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
 			     (NFT_SET_MAP | NFT_SET_OBJECT))
@@ -4000,7 +4000,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
 		if (objtype == NFT_OBJECT_UNSPEC ||
 		    objtype > NFT_OBJECT_MAX)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 	} else if (flags & NFT_SET_OBJECT)
 		return -EINVAL;
 	else
-- 
2.11.0


--wgnkgo5akan5t2ym--
