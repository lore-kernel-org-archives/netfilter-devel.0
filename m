Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C986C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D7F20868
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaNcDfbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfCHR3u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:29:50 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36427 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfCHR3u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:29:50 -0500
Received: by mail-pg1-f196.google.com with SMTP id r124so14663889pgr.3
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=fP9E162o+6cT1V7FgQZ3E9bqfglM7HcXFxWvTMDiEg8=;
        b=GaNcDfbQi8ilnhrz9AxM9ZjBFpoEQAHpjjPqLunXTPXeqTzfuSd9TlYSlIRK8uDYBd
         UfrA8C/wHlvnZCu/5X2R18t6Rz8nM7Lyoq/ZjbJ3acCODNMWdF9lXHZS9nG+r1DLq6Hy
         h0D492V95Y7yp6+rZ0qqY2CwALfCQ5kRMd6GzxrRedWooEupn8RovEZvfQPZSVZVZJL8
         oUxvC0/YC3PBw8fpGZ0PK25+s7TuXw2vojSQsCKV0Q8DLDvuhZVziqo7FreewDswRArr
         To3AQu7Ldy9Ok2cLTjY4wBX/GD2+s3YYVXXsSWywH3s6laOdSBCrwgZQ+i9W6o8Er4IV
         Y2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=fP9E162o+6cT1V7FgQZ3E9bqfglM7HcXFxWvTMDiEg8=;
        b=M9K8O+PZEvuHuecb16W+tPRqFsOYtF2tJ3unjsBKsMHTN2IrB835uKTkHNPUoo+YvN
         uHPraX6cG/tD97bZ8IbYszcDdq2xJ7YwIMVwolvuhufD+5bTZ3LOchMc5V1hbQJfs/hj
         7ij2WBA2mLNiqKs88/6BTVwlXkViUpug1cUagFgy0T7hrEdVFxvolZiivN+3JPRV8RHt
         fFUGN0eshkD7hpPURikmrDoMHqtKbzmQLNFa4gpe1GUXuL7Oj9HxpCwjBPQrzKqhsYeM
         a+rUZzzY69SdsTe7bYO4NFFqaaFDQ0YDohnPFHqAOKDglMj9RJ8UKX6oqPyBG8Yoee3l
         vEfw==
X-Gm-Message-State: APjAAAVE30nI+Cf8vgs6Ngub9sr+zepcwHZAWsLYV5kYRgV6VeYBOcwG
        DnLOYMeSo/a4+fC9B042Zl8=
X-Google-Smtp-Source: APXvYqz1e9uvpXfPMnFnm7o1apHlmwkpaQrsFn73eWDSOBTVi2/WBSmK07LMsWwmN/7Rjn4PaH+puw==
X-Received: by 2002:a63:e654:: with SMTP id p20mr631923pgj.345.1552066189505;
        Fri, 08 Mar 2019 09:29:49 -0800 (PST)
Received: from nebula ([103.210.49.131])
        by smtp.gmail.com with ESMTPSA id k75sm24896040pfj.46.2019.03.08.09.29.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Mar 2019 09:29:48 -0800 (PST)
Date:   Fri, 8 Mar 2019 22:59:44 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] meta: Add support for `time`
Message-ID: <20190308172944.GA21564@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: meta `time` patch
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A090202.5C82A68C.003D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score:  0.000
X-CTCH-ScoreCust:  0.000
X-CTCH-Rules:  
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

meta `time` can be used to match the timestamp of a packet.

Signed-off-by: Karuna Grewal <karunagrewal98@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/meta.c                          | 3 +++
 src/parser_bison.y                  | 1 +
 src/scanner.l                       | 1 +
 4 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 37036be0..a20fc966 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -791,6 +791,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_TSTAMP_NS: packet arrival time (skb->tstamp)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -821,6 +822,7 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_TSTAMP_NS,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 7e44a2a3..1b35e508 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -450,6 +450,9 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_TSTAMP_NS] = META_TEMPLATE("timestamp", &time_type,
+						8 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b20be3a8..58914486 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3874,6 +3874,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
 			|       CGROUP		{ $$ = NFT_META_CGROUP; }
 			|       IPSEC		{ $$ = NFT_META_SECPATH; }
+			|	TIMESTAMP	{ $$ = NFT_META_TSTAMP_NS; }
 			;
 
 meta_stmt		:	META	meta_key	SET	stmt_expr
diff --git a/src/scanner.l b/src/scanner.l
index 6f83aa11..bfb8c558 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -507,6 +507,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "iifgroup"		{ return IIFGROUP; }
 "oifgroup"		{ return OIFGROUP; }
 "cgroup"		{ return CGROUP; }
+"time"			{ return TIMESTAMP; }
 
 "classid"		{ return CLASSID; }
 "nexthop"		{ return NEXTHOP; }
-- 
2.17.1

