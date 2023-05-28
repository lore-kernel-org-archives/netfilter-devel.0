Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E413C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjE1TPY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjE1TPX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF3AC4;
        Sun, 28 May 2023 12:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC67F6197E;
        Sun, 28 May 2023 19:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15714C433D2;
        Sun, 28 May 2023 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301320;
        bh=JxHPDKDYzVppuuwiXIsri3v/d5JAGQaFs0FQSUDYTF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKr1kSaIlTvc8GcfT4dDr4KMvvId72E5C1UovlIPdHaOPm1C6DVB1kiWlNY8joIoO
         JVyXgNbmH0Dn6XHk5uBf8WUMEDuBLYgYxqqAkJiuv+rjxVuP4Thc9aF4v6wjZ0oCez
         yKRXKLK9s+r3vGFeiS4w+cpLftUrsNHaHRDqAizI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 69/86] netfilter: nf_tables: do not allow SET_ID to refer to another table
Date:   Sun, 28 May 2023 20:10:43 +0100
Message-Id: <20230528190831.198763104@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 470ee20e069a6d05ae549f7d0ef2bdbcee6a81b2 ]

When doing lookups for sets on the same batch by using its ID, a set from a
different table can be used.

Then, when the table is removed, a reference to the set may be kept after
the set is freed, leading to a potential use-after-free.

When looking for sets by ID, use the table that was used for the lookup by
name, and only return sets belonging to that same table.

This fixes CVE-2022-2586, also reported as ZDI-CAN-17470.

Reported-by: Team Orca of Sea Security (@seasecresponse)
Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -381,6 +381,7 @@ void nft_unregister_set(struct nft_set_t
  *
  *	@list: table set list node
  *	@bindings: list of set bindings
+ *	@table: table this set belongs to
  * 	@name: name of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
  * 	@dtype: data type (verdict or numeric type defined by userspace)
@@ -404,6 +405,7 @@ void nft_unregister_set(struct nft_set_t
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
+	struct nft_table		*table;
 	char				*name;
 	u32				ktype;
 	u32				dtype;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2746,6 +2746,7 @@ static struct nft_set *nf_tables_set_loo
 }
 
 static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
+						 const struct nft_table *table,
 						 const struct nlattr *nla,
 						 u8 genmask)
 {
@@ -2757,6 +2758,7 @@ static struct nft_set *nf_tables_set_loo
 			struct nft_set *set = nft_trans_set(trans);
 
 			if (id == nft_trans_set_id(trans) &&
+			    set->table == table &&
 			    nft_active_genmask(set, genmask))
 				return set;
 		}
@@ -2777,7 +2779,7 @@ struct nft_set *nft_set_lookup(const str
 		if (!nla_set_id)
 			return set;
 
-		set = nf_tables_set_lookup_byid(net, nla_set_id, genmask);
+		set = nf_tables_set_lookup_byid(net, table, nla_set_id, genmask);
 	}
 	return set;
 }
@@ -3272,6 +3274,7 @@ static int nf_tables_newset(struct net *
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	set->table = table;
 	set->ops   = ops;
 	set->ktype = ktype;
 	set->klen  = desc.klen;
@@ -4209,7 +4212,7 @@ static int nf_tables_newsetelem(struct n
 				   genmask);
 	if (IS_ERR(set)) {
 		if (nla[NFTA_SET_ELEM_LIST_SET_ID]) {
-			set = nf_tables_set_lookup_byid(net,
+			set = nf_tables_set_lookup_byid(net, ctx.table,
 					nla[NFTA_SET_ELEM_LIST_SET_ID],
 					genmask);
 		}


