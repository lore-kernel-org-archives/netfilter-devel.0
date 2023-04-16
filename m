Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5303EC77B61
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Apr 2023 16:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjDPQLT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Apr 2023 12:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDPQLR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Apr 2023 12:11:17 -0400
X-Greylist: delayed 105 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 09:11:16 PDT
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [185.125.25.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD272698
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Apr 2023 09:11:16 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwCl1CP2zMq40f;
        Sun, 16 Apr 2023 18:11:15 +0200 (CEST)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwCk0hdHz1JK;
        Sun, 16 Apr 2023 18:11:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661475;
        bh=oPeltRRr2ytyRMblHC6/dJQm64MgLIylMhIXWK/EjOw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uVR8pkKMmDV9Ha2j8WXPoO7ZHRj99rTAKJIpmIQSHGtbIuU3xsEj+SQehmXEcNcKn
         HS9FpbIA9hggObcgNfzcxBcJLftZUvUV8J36oC44d8fczI0tmd2VypIW9Q8ugeAltf
         Ex1V951XYItubrRcfPJ1a/IRmp067B+gRupxqluw=
Message-ID: <25d2a813-4954-5e35-b13b-c48a8ce08c1a@digikod.net>
Date:   Sun, 16 Apr 2023 18:11:20 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 07/13] landlock: Refactor layer helpers
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-8-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-8-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> Add new key_type argument to the landlock_init_layer_masks() helper.
> Add a masks_array_size argument to the landlock_unmask_layers() helper.
> These modifications support implementing new rule types in the next
> Landlock versions.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * Refactors commit message.
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
>   security/landlock/fs.c      | 43 +++++++++++++++++--------------
>   security/landlock/ruleset.c | 50 +++++++++++++++++++++++++------------
>   security/landlock/ruleset.h | 17 +++++++------
>   3 files changed, 67 insertions(+), 43 deletions(-)
> 

[...]

> @@ -629,7 +629,11 @@ bool landlock_unmask_layers(
>   	return false;
>   }
> 
> -/**
> +typedef access_mask_t
> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
> +		  const u16 layer_level);
> +
> +/*

Please keep the "/**"


>    * landlock_init_layer_masks - Initialize layer masks from an access request
>    *
>    * Populates @layer_masks such that for each access right in @access_request,
