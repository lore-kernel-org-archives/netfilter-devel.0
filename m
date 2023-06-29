Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801C8EB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jun 2023 14:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjF2Ogz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjF2Ogt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2023 10:36:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB735359C
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2023 07:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688049342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8R5NWbxG8vczdgWdFQsQrHOmepgax0uH77iAdWT6/Y=;
        b=ZeqEFldXQxd4stC+LTU/CDIxGXd8j9qMOIs5ln9skuWsy7zPakrIPSBtgdr/G4DoH/NMmL
        gP+/6mUvCYzst9GtAk8sFGqPauKBeAMuRv4MSuznNljLtYffQj5yCXKIFHxMvb+7iRw5Oe
        eFqzWdaC2CkdKG+emvRKJHn14qiEHGg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-vAN9iv-YMbGlgFL7mkaimA-1; Thu, 29 Jun 2023 10:35:40 -0400
X-MC-Unique: vAN9iv-YMbGlgFL7mkaimA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f9d7ff4b6aso3947335e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2023 07:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688049337; x=1690641337;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8R5NWbxG8vczdgWdFQsQrHOmepgax0uH77iAdWT6/Y=;
        b=dXgBvSzrHGiRIMleJVIFKJAzx/oOBDGpZQxKSv2zuuCIK+wjREdXZM0uMSRAns3/uZ
         A9snfTJGdNW514yuJ6vdTruAeHz4CSDby4HiGvqU0G3Fb9rPckPSnNlZmpWeINuIFW2W
         +yJ10ZCD2pLWz6CmLDC8MSO2yElAoqfCcoY8rL/fAmYCvot4ebtVLZA1SssCkguPAHK2
         1/veuttfX8/zY0q2P5sl1+haJ+R2HUYwyqSUTvda1vzDWxuw9KFdsFVfN3BeuzkpESOM
         r9q/8eR+cy8P43Bd24HrJI3RTawOsjivinfZfQAwSzJ9R4wX/XzBxOItmrER51Llw5m5
         7SXg==
X-Gm-Message-State: AC+VfDzAnJ3wWDlWRGyQEaZsZUXHbGtB2OLj0wtnDkej+mKwDT622er4
        V+PQECXRffD3P9WffWX7awFCMxgrX/duLxuNQBgR3RbpYizhWX1fzGym5+4i0TNgBink1XBINk4
        1h1+Eg4XO0n7nlH0jTerVHrPPi51c
X-Received: by 2002:a7b:cd1a:0:b0:3fb:7184:53eb with SMTP id f26-20020a7bcd1a000000b003fb718453ebmr7354219wmj.18.1688049336966;
        Thu, 29 Jun 2023 07:35:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6h7QlIhkGzTRnVyTU2NsDFOF3dILJkeijSsCDj9Q06ewfBcGoUzfIOspcHXewvLQsf+b6htQ==
X-Received: by 2002:a7b:cd1a:0:b0:3fb:7184:53eb with SMTP id f26-20020a7bcd1a000000b003fb718453ebmr7354206wmj.18.1688049336544;
        Thu, 29 Jun 2023 07:35:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c020e00b003fba92fad35sm4237514wmi.26.2023.06.29.07.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 07:35:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5FF87BC0476; Thu, 29 Jun 2023 16:35:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>, Daniel Xu <dxu@dxuuu.xyz>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        daniel@iogearbox.net, dsahern@kernel.org
Subject: Re: [PATCH bpf-next 0/7] Support defragmenting IPv(4|6) packets in BPF
In-Reply-To: <20230629132141.GA10165@breakpoint.cc>
References: <cover.1687819413.git.dxu@dxuuu.xyz> <874jmthtiu.fsf@toke.dk>
 <20230627154439.GA18285@breakpoint.cc> <87o7kyfoqf.fsf@toke.dk>
 <20230629132141.GA10165@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Jun 2023 16:35:35 +0200
Message-ID: <87leg2fia0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> Florian Westphal <fw@strlen.de> writes:
>> > For bpf a flag during link attachment seemed like the best way
>> > to go.
>>=20
>> Right, I wasn't disputing that having a flag to load a module was a good
>> idea. On the contrary, I was thinking we'd need many more of these
>> if/when BPF wants to take advantage of more netfilter code. Say, if a
>> BPF module wants to call into TPROXY, that module would also need go be
>> loaded and kept around, no?
>
> That seems to be a different topic that has nothing to do with
> either bpf_link or netfilter?
>
> If the program calls into say, TPROXY, then I'd expect that this needs
> to be handled via kfuncs, no? Or if I misunderstand, what do you mean
> by "call into TPROXY"?
>
> And if so, thats already handled at bpf_prog load time, not
> at link creation time, or do I miss something here?
>
> AFAIU, if prog uses such kfuncs, verifier will grab needed module ref
> and if module isn't loaded the kfuncs won't be found and program load
> fails.

...

> Or we are talking about implicit dependencies, where program doesn't
> call function X but needs functionality handled earlier in the pipeline?
>
> The only two instances I know where this is the case for netfilter
> is defrag + conntrack.

Well, I was kinda mixing the two cases above, sorry about that. The
"kfuncs locking the module" was not present in my mind when starting to
talk about that bit...

As for the original question, that's answered by your point above: If
those two modules are the only ones that are likely to need this, then a
flag for each is fine by me - that was the key piece I was missing (I'm
not a netfilter expert, as you well know).

Thanks for clarifying, and apologies for the muddled thinking! :)

-Toke

