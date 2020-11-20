Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URI_HEX autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F4FC63697
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 03:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C84D2222F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 03:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qIqK2sHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgKTDBp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKTDBp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 22:01:45 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D2CC0613CF;
        Thu, 19 Nov 2020 19:01:43 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id j14so7490232ots.1;
        Thu, 19 Nov 2020 19:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JPhNPKtFRMqdIBM7nTGH/SqOjVL2v13M9KwRX/ticv4=;
        b=qIqK2sHBWDww/yNKBkfTe4FNeInkAsB/ayOybMgYkQ44CPoXGo6c4h7vhTZO0ttjp2
         zj9OtlN86iekUYB55AE/DGpzuX0Ta0C03LHycjKQE0tv0xNqaj9vhrRlAGTb8TOMAum3
         PyCndT2jwziPmCFGBvdZLzaqolZwhDOEcVj/qlZ4c++4EoykdBvrU+r1KrjVyFYIWtHd
         51HE6AYMxfv18UyR4xlcnqtbzOK7Qi64OKdp68r78W+WcQc5UgX5EOF3cpwM3ol3vSaL
         mzhP/zDvDajJ53g4RNr9K8WtZYxoqEPb3JOa2R6ZueWcfkhoSu9sJB3rHHSCoXlYi61J
         ov2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JPhNPKtFRMqdIBM7nTGH/SqOjVL2v13M9KwRX/ticv4=;
        b=pwb++gX9MPeqj+8Q5zs3Op9cemZCAKn8Y01tysnwU5ttCAtMXBa0PD2wXb1PYRoskf
         IAenXhsJ35n/MecXCRPlCjVgJnzdObXpF12n5Vz+g88Rtj7wyPi+0KVrYXamyQrfnw0O
         PcXEuBePhYOzjgNC/BExPwsdekxLO4bL40bI6/jDqjs1wD89dR3xBlkwRfj6ZRkJTUTk
         AR44vm6j4XMK5ETLCBUecH9fzF7mwrTZldvWmA7ZPlC74VN3q2ybLluI122PFD4NJ+7c
         hFMrS7FTBr5kj8Nej2P+IzOR0m1PlO0gwGfe5pQ2qVGHVYyky7wl1CDq9BEpVSq5S48O
         hahg==
X-Gm-Message-State: AOAM530aSNZTZlpJtHCpaZYGTTpSouhJjJvSfAubNh6KJtVoJP8sH26B
        1Ti6mDPne0DeVCoLoLoXGVB6fKIsN6/apz4zezK8HUDdWu4=
X-Google-Smtp-Source: ABdhPJxcWetfBbagxikGOx8xVIfWm9dmFp1Zxn+3qpl1h7hlcZz+lhytVGuaPeBrz0gn9Hzuo0mtxm5ry4qST/muEiE=
X-Received: by 2002:a05:6830:1bcb:: with SMTP id v11mr11790619ota.115.1605841302724;
 Thu, 19 Nov 2020 19:01:42 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu>
 <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr> <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu>
 <83oq5412-o0sq-5q31-s7o5-s0q28s12844@vanv.qr>
In-Reply-To: <83oq5412-o0sq-5q31-s7o5-s0q28s12844@vanv.qr>
From:   Neutron Soutmun <neo.neutron@gmail.com>
Date:   Fri, 20 Nov 2020 10:01:31 +0700
Message-ID: <CAMQP0skDvG-vOAGmcx2kn21KYS9UgMfxND7NTi_X75GOnx_izw@mail.gmail.com>
Subject: Re: [ANNOUNCE] ipset 7.8 released
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

For the ipset 7.9, I found the released download url is
http://ipset.netfilter.org/ipset-7.9.tar.bz2,
however, it's previous releases are in http://ftp.netfilter.org/pub/ipset/

The Debian has the tool to detect the new release with package watch [1] file.
Could you please consider uploading the new release to the
fpt.netfiler.org/pub/ipset also.

Best regards,
Neutron Soutmun

---
[1] https://salsa.debian.org/pkg-netfilter-team/pkg-ipset/-/blob/debian/master/debian/watch

On Fri, Nov 20, 2020 at 5:09 AM Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Thursday 2020-11-19 22:46, Jozsef Kadlecsik wrote:
>
> >Hi Jan,
> >
> >On Thu, 19 Nov 2020, Jan Engelhardt wrote:
> >
> >> LIBVERSION changed from 14:0:1 (ipset 7.6) to 14:1:2,
> >> producing libipset.so.13 (7.6) and now libipset.so.12
> >>
> >> That seems incorrect! It should have been
> >> - 14:0:1 (no changes)
> >> - 15:0:2 (compatible changes)
> >> - 15:0:0 (incompatible changes)
> >
> >Oh, my. It should be 15:0:2 (compatible changes). I dunno how many times I
> >can mix it up, this numbering scheme is simply alien to my brain wiring.
>
> If in doubt, always use :0:0 --- and make a mental note of exactly the
> :0:0 requirement in Make_global.am. :-)
>
> Distros can always rebuild transitively. They have to do that anyway for
> things like /usr/lib64/libbfd-2.35.0.20200915-1.so (with a date, it
> could change daily anyway). But recovering from a backjumping lib...
