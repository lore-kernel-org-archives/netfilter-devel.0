Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC21C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 10:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0AA42087E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 10:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKUpxJl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfCAKnl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:43:41 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41254 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfCAKnl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 05:43:41 -0500
Received: by mail-pg1-f196.google.com with SMTP id m1so11259129pgq.8
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2019 02:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=BDA9CNKtkjBGjcjllgGcr/YpIukfDqjGMv+3lB+hHz0=;
        b=lKUpxJl/ohKsr0D5QIzKKV6/N2LjF/YfbIWgTyh8YXhmhJ0rwUkFg47lzVk6B+xF8+
         2GdfX7eN7jE2qpMN82Q/KfSgW8VRFdpxLkxxz/LNOKZH7In6BU4oQzPMb1nl+i5eMMlP
         kPzvMTdbWG6NvMmmgLsMNgAIxp3GFR013xdyp3cSoEIXBKpil2hKiT005+PE3moko+vO
         YZcX/fpQ62k1eDcDSlVK5cvmxBjWhzyf0PFwsoeKnqHgrKl+9Rn96MvfJCtdeSipwqFI
         t7gn/GM9/mlU9wsHoN0iP4mrEY5Fx/Jyc/Lab/X3xGjyf3VU6vGEXG0EUVjnOwb58gl+
         dmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=BDA9CNKtkjBGjcjllgGcr/YpIukfDqjGMv+3lB+hHz0=;
        b=NaaHV68h+1ndVpWpOCDuYI+xTxnZo0PM9amhDCgQ7rfaGZ3hUCZzfXVQANRzzfK+9u
         EjOvyLmkYPSw1QbE4wPPy+r5MLtG1c9NEKqoTQv+S9KEcbs4KAylI0XAydIfA/jtcMSB
         s0n25xxiZ6OEZTjocfPaTNza+C+SCsIwXnvt1kFwqjhM7zzt16SFMax1F6xfZ2YL+C8G
         jjDrj8bbEwE3wHYO8whQlu+flsTzw5/eCJgjphlK9KDZQ+/yR6ntUeqVWbNqpr8vcWv2
         fTkrWk4HBnOAOfPBFKw9P2Q5wf084VIlhIAZOBLu5iVtNtNsPtI/zbKpl4xxaDUptPKl
         JKBA==
X-Gm-Message-State: AHQUAuaBNsVAg6fvngVv3Ovzz888UAHReI+v2Wz5eDcX0E8pbS/BgKP/
        NbIsBQBnKaP3s6PJjCdJcwM=
X-Google-Smtp-Source: APXvYqzIbFX/gWyCQQGrjHPM10v//0SXjDD82dkZ1e03Rd7l8z9qjGiLoq7u3DDN0dkiUWSl+nB4bg==
X-Received: by 2002:aa7:8497:: with SMTP id u23mr4887285pfn.253.1551437019885;
        Fri, 01 Mar 2019 02:43:39 -0800 (PST)
Received: from nebula ([103.210.49.131])
        by smtp.gmail.com with ESMTPSA id m64sm54148468pfi.149.2019.03.01.02.43.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Mar 2019 02:43:39 -0800 (PST)
Date:   Fri, 1 Mar 2019 16:13:31 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     pablo@netfilter.org, arturo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
Message-ID: <20190301104331.GA26805@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: tstamp-patch
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A090205.5C790CDA.0023,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
+ * @NFT_META_TSTAMP_NS: packet arrival time (skb->tstamp)
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
index 987d2d6ce624..adfa1f221946 100644
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
+		*dest = (u32)(timestamp >> 32);
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

