Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA52CD13D1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 09:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbjIRJcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 05:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240942AbjIRJbw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 05:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57710D
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 02:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695029465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bHU4YlwSFXi1XoLmAC4wpfJTSoau/940l2aWduvp2f0=;
        b=FzQGVbOWu2fOj8d+cgzMyVXrfLJ7k5HRCtKliFIlJJw+urwbIqTOxz4Xe+8x9X51FBo3wb
        NazXCtn4dlsg/iv16fEIcJGbQ9gZWWvvzEfUYJAlZjAtEljadw7xJDNAaZlvs0+4OQp18S
        wzrJ2LiA1HAOJZkezo/nczQDM9w9AAQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-1zDbXbNtNb62N_H4WeDC6A-1; Mon, 18 Sep 2023 05:30:15 -0400
X-MC-Unique: 1zDbXbNtNb62N_H4WeDC6A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-404f8ccee4bso5846355e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 02:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695029414; x=1695634214;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bHU4YlwSFXi1XoLmAC4wpfJTSoau/940l2aWduvp2f0=;
        b=c5jgfcA6uGpgbImL+xngK+/PyBpPPsx7ezsazEqyzJEuNNwgJGcqpvjuaCwxU3y/6P
         J5EwPWZrFQAWTLTSL1fmvM7nNoKuaefKXQPhwbstGZYNHI2Jr0NjmuEXx2Pj83EApquA
         N0gmylRZ2bfAWCNQiT2wf11vqn/39sSt8NGyp7y/sBLtA0gw+jGnDjFR5q4ukvFQZd6U
         Jv4pphpBLco2WW1NQcLdSavogncE7meCnhsTasHkmpNUJnPbdGotx2af2YQvCo25UKdi
         Da4QIT3SJz/F4YDGU5M5nzJ6dfa+h38osT8Uvy7Yn2BMljSNstA7/Dcwb8+I2XVsFFDa
         PjVg==
X-Gm-Message-State: AOJu0Yx827Msqd8OHVCPbx0C9fDn8EDBDnvSIIUdhVrWdKCOtMKCoIhb
        AsCsh0bHhnG13SkNCY0MrqQsNSeyNLuLTb8VAKyuJKigCD1a0WFCsS6IKDxskHPrt3BECK9tPTo
        9DctDtxIMoOxvKBydwczpKmpK+JlF1oUWLINsYgM6Rj4XiuAz4gdIxB7lqfsfsslEUfXY3OS/J9
        Q1uxqanOKD3ZY=
X-Received: by 2002:a05:600c:1da9:b0:404:72f9:d59a with SMTP id p41-20020a05600c1da900b0040472f9d59amr7630714wms.0.1695029414510;
        Mon, 18 Sep 2023 02:30:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjg/7n1E5p2ovt06h90JcUlOou/OiD0zcsotNTu9AjTK2kyQO+Vu3Xl9WG/qUWvrmuadga7Q==
X-Received: by 2002:a05:600c:1da9:b0:404:72f9:d59a with SMTP id p41-20020a05600c1da900b0040472f9d59amr7630702wms.0.1695029414137;
        Mon, 18 Sep 2023 02:30:14 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c320900b00404732ad815sm11096755wmp.42.2023.09.18.02.30.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 02:30:13 -0700 (PDT)
Message-ID: <3a95f0f8b9275828af700ae4bb284df7ff494854.camel@redhat.com>
Subject: Re: [PATCH nft 2/3] tests/shell: skip "sets/reset_command_0" on
 unsupported reset command
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Mon, 18 Sep 2023 11:30:12 +0200
In-Reply-To: <20230915155614.1325657-3-thaller@redhat.com>
References: <20230915155614.1325657-1-thaller@redhat.com>
         <20230915155614.1325657-3-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch (#2 of 3) should be dropped. Don't apply.

It will be solved differently by a patch from Florian.


Thomas


On Fri, 2023-09-15 at 17:54 +0200, Thomas Haller wrote:
> The NFT_MSG_GETSETELEM_RESET command was only added to kernel
> v6.4-rc3-764-g079cd633219d. Also, it doesn't work on Fedora 38
> (6.4.14-200.fc38.x86_64), although that would appear to have the
> feature. On CentOS-Stream-9 (5.14.0-354.el9.x86_64) the test passes.
>=20
> Note that this is not implemented via a re-usable feature detection.
> Instead, we just in the middle of the test notice that it appears not
> to
> work, and abort (skip).
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D079cd633219d7298d087cd115c17682264244c18
>=20
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> =C2=A0tests/shell/testcases/sets/reset_command_0 | 20 +++++++++++++++----=
-
> =C2=A01 file changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/tests/shell/testcases/sets/reset_command_0
> b/tests/shell/testcases/sets/reset_command_0
> index ad2e16a7d274..a0f5ca017b0f 100755
> --- a/tests/shell/testcases/sets/reset_command_0
> +++ b/tests/shell/testcases/sets/reset_command_0
> @@ -2,7 +2,7 @@
> =C2=A0
> =C2=A0set -e
> =C2=A0
> -trap '[[ $? -eq 0 ]] || echo FAIL' EXIT
> +trap 'rc=3D"$?"; [ "$rc" -ne 0 -a "$rc" -ne 77 ] && echo FAIL' EXIT
> =C2=A0
> =C2=A0RULESET=3D"table t {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set s {
> @@ -36,11 +36,21 @@ expires_minutes() {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sed -n 's/.*expires \([0-=
9]*\)m.*/\1/p'
> =C2=A0}
> =C2=A0
> -echo -n "get set elem matches reset set elem: "
> =C2=A0elem=3D'element t s { 1.0.0.1 . udp . 53 }'
> -[[ $($NFT "get $elem ; reset $elem" | \
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0grep 'elements =3D ' | drop_se=
conds | uniq | wc -l) =3D=3D 1 ]]
> -echo OK
> +
> +rc=3D0
> +OUT=3D"$( $NFT "get $elem ; reset $elem" )" || rc=3D$?
> +if [ "$rc" -ne 0 ] ; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "Command \`nft \"get $ele=
m ; reset $elem\"\` failed.
> Assume reset is not supported. SKIP"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exit 77
> +fi
> +
> +[ "$(printf '%s\n' "$OUT" | \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 grep 'elements =3D ' | \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 drop_seconds | \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uniq | \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wc -l)" =3D 1 ] || die "Unexpected output=
 getting elements:
> \`nft \"get $elem ; reset $elem\"\`"$'\nOutput\n>'"$OUT"'<'
> +echo "get set elem matches reset set elem: OK"
> =C2=A0
> =C2=A0echo -n "counters and expiry are reset: "
> =C2=A0NEW=3D$($NFT "get $elem")

