Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585DCC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Feb 2022 13:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240578AbiBWNWF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 08:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbiBWNWE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 08:22:04 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4236A205C4
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:21:35 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id v21so4330583wrv.5
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:21:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pdroY3vCF0uuZajtiZV4kVx3PM3Ak3BevRVawf7zdp8=;
        b=nAB4wjQldiLWXM68DNzW3HRei9kxpjCtZqBreCz/AWPfeBo+SrpIP275y2zyM1pyr9
         KW+dRFJGeY6kXPqwY5/KmvCXofmc7EOmcu3vjyQZ9nfSvbQo4x8Lj8KH+vbem9tSlOx8
         MAfU+WlobGsvCCDgEYYENDhTSjmkjRNWtmPInlju960Z2eY/RcPO95l8oF43yDMES9Z0
         6GerQfm/Fpm8nibvsJ8bKSOi6TYtDe2ljLH6G99S16jLN3OUpzyhHj4sdfJECevUPbV+
         u7rspEXGkOB3QFdH4FsbqRI1WzPpTfG9fr4ga9hf+VYmU7akdkKClsdPly9UxHCYCdqa
         AzxQ==
X-Gm-Message-State: AOAM531JDmQZNhXQu3AY2QBNeAii9LDhJ0Nl7lhlxSxJuZWZo/GWmk9Z
        Pm7gsiouwukp/Fd6Pp8h9nKEMcM8X54=
X-Google-Smtp-Source: ABdhPJzAqAESIKzd/JHuXDhQnyMAm1ATG9y+d1pTco7nbiVm+C4n/D0yMBfikC33qErZB9oYyAwgaQ==
X-Received: by 2002:adf:a54c:0:b0:1ed:ab82:d5c with SMTP id j12-20020adfa54c000000b001edab820d5cmr2359194wrb.636.1645622493667;
        Wed, 23 Feb 2022 05:21:33 -0800 (PST)
Received: from [10.48.11.228] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id g8sm51847863wrd.9.2022.02.23.05.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 05:21:33 -0800 (PST)
Message-ID: <d096f2ff-f1a9-45a3-c190-4c1ddd0ce277@netfilter.org>
Date:   Wed, 23 Feb 2022 14:21:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [ANNOUNCE] nftables 1.0.2 release
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <YhO5Pn+6+dgAgSd9@salvia>
 <7c75325e-f7c0-2354-3217-2735d8c3bbb6@netfilter.org>
 <YhUE38mgAKGV1WZn@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <YhUE38mgAKGV1WZn@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/22/22 16:44, Pablo Neira Ayuso wrote:
> It is fixed here, both things you mentioned:
> 
> http://git.netfilter.org/nftables/commit/?id=18a08fb7f0443f8bde83393bd6f69e23a04246b3


Worked! thanks.
