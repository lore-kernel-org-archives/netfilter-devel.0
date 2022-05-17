Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC262C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbiEQIPQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243069AbiEQIN3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:13:29 -0400
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB0449935
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:12:39 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L2TPZ5H7rzMrBqC;
        Tue, 17 May 2022 10:12:34 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L2TPZ1y6qzlhMC5;
        Tue, 17 May 2022 10:12:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652775154;
        bh=Wlo13ZQ1fjXEj/AZR+D+T5bedv0V+KydvqaxiHUOJb4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=i8mUt8stPxvNARDvMT22qV9SlqPmrMhW1geD9DVQPe805afS53dp4bBcbG6oy23Y6
         pwK2edYJdAwdX+H8yCYlTHz+XMFzKI9W0Bv077HHH7+7jWMo8tzPpBWymBO06/rtw9
         Ngrqtg1xJLWkJO915sPcTDAoEsLhJoO82TOPXQEk=
Message-ID: <a6300c07-87f5-21a4-8998-facbecd63787@digikod.net>
Date:   Tue, 17 May 2022 10:12:33 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v5 01/15] landlock: access mask renaming
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-2-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220516152038.39594-2-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> Currently Landlock supports filesystem
> restrictions. To support network type rules,
> this modification extends and renames
> ruleset's access masks.
> This patch adds filesystem helper functions
> to set and get filesystem mask. Also the modification
> adds a helper structure landlock_access_mask to
> support managing multiple access mask.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---

[...]

> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index d43231b783e4..f27a79624962 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -20,6 +20,7 @@
>   #include "object.h"
> 
>   typedef u16 access_mask_t;
> +
>   /* Makes sure all filesystem access rights can be stored. */

Please don't add whitespaces.
