Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5B8C636D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Feb 2023 17:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjBJRib (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Feb 2023 12:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjBJRib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Feb 2023 12:38:31 -0500
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079346BAAB
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Feb 2023 09:38:29 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PD1DM25wHzMrJDL;
        Fri, 10 Feb 2023 18:38:27 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PD1DL45KDzMrPCR;
        Fri, 10 Feb 2023 18:38:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676050707;
        bh=jr2lv39vZgJTLGDR+YqgnRYoPrOaNPqyPAvXACEpPFQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NP4wv1aE0bf93XmrA6fpjvuReN9+2Fk4oqAM4D3tayEFleXn4+xICnm844REtIgpm
         yLBOxSg55Oh/m0VEkbkes6cGXXWnHjXYP75m3RP7qSy1HQtRzMMj7xw4hYohl7of2T
         DPH1uRTUScTojxgzyppcR7nY983rsk7J9W9ErJWg=
Message-ID: <70b5c38d-117e-0b07-f942-8025a83a3df7@digikod.net>
Date:   Fri, 10 Feb 2023 18:38:25 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 06/12] landlock: Refactor _unmask_layers() and
 _init_layer_masks()
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-7-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-7-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> Add new key_type argument to the landlock_init_layer_masks() helper.
> Add a masks_array_size argument to the landlock_unmask_layers() helper.
> These modifications support implementing new rule types in the next
> Landlock versions.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * None.
> 
> Changes since v7:
> * Refactors commit message, adds a co-developer.
> * Minor fixes.
> 
> Changes since v6:
> * Removes masks_size attribute from init_layer_masks().
> * Refactors init_layer_masks() with new landlock_key_type.
> 
> Changes since v5:
> * Splits commit.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors init_layer_masks(), get_handled_accesses()
> and unmask_layers() functions to support multiple rule types.
> * Refactors landlock_get_fs_access_mask() function with
> LANDLOCK_MASK_ACCESS_FS mask.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_unmask_layers functions.
> 
> ---
>   security/landlock/fs.c      | 43 ++++++++++++++++--------------
>   security/landlock/ruleset.c | 52 ++++++++++++++++++++++++++-----------
>   security/landlock/ruleset.h | 17 ++++++------
>   3 files changed, 70 insertions(+), 42 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 73a7399f93ba..a73dbd3f9ddb 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
>

[...]

> @@ -658,10 +677,13 @@ access_mask_t landlock_init_layer_masks(
>   		const unsigned long access_req = access_request;
>   		unsigned long access_bit;
>   
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> +		for_each_set_bit(access_bit, &access_req, num_access) {
> +			/*
> +			 * Artificially handles all initially denied by default
> +			 * access rights.
> +			 */

No need to re-add this old comment which was removed with patch 2/12.


>   			if (BIT_ULL(access_bit) &
> -			    landlock_get_fs_access_mask(domain, layer_level)) {
> +			    get_access_mask(domain, layer_level)) {
>   				(*layer_masks)[access_bit] |=
>   					BIT_ULL(layer_level);
>   				handled_accesses |= BIT_ULL(access_bit);
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 60a3c4d4d961..77349764e111 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -266,14 +266,15 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
>   	       ACCESS_FS_INITIALLY_DENIED;
>   }
> -bool landlock_unmask_layers(
> -	const struct landlock_rule *const rule,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +bool landlock_unmask_layers(const struct landlock_rule *const rule,
> +			    const access_mask_t access_request,
> +			    layer_mask_t (*const layer_masks)[],
> +			    const size_t masks_array_size);
>   
> -access_mask_t landlock_init_layer_masks(
> -	const struct landlock_ruleset *const domain,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +access_mask_t
> +landlock_init_layer_masks(const struct landlock_ruleset *const domain,
> +			  const access_mask_t access_request,
> +			  layer_mask_t (*const layer_masks)[],
> +			  const enum landlock_key_type key_type);
>   
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
