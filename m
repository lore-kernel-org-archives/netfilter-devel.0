Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647B6C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4194861215
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhKELnQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:43:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhKELnQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636112436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cWtVZ4cMNjJ1237bGlaEu8LUNRHNYSuwFn4zs6frNxM=;
        b=f5mAHFyRtwu1kNRhveLTPWsAC39oE6zzHON7La6JtvKuS+Aa6sfqnlQlbZFog/G2JU0Xyz
        +TkFES0MSPYoEwe5AkcMuiM9RWmiHIKiCmUZnL3+JFJEvlXGV+xTlBF+1b/9qvX90KNLHG
        egBMxjyNzUvY09n+/5JH/ETDq/+AOaE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-qf306z5tMU-uZtTmYuJqNA-1; Fri, 05 Nov 2021 07:40:35 -0400
X-MC-Unique: qf306z5tMU-uZtTmYuJqNA-1
Received: by mail-wr1-f71.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so2227969wru.23
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Nov 2021 04:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=cWtVZ4cMNjJ1237bGlaEu8LUNRHNYSuwFn4zs6frNxM=;
        b=nR7JqYn65ICvJyt9u2gojxH/e1aevORQv6HvteUBIjD4d3fClj/6gL+sjdlZiKne3T
         +r3Jix+lYLC+VEDFo3QcwXViOBrnyfy9HEwrAnsJHHJ27Sst4TMY/4MddREXbd/WJfMM
         ScR05iILGYJZnZ5VQRkfS9M0QiQls5POCQI2Nl7mziPcRDDr4zeRoqYUjT7Vx+2usVJE
         6477IWIoU+AqfxkGzMR5G1QwQWsrORcmhgcv1P1x5XF2rULAaxtkvCooifp088aCY+VY
         EgA1cX5IqKzo9vjyGQTpIoXCA8qrWiktpb5C0itsMFiKNrP6H0oRLL7Sjef5OXSDhhIQ
         rQNA==
X-Gm-Message-State: AOAM5307aKE9Twwy1iQ/GKoJXH/IPDB2LJj8YIJu/MsqceXN3QCrPvWv
        F+p5n402MQauTv+B33h/1r+PnQuQTTPvjBxzzPUM8j9OTFpJ0leFKqnrV+93lGCoyGoILApddVa
        oHZi7+P49sjqaTA+lEcKxyaXeKlLa
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr8841669wmq.138.1636112434268;
        Fri, 05 Nov 2021 04:40:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxoIMil2X9n7gzs0sCqOzSTkuIq93tYPekIG5QjAVrbPe3Q8+2BKj5Vj4ZNjoZHAEVDJrcjw==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr8841658wmq.138.1636112434151;
        Fri, 05 Nov 2021 04:40:34 -0700 (PDT)
Received: from localhost ([185.112.167.34])
        by smtp.gmail.com with ESMTPSA id m17sm405029wrz.22.2021.11.05.04.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 04:40:33 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft] tests: shell: $NFT needs to be invoked unquoted
In-Reply-To: <YYEi9gPdID3GTGg5@salvia>
References: <20211021175438.758386-1-snemec@redhat.com>
 <YYEi9gPdID3GTGg5@salvia>
User-Agent: Notmuch/0.34 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Fri, 05 Nov 2021 12:41:22 +0100
Message-ID: <20211105124122+0100.915351-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 02 Nov 2021 12:37:26 +0100
Pablo Neira Ayuso wrote:

>> This would be best applied on top of the README series (otherwise
>> the README still talks about $NFT being a path to a binary).
>
> OK, then I'll mark this one as "Changed Requested" and will wait for
> you to include this one in the v2 of you README series.

Resubmitted now as <20211105113911.153006-4-snemec@redhat.com>.

Thanks,

  =C5=A0t=C4=9Bp=C3=A1n

