Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05176C71153
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Sep 2023 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbjICRC2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Sep 2023 13:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbjICRC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2023 13:02:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA11106
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2023 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693760496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/gwEtg0VNVNvPTdKS+e8c0YI6x43/XPX20aSljUK4I=;
        b=YXswkwDyDDPtaTEmvWwM3jmuMcva/Byo5KKFBcFbw+6GZ4N1zEHCdoYRfc5/h97XzVJuwD
        U/tBdGxnEZXiY8T/W/OzefdMkE8AfrS7fK018gcCa409svinakyN+P0Jg6JOAng+RT0zus
        sGGIPIytz9VgAguKMy/sZjMXYmPAWHY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-kIR5Pzg8PKOkImgEBEIdxQ-1; Sun, 03 Sep 2023 13:01:35 -0400
X-MC-Unique: kIR5Pzg8PKOkImgEBEIdxQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31c818b7931so215878f8f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Sep 2023 10:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693760494; x=1694365294;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T/gwEtg0VNVNvPTdKS+e8c0YI6x43/XPX20aSljUK4I=;
        b=S1e3HfCzXs1zJJ775pRO4r8/cOCXtYjwsdMzRUBup3lbpLpgryCzl9/e5Lv2YUTTHZ
         TMbIl0d9STOzJjkIWNB8X3YP8EabeHNQ0MJ7impBZw8gWQqDd2dZqwCkQwodNr+t0C+P
         p7DL/o3iemNx6NVTX/6Ur0K+X0vMdmLF+ZlSQbjk1UGs4LLD/ykVtiuWQwjLl+kUafmh
         7sotHKUWWR+xJfb2084+9eVFsXsWmyLpVD0no/xLnO3nfQU2Y0ggCfQBzt0ohkUxz6zv
         si7OE4U5E2OCB0Thhv0/hwe7JYDK24kk0xU1ULIaA02sWDHuhPK6bc1dz2vURlg/wyOW
         UQDA==
X-Gm-Message-State: AOJu0Yyv6WL6jcdM0UTLGQiNGSLYMpG0u6jWQ9cA2twJL2hF+aFzV4l8
        WeqgMCx52GGtLm3DeYP4iwpvaLnnfFIMLm5xw0JllgWuXFr03vQ0rX9ce2EEWngNkWqN5apWrxs
        5z0IZqx8w8KATBj1jluBBFP4N+1vFFYBiQwe9WF4KfdCRkQanuFoVr7+MX7JzkycSuljEuPA4Z+
        D0e8lvYrZrC0I=
X-Received: by 2002:a05:600c:1c9e:b0:401:b0f8:c26a with SMTP id k30-20020a05600c1c9e00b00401b0f8c26amr6188981wms.4.1693760493883;
        Sun, 03 Sep 2023 10:01:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaN6j9hSB+kZ/V3QCBj5S1hhWhfYe8zUbyFKBIzSxllEEz3U5cVXrWmk0h8X0DXMQAxpZKSQ==
X-Received: by 2002:a05:600c:1c9e:b0:401:b0f8:c26a with SMTP id k30-20020a05600c1c9e00b00401b0f8c26amr6188965wms.4.1693760493463;
        Sun, 03 Sep 2023 10:01:33 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c025000b003fee7b67f67sm11494857wmj.31.2023.09.03.10.01.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 10:01:32 -0700 (PDT)
Message-ID: <24a5a98be95369174e8dbfdddd1d6c9dcc0905f6.camel@redhat.com>
Subject: Re: [PATCH nft v2 0/3] tests/shell: allow running tests as non-root
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Sun, 03 Sep 2023 19:01:32 +0200
In-Reply-To: <20230901150916.183949-1-thaller@redhat.com>
References: <20230901150916.183949-1-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-09-01 at 17:05 +0200, Thomas Haller wrote:
> Changes to v2:
>=20
> - new patch: rework the parsing of command line options
> - new patch: add a "--list-tests" option to show the found tests
> - call "unshare" for each test individually.
> - drop NFT_TEST_ROOTLESS environment variable. You no longer have to
> =C2=A0 opt-in to run rootless. However, if any tests fail and we ran
> =C2=A0 rootless, then an info is printed at the end.
> - the environment variables NFT_TEST_HAVE_REALROOT and
> =C2=A0 NFT_TEST_NO_UNSHARE can still be set to configure the script.
> =C2=A0 Those are now also configurable via command line options.
> =C2=A0 Usually you would not have to set them.
>=20
> Thomas Haller (3):
> =C2=A0 tests/shell: rework command line parsing in "run-tests.sh"
> =C2=A0 tests/shell: rework finding tests and add "--list-tests" option
> =C2=A0 tests/shell: run each test in separate namespace and allow rootles=
s
>=20
> =C2=A0tests/shell/run-tests.sh | 191 +++++++++++++++++++++++++++---------=
-
> --
> =C2=A01 file changed, 132 insertions(+), 59 deletions(-)
>=20

v2 has still several problems. I got too impatient before sending the
patches.

v3 will fix those, and add several further improvements... hold on.


Thomas

