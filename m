Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E856CC677F1
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 16:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjAPQoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 11:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjAPQn2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 11:43:28 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8DF2BEC4
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 08:31:16 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id b5so6837821wrn.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 08:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoN/h/ulsDlhYgr7p+RY+w0vqY2KGA41fSdDK5/tNsI=;
        b=tmTiMCRRHIyiaIX/awiYhhjKQXCo5tveDNVoR0XeQVhwC1j5T1is0JBfl/qGz4v5A5
         pbw9Eldh41FX5dnWDxhdQw4N8vr/DHJflT3IyTQvDv5dLyzQXhcfbfbQf2/WI5fJ1Jro
         Eie+0cCvqUsWirOUaQ8fi6zbbIsfN0kSilOBG2iAnCyTAG/lE3K5/4ucbwgm9PTE7UmN
         7TY7j2vf+4ZRRGDCjIH3HBr3b9p2Tp20R8wcjzrQCAhC50IIsi31aJOSU9PqaT/utsbk
         MiSG5t+5Llh63hPdlJ+a9B6AbAgg+UBDtnYZYlLH5s2Uo+J1WBCaFGohN62Y8LsF6iXi
         V7Nw==
X-Gm-Message-State: AFqh2kqBosm/zzUSujn0ZJa9+c38/pfBRWrSJJUbpm963Cj7WBDruC4z
        qd91WrvgKRUFFqg4TH/eenOxiLqUa8OLyA==
X-Google-Smtp-Source: AMrXdXtwMUiIvfqBqLf1M0ve5FsJp9FPkQb1Z1MQcyBh7pcjCZv2yJnBoi42Zk7vqgVsdTLCGGSzCg==
X-Received: by 2002:a5d:5f03:0:b0:27a:d81:1137 with SMTP id cl3-20020a5d5f03000000b0027a0d811137mr10656316wrb.38.1673886674685;
        Mon, 16 Jan 2023 08:31:14 -0800 (PST)
Received: from ?IPV6:2a0c:5a85:a202:ef00:af78:1e88:4132:af3? ([2a0c:5a85:a202:ef00:af78:1e88:4132:af3])
        by smtp.gmail.com with ESMTPSA id i10-20020adff30a000000b0024228b0b932sm32162939wro.27.2023.01.16.08.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 08:31:14 -0800 (PST)
Message-ID: <bd44c303-53d9-9f4e-ca42-ff12e20fd572@netfilter.org>
Date:   Mon, 16 Jan 2023 17:31:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>
References: <20230112225517.31560-1-jengelh@inai.de>
 <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc> <Y8U7wlJxOvWK7Vpw@salvia>
Cc:     netfilter-devel@vger.kernel.org
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <Y8U7wlJxOvWK7Vpw@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 1/16/23 12:57, Pablo Neira Ayuso wrote:
>> While being at it, I wonder about ethertypes: At least on the distros I
>> run locally, the file is provided by other packages than iptables. Do we
>> still need it? (It was added by Arturo for parity with legacy ebtables
>> in [3].)
> IIRC ebtables is using a custom ethertype file, because definitions
> are different there.
> 
> But is this installed file used in any way these days?

+1 to deleting it.

At least in Debian it is installed in other package and of no use here.
