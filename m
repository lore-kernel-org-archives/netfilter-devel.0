Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EEEC433ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Apr 2021 19:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BEC261381
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Apr 2021 19:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhDDTwl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Apr 2021 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhDDTwl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Apr 2021 15:52:41 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DC7C061756
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Apr 2021 12:52:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b9so1340506wrs.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Apr 2021 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=lDykz69cuM0N6tSPEK/I3WOdFpwSeM3/yDYEZSAfang=;
        b=rH0atxSEP2L9cqsmrdNA+TvRON+hClEcsaUsudYeMtszSn5fArRHLVeg6de/nn/qvz
         JevjVXsBPqMs+j5zbQ3ZtcIk9SfonFIoGGKbFDdoV2ksJc4zi5mW3YCoFNqHyNwLkUqG
         iDq2v4c/Sn94u4+l5w2C1kfJeBrfiUmT8indyXe6NrY9R9/A/y/Nvr+XWmOXThomcZ5E
         spIPXvRviC3WowwjWUrjZfSlHbvOMGd69I6xpaDum46vtS0a7WiN+HN97QAvDdcqKcmw
         Wr+ixnMAC2Y2h3CuN2K/X25mZP05+aA44c+xaOIc7qSvwtduZVt7XoAzY3qIXx4f9OMU
         sU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=lDykz69cuM0N6tSPEK/I3WOdFpwSeM3/yDYEZSAfang=;
        b=O47HZpT8fjWUmepDcl9Fg8vEbPMzbEXLLKeOn9XHljyhkezkxkEy3+9bIDkieR18GD
         VxHzYRtVa+ZKUU3eIoVThieDhMl1TqqO7Izs4fePRnCkp7bxZF9pH+lh175938rW3T9h
         ZlL9PrXZkGzqBq3nJoIv+TCLc/lCSgxr/eipTNDIg1uAnJpTd14jwxr8UCIj1mtaPTF8
         PshC3rweYBNyw/j358As3gF93k0V82ZBk+fg2RMMca+0vKN6/18F6e0QZU9Fa0xqQ4yy
         Sui3kqbNE06y9fEl4cXN3X14+d2Egx1kn0LhGXaqVeH2cijwfLmh9JD3AGGxMmw8teLK
         nJxQ==
X-Gm-Message-State: AOAM532Yr9oPYptRIxU+xy7ZzKwFRPMd0sQZawUaFzMh5MWGxZGtvKCR
        mTVAInw0yairhlAldOQcoWvK3S1eYJc=
X-Google-Smtp-Source: ABdhPJy5q1Xll5+V6plEzrwB3pSCxIraplhTmDCnhKEHweqzn3x8Cladl7BV7q6RduZw9Hp0E9E4mw==
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr25631436wrz.362.1617565953255;
        Sun, 04 Apr 2021 12:52:33 -0700 (PDT)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id e13sm28225565wrg.72.2021.04.04.12.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 12:52:32 -0700 (PDT)
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Welte <laforge@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Subject: Unused macro
Message-ID: <f209f7b0-af4c-e41c-b53e-27028b925978@gmail.com>
Date:   Sun, 4 Apr 2021 21:52:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I was updating the includes on some manual pages, when I found that a
macro used ARRAY_SIZE() without including a header that defines it.
That surprised me, because it would more than likely result in a compile
error, but of course, the macro wasn't being used:

.../linux$ grep -rn SCTP_CHUNKMAP_IS_ALL_SET
include/uapi/linux/netfilter/xt_sctp.h:80:#define
SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
.../linux$

I'd remove it myself and send a patch, but there are probably more
unused macros/functions in the same or related headers, and I see that
many years ago you did some clean up, so maybe you want to clean up even
more, and maybe remove an entire set of functions/macros.

Cheers,

Alex

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
