Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D992C5B578
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 20:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE6E920663
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 20:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSldK+9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGAUm3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 16:42:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46000 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfGAUm3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 16:42:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so15213969wre.12
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2019 13:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uHMHwl74x/OdQnicxVI5wW/8px0enrZAPn6039YmWiw=;
        b=RSldK+9GwHwhVKMDwYfW4RxvAl9c+O2Q/OlmdzRo4ID0DrJe2ex1FU0gxJ80+3025A
         cfeOQyYBjA9481fgtlwukWlZdpUTL8quxxkxQq4UNOMYqe9InhYl40MiCTpkq6/viQw4
         BLieEdyF2AWuTb1vtOgD3084tERbIajIYRD6Zho1hpPHDBs5776jaN0QIrLpeU41HroL
         DIlaNpdbZ77/EaEGt+Rz4ioQconThB4+zbUxS8NnNhNsjxz5unrMivyB4Me6272IZwS3
         SeiuD+W9dYyGN0Gqfe/hlUlJSAqGuqSoMeo5cLOD7W6G51GBkmABYQMtkeATDt9MOrvT
         c+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uHMHwl74x/OdQnicxVI5wW/8px0enrZAPn6039YmWiw=;
        b=RQP3CkuDzWi8exH8vh+7scRl5VkZ6y+eNHid7lHt/8dyPWzhc4CmAmlCbS76XdLAZp
         f9vOh6FzEqSl+QVEyl+QAhKBdJzwlVRZ3bOjTK8ZjGlODN+++du2U6rcVBHToIB/1MPa
         6f1nNIf/BAqk0uUZxkj5Fp0ZkLvZ1ln7SGiWuXAJ8JlmAo/WTwr+pnOJZ6j4BOln1lEK
         /nEpeclJZuUUnrT67TJCVGsUo4MG0rKc9O08vq2q7+pgo94e1xt9gmFHYhgMSN4l7WYj
         nbrQFbe0U7eM4WSyAFHQAW5V3LkWpUKuhXm8g3BVveJMd5Wk8u+DxmIRHCfwu/3NMLZ1
         yqrA==
X-Gm-Message-State: APjAAAUdq2a34EL+pFZur2cUDXVbwxVIAk6jtv25RVBPju1w9suHWwps
        tMNa1MRpJOX2yYL9N8rOVVeGDfOA
X-Google-Smtp-Source: APXvYqygn1XWHvepEit/nvzpcmf/YAOxMoORr12mh3QvJRtrAnqk9LmmDqW1a//lzO/ydMfEfnnxGg==
X-Received: by 2002:a5d:500f:: with SMTP id e15mr8181342wrt.41.1562013746066;
        Mon, 01 Jul 2019 13:42:26 -0700 (PDT)
Received: from jong.localdomain ([77.127.68.150])
        by smtp.gmail.com with ESMTPSA id x6sm13073352wru.0.2019.07.01.13.42.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 13:42:25 -0700 (PDT)
Date:   Mon, 1 Jul 2019 23:42:23 +0300
From:   Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nat: Update obsolete comment on
  get_unique_tuple()
Message-ID: <20190701204222.GA1068@jong.localdomain>
References: <20190627212307.GB4897@jong.localdomain>
 <20190628090748.e42ymhe3huvuduhj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628090748.e42ymhe3huvuduhj@salvia>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 28, 2019 at 11:07:48AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 28, 2019 at 12:23:08AM +0300, Yonatan Goldschmidt wrote:
> > Commit c7232c9979cba ("netfilter: add protocol independent NAT core")
> > added nf_nat_core.c based on ipv4/netfilter/nf_nat_core.c,
> > with this comment copied.
> > 
> > Referred function doesn't exist anymore, and anyway since day one
> > of this file it should have referred the generic __nf_conntrack_confirm(),
> > added in 9fb9cbb1082d6.
> > 
> > Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
> > ---
> >  net/netfilter/nf_nat_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index 9ab410455992..3f6023ed4966 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
> >   * and NF_INET_LOCAL_OUT, we change the destination to map into the
> >   * range. It might not be possible to get a unique tuple, but we try.
> >   * At worst (or if we race), we will end up with a final duplicate in
> > - * __ip_conntrack_confirm and drop the packet. */
> > + * __nf_conntrack_confirm and drop the packet. */
> 
> I dislike this oneliners to update comments, I tend to think it's too
> much overhead a patch just to update something obvious to the reader.
> 
> However, I also understand you may want to fix this while passing by
> here.
> 
> So my sugggestion is that you run:
> 
>         git grep ip_conntrack
> 
> in the tree, searching for comments and documentation that can be
> updated, eg.
> 
> net/netfilter/nf_conntrack_proto_icmp.c:        /* See ip_conntrack_proto_tcp.c */
> 
> Please, only update comments / documentation in your patch.
> 
> The ip_conntrack_ prefix is legacy, that it was used by the time there
> was only support for IPv4 in the connection tracking system.
> 
> Thanks.

Okay, I've updated all comments which I found relevant, and made them refer
to current files/functions names.
I have retained comments referring to historical actions (i.e, comments like
"derived from ..." were not touched, even if the file it was derived from is
no longer here).

Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
---
 include/linux/netfilter/nf_conntrack_h323_asn1.h | 2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c               | 4 ++--
 net/netfilter/nf_conntrack_core.c                | 2 +-
 net/netfilter/nf_conntrack_h323_asn1.c           | 4 ++--
 net/netfilter/nf_conntrack_proto_gre.c           | 2 +-
 net/netfilter/nf_conntrack_proto_icmp.c          | 2 +-
 net/netfilter/nf_nat_core.c                      | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index 91d6275292a5..a3844e2cd531 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /****************************************************************************
- * ip_conntrack_h323_asn1.h - BER and PER decoding library for H.323
+ * nf_conntrack_h323_asn1.h - BER and PER decoding library for H.323
  * 			      conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 4d6bf7ac0792..6bdb1ab8af61 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -416,8 +416,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	     ctinfo == IP_CT_RELATED_REPLY))
 		return XT_CONTINUE;
 
-	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,
-	 * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
+	/* nf_conntrack_proto_icmp guarantees us that we only have ICMP_ECHO,
+	 * TIMESTAMP, INFO_REQUEST or ICMP_ADDRESS type icmp packets from here
 	 * on, which all have an ID field [relevant for hashing]. */
 
 	hash = clusterip_hashfn(skb, cipinfo->config);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4f9b8344a32..fd7d317951d4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1817,7 +1817,7 @@ EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
 #include <linux/mutex.h>
 
 /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
- * in ip_conntrack_core, since we don't want the protocols to autoload
+ * in nf_conntrack_core, since we don't want the protocols to autoload
  * or depend on ctnetlink */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple)
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 8f6ba8162f0b..e86b12bd19ed 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
+ * nf_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
  * 			      	     conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  *
- * See ip_conntrack_helper_h323_asn1.h for details.
+ * See nf_conntrack_helper_h323_asn1.h for details.
  */
 
 #ifdef __KERNEL__
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index c2eb365f1723..ceb492a418c1 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_proto_gre.c - Version 3.0
+ * nf_conntrack_proto_gre.c - Version 3.0
  *
  * Connection tracking protocol helper module for GRE.
  *
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a824367ed518..5f37aff3b2a9 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -215,7 +215,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 		return -NF_ACCEPT;
 	}
 
-	/* See ip_conntrack_proto_tcp.c */
+	/* See nf_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
 	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9ab410455992..3f6023ed4966 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
- * __ip_conntrack_confirm and drop the packet. */
+ * __nf_conntrack_confirm and drop the packet. */
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_tuple *orig_tuple,
