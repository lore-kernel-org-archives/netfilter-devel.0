Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD1FEB8FAF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 11:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbjIFLfO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 07:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238691AbjIFLfO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 07:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1218198E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 04:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694000019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6LaNdKqVXYI9Ay1vuqf2qXoO+ToWVF7Wp7SwqtZVN0Y=;
        b=WtB0J5E6IT/MrvlBYsi7UWLt1AdQcBHmkXlW7oHGMLb4vyiIXuJiWtZ4KeB5mblSJd++9o
        bdbPxCAETIrM5bqZB10Q6Jf8RlQONUf0ziE487LUz2jW5kXe2DyX5DGbugO5V/J3yLZXa8
        R8fTcrAhY1V4MNoh6qk0GN85t6+b/Bc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-8TfnhwOEMPWvTgBQpbGZ3w-1; Wed, 06 Sep 2023 07:33:38 -0400
X-MC-Unique: 8TfnhwOEMPWvTgBQpbGZ3w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31c8891017aso289476f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 04:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694000017; x=1694604817;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6LaNdKqVXYI9Ay1vuqf2qXoO+ToWVF7Wp7SwqtZVN0Y=;
        b=FSz9pzP1yFKW7/t4rq8Svv/xxQ6bn34Qf3RbN3/JshOFSyGtA816jbcwv4UqJsRXfx
         D5uoRdWpZPaW9HWk4hCptYfntUS+wROJYMEp9F1UyajpgNGhlDRJ+QPVsPnLINS4drlt
         SpnyaadkoXrSiZUewVlH5Ks525dihIcTegJz8rbEwZUyKYTMXp1FGI4yDF2sjS/91pw8
         w7LMAH/SLDXaTl1JdWuaqgXlDIGSa67T+D1oZWh+h8XheoMgSvUSRNiAawGV4/gEjRlj
         jN7clyHIQi7NxyJs5qMujk8t4bOUp8ocxVf6DQesNhcPVkWItxY/EYkcrPYZPhdbdL6p
         yamA==
X-Gm-Message-State: AOJu0YzlKhzPNaOTkflaiIvUInOByW/iSSzm2kOIk9CXSQldXtKJT96P
        K4G+5yCqLn5Dp//vF4+WlcAUl/x/XObH3QoXwl1F5wzE1ClVPIJxdtDt5Edspy7xjIA3F3nnuo3
        3dQG1M+yYRRcqfvg5Q+vU21K7/064vntMttDW
X-Received: by 2002:adf:e252:0:b0:317:3da0:7606 with SMTP id bl18-20020adfe252000000b003173da07606mr11253140wrb.4.1694000016846;
        Wed, 06 Sep 2023 04:33:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKSdx1tte0aRvAJhxmOYHQRfBp8ZMlrcAMzCzFFeJHZ3GrAIaY2THPt1q5fo72BnAACU4u0w==
X-Received: by 2002:adf:e252:0:b0:317:3da0:7606 with SMTP id bl18-20020adfe252000000b003173da07606mr11253128wrb.4.1694000016513;
        Wed, 06 Sep 2023 04:33:36 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id r5-20020adfe685000000b003143867d2ebsm20225099wrm.63.2023.09.06.04.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 04:33:35 -0700 (PDT)
Message-ID: <5a5c527c98e17d8f72103ac7c3b9b84e372f2aa7.camel@redhat.com>
Subject: Re: [PATCH RFC] tests: add feature probing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 13:33:34 +0200
In-Reply-To: <20230906100440.GD9603@breakpoint.cc>
References: <20230831135112.30306-1-fw@strlen.de>
         <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
         <20230904085301.GC11802@breakpoint.cc>
         <7731edd7662e606a06b1d4c60fb4cff9096fa758.camel@redhat.com>
         <20230906100440.GD9603@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-06 at 12:04 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > On Mon, 2023-09-04 at 10:53 +0200, Florian Westphal wrote:
> > > Thomas Haller <thaller@redhat.com> wrote:
> > > >=20
> > > >=20
> > > > But why this "nft -f" specific detection? Why not just
> > > > executable
> > > > scripts?
> > >=20
> > > Because I want it to be simple,
> >=20
> > It does not seem "simple[r]" to me. The approach requires extra
> > infrastructure in run-test.sh, while being less flexible.
>=20
> I can add bla.nft and use nft --check -f bla.nft.
>=20
> Or, I can add bla.sh, which does
>=20
> exec $NFT -f - <<EOF
> table ...
> EOF
>=20
> I see zero reason why we can't add scripts later on if there
> are cases where flat-files don't work.
>=20
> At this point, its just more boilerplate to add a script wrapper
> around the .nft file.
>=20
> > > I could do that, but I don't see the need for arbitrary scripts
> > > so
> > > far.
> >=20
> > When building without JSON support, various tests fail, but should
> > be
> > skipped.
> >=20
> > Could we detect JSON support via .nft files? Would we drop then a
> > JSON
> > .nft file and change the check call to `nft --check -j`?).
>=20
> No, but the test that should be skipped can do
>=20
> $NFT -j list ruleset || exit 77
>=20
> as first line of the script, no need to load any files, nft will fail
> with error in case its not built with json support.
>=20
> > Or maybe detection of JSON support needs to be a shell script
> > (doing
> > `ldd "$NFT_REAL" | greq libjansson`)? In that case, we would have
> > features-as-shell-scripts very soon.
>=20
> Sure, I see no reason why to not have both.=C2=A0 The flat files have the
> '*nft' suffix for a reason...
>=20
> I'll no longer work on this for the remainder of the month due to
> time constraints.
>=20


Sounds all good! Thanks.


I go ahead and implement an early version of the "NFT_HAVE_json"
feature. It can later be reconciled with your feature probing patch.


Thomas

