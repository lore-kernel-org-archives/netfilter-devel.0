Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7E4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 16:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiCPQl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiCPQl0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 12:41:26 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE9D6CA58
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 09:40:11 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id q189so2928552oia.9
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 09:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from
         :subject:to:content-transfer-encoding;
        bh=tUDhW3BdIlljrrXGlcJw/9FCHfpSFHBBuH4IRLMeg60=;
        b=ks5OKxf+OfRyIZf2SPAG5fb3MG82SDcH8Z14AodxSaYJP2CTCTZl1+wdSDcNrmOGn8
         61FxW/m66zM7u8XTvnpAP6abkfBXSfSV+7qxHIyrKqc3nG2dOocKoxKOgBGIpD1rohSQ
         6PwGDNFVQ1GSSu9PagB1tgGhDGQoJJcmSZmGWLG90kP+LatWKqoB22fYcq7Jf/4ovcm5
         T9nEBlAaXMuI8NwJytaVlbyhqByqnTJg64bEZrMQzaTwqj9GJozaWnIlEwSwa927XY7G
         x654LhblmQLLsWZGJzxtd4VdNWlnEiyf4+70HbmAUs1UceFTsJym2bEHqX48AOpG97+J
         LaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:to:content-transfer-encoding;
        bh=tUDhW3BdIlljrrXGlcJw/9FCHfpSFHBBuH4IRLMeg60=;
        b=wGlcHwDsHqRNaVIDRo1XQ9F/8DWHcyVhFo0egxlMH04rPxbWjLFMzWWNk2mfzufA5z
         rzX9USfLZ3c2qrSI+R6OBiVxUsDEgTm9vDz6iFP8UVaeSsWKOt8HzzK6yWf9qTFcMa75
         7fbDJq++w8+IjT2bvZoXQ/NeZfxUjW5fSOG3Fno1P6HUpOGBztBQSTodRtavHousPzO1
         qbCjXifNe/zcn0qpV17nfReHQU2cJy5+xUEV/XN19XAjhpm5ailXPhI9Fts+TxYIrIz3
         bXpKkiyo/rlYnB7foQqAXKE8MtCdIDC4TVdJUqFnqjfJ3MJjCtM/22oILme2nTA62R9D
         ZMCA==
X-Gm-Message-State: AOAM532YINEuzaiYIGb80AgwX2w8CFbISM8TKDUsGH30/J8eaMUfDtls
        CmKhfIjkDm928GNVTyDtsLaVzwiQotE=
X-Google-Smtp-Source: ABdhPJzznSdhDWSLopTU4us0PfPj7wXjRex37yX+7oM232iMKTg5M3h+fwHE0YK/e/xaRG6wOgbIPg==
X-Received: by 2002:a05:6808:ece:b0:2da:70a4:f351 with SMTP id q14-20020a0568080ece00b002da70a4f351mr219504oiv.94.1647448810829;
        Wed, 16 Mar 2022 09:40:10 -0700 (PDT)
Received: from [172.31.250.1] ([47.184.51.90])
        by smtp.gmail.com with ESMTPSA id i126-20020acab884000000b002d9f958bceesm1110923oif.41.2022.03.16.09.40.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 09:40:10 -0700 (PDT)
Message-ID: <86f13f61-ffae-1130-12fa-f638da3558a2@gmail.com>
Date:   Wed, 16 Mar 2022 11:40:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
X-Mozilla-News-Host: news://lore.kernel.org:119
Content-Language: en-US
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: "Decoding" ipset error codes
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am using libmnl to add entries to an IP set.  (Code here[1] if anyone
is interested.)  I've got everything working, but I haven't yet found a
way to "decode" any protocol-specific errors that may be returned,
because the set is not of the correct type, for example.

I see that libipset has an ipset_errcode() function but it looks to be
designed for use only when libipset is being used for the actual netlink
communication.  (I didn't do that in this case, because libipset looks
to be targeted only on parsing and executing commands that are passed to
the ipset command.  It didn't make any sense to me to create a command
string in a buffer just so libipset could parse it back into information
that is already known.)

Is there any way that I can give users of my program something more
helpful than "unknown error XXXX"?

Thanks!

[1] https://github.com/ipilcher/fdf/blob/main/src/filters/ipset.c

-- 
========================================================================
Google                                      Where SkyNet meets Idiocracy
========================================================================
