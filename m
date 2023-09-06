Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B494EB8FDF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 14:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjIFOgz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 10:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239260AbjIFOgz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 10:36:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738BC8F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 07:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694010967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XJSfNG17pxwO1g/LCNgtThaqD/7Znf8/mOEa+ZqX+Xc=;
        b=TSE14axlPD9+sl7DJid40EGPpFFJuihm7ZchloulmmO41bTbhy96K5hqhYY63Cfb2jrZM+
        oR93GW0B/g+ZDxlDaLYRT95gVhSsBHrGkzJ2kmtR4dkkTR8xisthFAKDC9F1B8FG1BiLFf
        ric/kt7Y5rKrNkR2ihLjPT09QSUd4Nw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-Nk6d-5osMaCeqpMs3bbRHQ-1; Wed, 06 Sep 2023 10:36:06 -0400
X-MC-Unique: Nk6d-5osMaCeqpMs3bbRHQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31c8891017aso304949f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 07:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694010964; x=1694615764;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XJSfNG17pxwO1g/LCNgtThaqD/7Znf8/mOEa+ZqX+Xc=;
        b=Jcq3bYk3O67vMIwzkIrcqkYgygjwhlQ4EbpteanwQdqdBfOMdG1sZ1J3NWj/ECnU3V
         D9tgrSoZHkeWSUXhACee2ZORNaq7OYw6v3vTaPQuvFBKto8fXA7vS46XKYjE7auGBRJm
         7/FPPPXbYjsMOuPacA3cufVaCP68bEl8fTvGU6z1OVkOFUakL7TrvPVAhv6QhzfIZsl4
         V8pcGEUBgJ8UGb9utK9PJmmYgjohSOE+7Zs5hxw/KM/KumNiYPVPfCBpBRtrMt+J2AQt
         xqKhQsCoUh355+s5TxCyyCgguZzjd+Nnc2armkDMa4hXBxmgloDHDkHM75L/I4ZSjoNA
         VKbA==
X-Gm-Message-State: AOJu0Yxtb3S2ARe5aNy0DpUvXeusCJ/4xZLE51gsNas48TV1jvylZhff
        E9CFgzvdOdxj+Sv04fZsMl86hDOZvDzErI0i9hp23uXiydqtUf2w+JggBbSGn2e44LBpiG5Ry2Y
        GV6LCvXEV4okD45HqXThsI0/OMSOTuaabviyD
X-Received: by 2002:adf:e5c7:0:b0:31d:3669:1c48 with SMTP id a7-20020adfe5c7000000b0031d36691c48mr11042748wrn.7.1694010964779;
        Wed, 06 Sep 2023 07:36:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKdZs1eTgSki5r+Jq86sf4NaHakLWlf9o9h3t97C5KjuPlFy9mbE2bCSVtFOhHSofs6trKLQ==
X-Received: by 2002:adf:e5c7:0:b0:31d:3669:1c48 with SMTP id a7-20020adfe5c7000000b0031d36691c48mr11042740wrn.7.1694010964465;
        Wed, 06 Sep 2023 07:36:04 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id l10-20020a5d4bca000000b003180155493esm20577683wrt.67.2023.09.06.07.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 07:36:03 -0700 (PDT)
Message-ID: <04c202a04375dd46b4899d02b4683f055edcba29.camel@redhat.com>
Subject: Re: [PATCH nft 1/5] tests: add feature probing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 16:36:02 +0200
In-Reply-To: <20230904090640.3015-2-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
         <20230904090640.3015-2-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-09-04 at 11:06 +0200, Florian Westphal wrote:
> Running selftests on older kernels makes some of them fail very early
> because some tests use features that are not available on older
> kernels, e.g. -stable releases.
>=20
> Known examples:
> - inner header matching
> - anonymous chains
> - elem delete from packet path
>=20
> Also, some test cases might fail because a feature isn't
> compiled in, such as netdev chains for example.
>=20
> This adds a feature-probing to the shell tests.

On my Fedora 38, I have currently 7 tests failing.
With this patchset, tests/shell/testcases/maps/typeof_maps_add_delete
is now skipped (6 failing left).

Nice!


> +check_features()
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for ffilename in $TESTDIR/../f=
eatures/*.nft; do
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0feature=3D$(basename $ffilename)
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0feature=3D${feature#*/}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0feature=3D${feature%*.nft}
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0eval NFT_HAVE_${feature}=3D0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0$NFT --check -f "$ffilename" 2>/dev/null
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if [ $? -eq 0 ]; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0eval NFT_=
HAVE_${feature}=3D1

the existing variables like VERBOSE,VALGRIND use "y" for true and
everything else is false.

I think 0|1 looks better. But it should be consistent. If 0|1 is used,
the other variables should be adjusted.

Note that on the other branch I added normalization functions
bool_y()/bool_n() to accept values like true/1/y/yes from the user, and
normalize to y|n. This could be changed internally to 1|0 without
breaking user setups.


> =C2=A0for testfile in $(find_tests)
> @@ -277,5 +296,10 @@ check_kmemleak_force
> =C2=A0
> =C2=A0msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))=
"
> =C2=A0
> +if [ "$VERBOSE" =3D=3D "y" ] ; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "Probed Features:"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0env | grep NFT_HAVE_
> +fi


  xxx=3D$'\nNFT_HAVE_XXXXX=3Dbogus' ./tests/shell/run-tests.sh /bin/true -v

gives the wrong output. Could be instead:

  for v in $(compgen -v | grep '^NFT_HAVE_') ; do
      echo "$v=3D${!v}";
  done


