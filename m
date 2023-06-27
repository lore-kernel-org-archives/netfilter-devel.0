Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F356FEB64D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 14:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjF0O00 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 10:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjF0O0X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 10:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D462D67
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 07:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687875935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vGSc4mdTDNNjtXngrQkAE2Vk0OODhwWQe551QFWP1tI=;
        b=WZEcEPexuz1DZhqeEiUjCwjCyvfqLhVfmAaZ9iTMPujS17Ow50H4DtmHvp3QpMAvdx0i0l
        MMR4T47LW6DBcatwAeMV1ZBbpNflzOj8UrZWnuPSfTHmilMiDRSBwCKI9E49bVEX9zYpET
        ciVGWfTy8tic79J1pW2HmYAwEVxsWVg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-utv6vHmZNiu-r1Cw9L5XQg-1; Tue, 27 Jun 2023 10:25:22 -0400
X-MC-Unique: utv6vHmZNiu-r1Cw9L5XQg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a341efd9aso273877766b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 07:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687875915; x=1690467915;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGSc4mdTDNNjtXngrQkAE2Vk0OODhwWQe551QFWP1tI=;
        b=JVkzWuNJU/uNdG8R+owPzXb6T9TH7TC6YRR9LErYLppx8anPDhPUNhK9Q5lprMBGNw
         WV+nYVj06do/6Jbai69rVlmILPlSZ1ikaISL4o3/n/HNKCyINoaWOopRxN5+3LzCWKAJ
         7LWvNCFdXNf0Xc//gpMUI2Jt7uL1DC1O4lE1E+f5EgioPtPsC+8RA2kwxty0ACyr8/ij
         ufjua/QllZFdedXEPcRHt0cu5JM6zX0xoojSdlRUKghkCI3LfT6q5hGwaC0oKUKEzRQu
         losMd6oe3SM2JzMh9ZO00c2lx5x6a0da3stdhaQvFc8eSHsd8THqvWy4Gl71imJ1Mb2h
         Yapg==
X-Gm-Message-State: AC+VfDw1rMO6qeG1r0wV2v4SLQQ+UJsptAXFQ10B8dgf8n0Yqf233EqZ
        G4CyOnoY4qw2omYnYoozm/01YMBLxhdiYRvrT1X3stc6PTFEQGoIiLOAR9z0QUBUwmVm41Y2asc
        CGsqcVTZ4sg/HYBFwgo33eY4prLOQ
X-Received: by 2002:a17:906:da8b:b0:982:26c5:6525 with SMTP id xh11-20020a170906da8b00b0098226c56525mr32188639ejb.60.1687875914701;
        Tue, 27 Jun 2023 07:25:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6i5PkNbA3Uw3V9yHzNgEF6zgc+6XvzXai4Ju+na594EFjrV8ZjoKAuLT8tuRH4vcpCqG3Dfw==
X-Received: by 2002:a17:906:da8b:b0:982:26c5:6525 with SMTP id xh11-20020a170906da8b00b0098226c56525mr32188620ejb.60.1687875914199;
        Tue, 27 Jun 2023 07:25:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qn1-20020a170907210100b0098e42bef731sm3234766ejb.169.2023.06.27.07.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 07:25:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2921ABBFF6C; Tue, 27 Jun 2023 16:25:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, fw@strlen.de, daniel@iogearbox.net
Cc:     dsahern@kernel.org
Subject: Re: [PATCH bpf-next 0/7] Support defragmenting IPv(4|6) packets in BPF
In-Reply-To: <cover.1687819413.git.dxu@dxuuu.xyz>
References: <cover.1687819413.git.dxu@dxuuu.xyz>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 27 Jun 2023 16:25:13 +0200
Message-ID: <874jmthtiu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> The basic idea is we bump a refcnt on the netfilter defrag module and
> then run the bpf prog after the defrag module runs. This allows bpf
> progs to transparently see full, reassembled packets. The nice thing
> about this is that progs don't have to carry around logic to detect
> fragments.

One high-level comment after glancing through the series: Instead of
allocating a flag specifically for the defrag module, why not support
loading (and holding) arbitrary netfilter modules in the UAPI? If we
need to allocate a new flag every time someone wants to use a netfilter
module along with BPF we'll run out of flags pretty quickly :)

-Toke

