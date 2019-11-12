Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9660DC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 756032084E
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLLPM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:15:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33065 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLLPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 06:15:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id a17so2067171wmb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 03:15:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=O8nIa+QcXoM2+tApaW1MOjytBzmAWwRaRXrja3gagNM=;
        b=G/A1om9vpszMnGEFeaXQrQXSkk2EqBGBUevFs5BQ0NrBZGpyGqMJC7CxYwNanzPiqg
         CEY44aa5Jg+35yJzwI0uSJnAW3O8ZMY55SM0flS1mHLn6c5Yz2+OW6H/ouaw2UuKw0Ff
         +gwjLI3hRj2o8AUhtccxFaVI9P8nxo7Xch5pcb0Ts623kbRswaj9i8FHJeVYp84ole5L
         XgdsHF0P2NST6xrY4TAT9NuoMteJKOxrdZgy25UJQcSwn1ReJWfwggm0oCeK+nU9coEP
         I49dtKqlEU1flVE/zqz5HtuWiSiJlymKZLPYLgeQRtqO7VjaYGm5ztHRtL9v7uztAc40
         /4Jw==
X-Gm-Message-State: APjAAAWLeOMEZI1LqoHP14cb0QBUNg4KDJVBbiV2NRebKcw/b7ndIE2Z
        HSKQavbfKeeigRDfIaJ1BBRANemuFx8=
X-Google-Smtp-Source: APXvYqz1eYzkXBJRNRoP91qD68iXkE1KmSfnsja/THVdwzHGYvAjM5zwYe+WNl0ZdcQE/0ws637eyQ==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr3530669wmh.81.1573557309482;
        Tue, 12 Nov 2019 03:15:09 -0800 (PST)
Received: from [192.168.1.156] ([213.194.137.137])
        by smtp.gmail.com with ESMTPSA id q25sm24321700wra.3.2019.11.12.03.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 03:15:09 -0800 (PST)
Subject: Re: [nft PATCH 1/2] files: Drop shebangs from config files
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191107114516.9258-1-phil@nwl.cc>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <99bf1a8a-96e9-3ad6-bef4-3defe0da951b@netfilter.org>
Date:   Tue, 12 Nov 2019 12:15:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107114516.9258-1-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/7/19 12:45 PM, Phil Sutter wrote:
> These are not meant to be executed as is but instead loaded via
> 'nft -f' - all-in-one.nft even points this out in header comment.
> While being at it, drop two spelling mistakes found along the way.
> 
> Consequently remove executable bits - being registered in automake as
> dist_pkgsysconf_DATA, they're changed to 644 upon installation anyway.
> 
> Also there is obviously no need for replacement of nft binary path
> anymore, drop that bit from Makefile.am.

If you drop the shebang, the shell may not know how to execute these files. Why
not executing them with the python interpreter instead of `nft -f`?

As pablo commented, the intention was to allow simple use cases like:

root@server:~# ./load-my-ruleset.nft

This use case would still be allowed after this patch but it would be a little
less obvious (less examples). So I'm not sure about ACK'ing this patch.
