Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA523C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 09:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A0E2085A
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 09:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQ2pe+YC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbfCAJYK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:24:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39692 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbfCAJYJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 04:24:09 -0500
Received: by mail-pf1-f196.google.com with SMTP id i20so11148491pfo.6
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2019 01:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=lX79MbtfNyBPZrOfTE2fFPTZw39QfwS+zz3UDmDhn4s=;
        b=PQ2pe+YCKpy5dVMyzgsnfIXO0a5JLKN1N8THF+WlGNbX85uUImxHEotI8gBeumBzrw
         9GbxHBrdXFt6MPx0B21NtFbGhBS5AeFwd03e83djaMTqxM4SnSoA0efCJ1SecvqQ0O6Q
         r5Ben5ba0/qV3/y+fKw6pRVOHWEnKrYwMd+85bTFSCkzyeVX3zB+SpK1TS1Vod1XaOUM
         tGk5vRqB/Nny4QULojutpeQHYzTxQ+rh+IDc9e1bqZ6FeGdFVeG5UlvkrB8DgSTTWnGB
         Al4oHvgQ+hbnThCklG1/CvK+LwQnn/9VgIyumVy3cmcvRDO8jHztHmxPwtmKUgF94TM0
         +xNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=lX79MbtfNyBPZrOfTE2fFPTZw39QfwS+zz3UDmDhn4s=;
        b=h8tAYiscgOP6Yl7jicijKPuXSvphWGpAsa5kFR8dG83hBw8Q7ggiAXc2cUbGQ4LEqx
         dDvF9U6gwioE8gsqZKsz5pKs2TF24aNvyXZpLcpi4+FAgmjQx2dffRbP8WSSJOZF01tO
         tFcIn/swIUo4aOUeLoV9E0UZnh/VXLMii1/eikPiQVJuELKZqf5qhID3U09MvqM9Ripv
         QBcaPZuXi6eEHoayvqYJj00nNsdrXPJZ4pqqKBeDxdwfOPJJ3cuY3UHBhi3XTQ7F+gFZ
         0VC+0E6HiaCfcqC5i0x3TjD5nydO+FgZjOv9SFD1PmajQ/pMhvqSgl0NrQVL+4WCeE4N
         SJnQ==
X-Gm-Message-State: APjAAAWN1xRBd8R+FhCRTjmX2zZKdhQtaL1xzwoJYPcsHfJLAY9a3uPO
        VcB3ADlV/Loo19/1Ibr5Xvk=
X-Google-Smtp-Source: APXvYqxRl4OtnsPEtzkxQ+1BVRIPMIw/keezqoz3v2yfFGLpPoqa3tj4d8NzpXWJqyPQi18YXovSbQ==
X-Received: by 2002:a63:ed0b:: with SMTP id d11mr3861375pgi.435.1551432247091;
        Fri, 01 Mar 2019 01:24:07 -0800 (PST)
Received: from nebula ([103.210.49.131])
        by smtp.gmail.com with ESMTPSA id k22sm1293660pfi.90.2019.03.01.01.24.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Mar 2019 01:24:06 -0800 (PST)
Date:   Fri, 1 Mar 2019 14:54:01 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     pablo@netfilter.org, arturo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
Message-ID: <20190301092401.GA17755@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: nft-meta-tstamp-patch
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A150206.5C78FA36.000D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score:  0.000
X-CTCH-ScoreCust:  0.000
X-CTCH-Rules:  
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Meta evaluation function is extended to suport NFT_META_TSTAMP_NS option
by exposing the 64 bit timestamp of the packet to two 32 bit registers.

Signed-off-by: Karuna Grewal <karunagrewal98@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a66c8de006cc..61f8f604c614 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_TSTAMP_NS: packet arriavl time (skb->tstamp)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -823,6 +824,7 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_TSTAMP_NS
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 987d2d6ce624..4eeda9ae8369 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -254,6 +254,13 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
+	case NFT_META_TSTAMP_NS:
+		if (skb->tstamp == 0)
+			__net_timestamp((struct sk_buff *)skb);
+		u64 timestamp = ktime_to_ns(skb->tstamp);
+		*dest = (u32) timestamp >> 32;
+		*(dest + 1) = (u32) timestamp;
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -371,6 +378,8 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 #endif
+	case NFT_META_TSTAMP_NS:
+		len = sizeof(u64);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

