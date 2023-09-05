Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E6DC83F3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbjIEQ1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354505AbjIEMEU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1CD1AB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 05:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnR1jod2crJgGJ8GOxB+u9HFmNrTDpdITfGZr+oXeDA=;
        b=AYcCL129JLWJRE75nM8gJehCJla29Rq5/3OeGJ/tgSGzvg38s1jrBR+k95VtJZbOkGDs4a
        JGiwRqLCjSE32iP6LP4JagpydjyaU7x0N6u7HB2KgwEy8qiOBzvE7FxbZX5D67myOjcaAo
        Q4XPDRIT8qBpRKqBB4dPqToUPRaRXec=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-KHOZdyBWOkqHZGorlrPPyQ-1; Tue, 05 Sep 2023 08:03:28 -0400
X-MC-Unique: KHOZdyBWOkqHZGorlrPPyQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-401b4a9bdb1so6599625e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Sep 2023 05:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693915407; x=1694520207;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OnR1jod2crJgGJ8GOxB+u9HFmNrTDpdITfGZr+oXeDA=;
        b=TTLD11q1miYA++bEzEM78leJrF6p30ulp/JtMAexL61nnpLDG/MvWpqI0yqlGzGVe1
         K6v0HD40GdAE824g0GxnN66GlnnFtIYqhjuZmMXTAYft7Rupnt4Zp2DufI42qcnUlMd8
         1n2eio7wXJ8yOXKkzFI3A7/9yuW9gSLoj4iviDL+/kCavrF4/nOs7X5s6HmxS9hHP++5
         fVqdBGXG8o1xswwUzhv/XORtZFueBYl8RO2cO/6DemPECaYhf/T/yxJK+xjoTCxUBDQr
         TWyOtayfdJelf6rTV7tIr+JMwFxdBzy+vXQDX3knePEZ2CfU1rBAaMr/baePd7+MO0fR
         t/IA==
X-Gm-Message-State: AOJu0Yz1Bt/XYdoMKso9aqHhLxVl69eggEa3sS4b+DhqN809QLDC6IST
        gKner5v+Q1Q6PATxwtuwo3rvXK+3gl5N9tcpS3CUFlnCBIJlaT2udbdaLDklw5XApe59uddfIhW
        8wY4o4SBvxNnkk94SBypMViN8oFH/
X-Received: by 2002:a5d:640e:0:b0:319:7624:4ca2 with SMTP id z14-20020a5d640e000000b0031976244ca2mr8577025wru.0.1693915407745;
        Tue, 05 Sep 2023 05:03:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHc9SjFWMdVtMbAxG+kM3H6cHBIEWzE7WEWsexlSMAlEFWNXCHayEuTciacaXXti43p7cxnsw==
X-Received: by 2002:a5d:640e:0:b0:319:7624:4ca2 with SMTP id z14-20020a5d640e000000b0031976244ca2mr8577019wru.0.1693915407434;
        Tue, 05 Sep 2023 05:03:27 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a5d4f89000000b0031c5b380291sm17356431wru.110.2023.09.05.05.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 05:03:26 -0700 (PDT)
Message-ID: <e333c1c8d7b95591acdb8603fa7768af9299bafc.camel@redhat.com>
Subject: Re: [PATCH nft v3 00/11] tests/shell: allow running tests as
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 05 Sep 2023 14:03:26 +0200
In-Reply-To: <20230905110915.GD3531@breakpoint.cc>
References: <20230904135135.1568180-1-thaller@redhat.com>
         <20230905110915.GD3531@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-09-05 at 13:09 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > Ch;anges to v3:
>=20
> I was about to apply this but 10 tests now fail for me because they
> no longer execute as real root and hit the socket buffer limits.
>=20
> Please fix this, the default needs to be 'all tests pass',
> i.e. use plain 'unshare -n' by default.
>=20
> I'll leave it up to you if you want to automatically go with
> unpriv netns if the script is invoked as non-root user or via
> env/cmdline switch.
>=20
> At least one failure isn't your fault, the blame is
> with a shortcut check in sets/0043concatenated_ranges_0, so the test
> never execeuted fully in the past. I will try
> to figure out when this got broken :/
>=20

hi,

yes, I noticed. Sorry about that.

Please see v4. That works well for me.


A major benefit IMO (which doesn't become clear from the commit
messages) is the result data in "/tmp/nft-test.latest". Have a look
there. And try the new "-j" option. And of course, try without root.

Thanks
Thomas

