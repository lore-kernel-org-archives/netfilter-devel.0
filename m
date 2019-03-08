Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C04CC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B5820851
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7sZPfQj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfCHRZy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:25:54 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43653 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfCHRZy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:25:54 -0500
Received: by mail-pf1-f176.google.com with SMTP id q17so14610151pfh.10
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=IBb1uIZIsFaa3W4BhOz7TP/w4PWyaKYGtyDZsxFhQfs=;
        b=g7sZPfQj3E9SnJPt9FQj+uHbTneYSgnYSjizqdPcVzweXzPYQvezkQKMJdMF6+KVlG
         nmFClEQQMhwyVuv78uGc/bNXOErVH9UXBRyAHD2odSg8QL01fUSl34m2KutThwZjrkgp
         rFSKpMq5NYW0mOuJDD6f9j288+LSCAB9Dy4wwBNwGkbSIUxhziwZ3HdV6uJa2X2YGoZT
         v9leMScXiNsIddMFISh+Ygx/6OT24qqcefUiTxqlkI6qRd0wZYGWaTZJDWLDFXaJb2dt
         4+BPNxxLdRM/2laR2X6gTa6T6oK/vADlE9fG2ROs02jY1NeBNtEURX88gJahjgFK/ttU
         fWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=IBb1uIZIsFaa3W4BhOz7TP/w4PWyaKYGtyDZsxFhQfs=;
        b=HqwyjOAiy2fOmsIr5+HPaQlFt2JDc487w/bkRouU58gZbLe4V9IfUo70DTSpjxvLA7
         MaAXifzPe+1xYNQpUzUL9EGrecCw6WpOz96sPXKLZEZjUUC7Ox1xAnUfaJ470AI+AX/V
         Klvba3UAN8NVnDOlGFVwNtiGz5pEXEa1d0v3UJRmQm7EzCmjSjFHIcZu+blmllM5cGGa
         7joZehOxSW8Fqp2aHs3x+O16FV3yqtajEZcBzGVH8Zi7LTR83lENQQcD1DsW1CD0zjbw
         l+WAFj5FI6K+gfJsQergSiekOiK0r0AmO9LO+iAKycUCS5hpE4mCLoSm0L+yM93DZUJk
         cfjg==
X-Gm-Message-State: APjAAAWeMrXnP/kAoSrTOuG7wELkHhQRJwRTTu4hZ3BGPMYwNv7rPBBy
        ekylZW1lQ1hpjl4O1MgAtFTkddT/
X-Google-Smtp-Source: APXvYqwDGJXuGaQEXIGuaG+SgieJ9uNf5jiuPQpCkhPsS89KTPOkndnsV0sPpf+vP5Jb3ALacXo+1A==
X-Received: by 2002:a17:902:9a88:: with SMTP id w8mr20012587plp.8.1552065953462;
        Fri, 08 Mar 2019 09:25:53 -0800 (PST)
Received: from nebula ([103.210.49.131])
        by smtp.gmail.com with ESMTPSA id h63sm29821638pfd.148.2019.03.08.09.25.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Mar 2019 09:25:52 -0800 (PST)
Date:   Fri, 8 Mar 2019 22:55:47 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCHv3] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
Message-ID: <20190308172547.GA21197@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: v3 timestamp patch
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A090203.5C82A5A0.0022,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
 net/netfilter/nft_meta.c                 | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a66c8de006cc..100398d406a0 100644
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
+	NFT_META_TSTAMP_NS,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 987d2d6ce624..6b40373e20e8 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -254,6 +254,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
+	case NFT_META_TSTAMP_NS:
+		if (skb->tstamp == 0)
+			__net_timestamp((struct sk_buff *)skb);
+		*((u64*)dest) = ktime_to_ns(skb->tstamp);
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -371,6 +376,9 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 #endif
+	case NFT_META_TSTAMP_NS:
+		len = sizeof(u64);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

