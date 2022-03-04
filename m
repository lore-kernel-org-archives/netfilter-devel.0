Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605AAC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 11:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiCDLMw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 06:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiCDLMo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 06:12:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BAB3198D0B
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 03:11:57 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 20A0762FE6;
        Fri,  4 Mar 2022 12:10:19 +0100 (CET)
Date:   Fri, 4 Mar 2022 12:11:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] misspell: Avoid segfault with anonymous chains
Message-ID: <YiHz+bNsLvFjkPit@salvia>
References: <20220304103711.23355-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9hmp1YfcNSSRzfi/"
Content-Disposition: inline
In-Reply-To: <20220304103711.23355-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9hmp1YfcNSSRzfi/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Phil,

On Fri, Mar 04, 2022 at 11:37:11AM +0100, Phil Sutter wrote:
> When trying to add a rule which contains an anonymous chain to a
> non-existent chain, string_misspell_update() is called with a NULL
> string because the anonymous chain has no name. Avoid this by making the
> function NULL-pointer tolerant.
> 
> c330152b7f777 ("src: support for implicit chain bindings")
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/misspell.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/misspell.c b/src/misspell.c
> index 6536d7557a445..f213a240005e6 100644
> --- a/src/misspell.c
> +++ b/src/misspell.c
> @@ -80,8 +80,8 @@ int string_misspell_update(const char *a, const char *b,
>  {
>  	unsigned int len_a, len_b, max_len, min_len, distance, threshold;
>  
> -	len_a = strlen(a);
> -	len_b = strlen(b);
> +	len_a = a ? strlen(a) : 0;
> +	len_b = b ? strlen(b) : 0;

string_distance() assumes non-NULL too.

probably shortcircuit chain_lookup_fuzzy() earlier since h->chain.name
is always NULL, to avoid the useless loop.

Patch attached.

>  	max_len = max(len_a, len_b);
>  	min_len = min(len_a, len_b);
> -- 
> 2.34.1
> 

--9hmp1YfcNSSRzfi/
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/rule.c b/src/rule.c
index b1700c40079d..19b8cb0323ee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -758,6 +758,9 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 	struct table *table;
 	struct chain *chain;
 
+	if (!h->chain.name)
+		return NULL;
+
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {

--9hmp1YfcNSSRzfi/--
