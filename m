Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56561CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 12:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbjJQMor (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjJQMoo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 08:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5B7F9
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697546640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QyS+yu8T00vsIMjQvEbXroFPd0LKJvcpBR3/JkRGSBo=;
        b=Y3+tlNrNbEC5rQsbqCD3H/585xA5hoF7PkuEx1AbVLbpQ7JM5wXFakYwGbmWnJgBIdDWVf
        KRuGOG4clLufHSs9oQO/yTyXZL66tIpuBDPNft68sONT5HRmVVZXtGQAP+FCppG73z33+k
        J028PdxEQl+/xeIn022SkdlTReUi3SA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-rgBcOZrmM42u3FCO2WwmTw-1; Tue, 17 Oct 2023 08:43:58 -0400
X-MC-Unique: rgBcOZrmM42u3FCO2WwmTw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9c167384046so44389366b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 05:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697546637; x=1698151437;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QyS+yu8T00vsIMjQvEbXroFPd0LKJvcpBR3/JkRGSBo=;
        b=NZy/NPfUGOmDtnXzsNvZwBHUOe76autBV3wTkAT4J8UWlGMpNIAnpYLPAHrzIQILdF
         kR2Lpv5YjpVlgeRKe+ga1XVnYfMbgISYF2DklrDZ3TSLfUVSQcvx9n5kKtvUChPu8YY0
         qXEnf4vhCEjQynZVaNVodSaK/zu/56JhhD3HsLzoalM+ZK8zzTg7PSwiIrodgl5HpvXm
         87zaA++Xkyh1nABvAVNp3LAHrBiwCUxg2I5CsbwIQ+P9SglOA1keVdk67TyyhZ45YvV1
         gMubunIOUTSYSNVMdTyruDvHlkNMBTkWRQYkiW4STUrJtQDfuRPbJ1vJlffyzsaahf7u
         kTJQ==
X-Gm-Message-State: AOJu0YyZsbGY/l88XqmCyjG2FLmfdXu6tgzyuM6j9rEoLeXDG1knK8JX
        D0J/uUP3vf1ivnlTPFLn5e5GoAV0+N0SaqWVqGzMp6o+MJtCC6uDFmFehRu/j13GiVVlG+NMTiD
        XjqPRkJh811Lsk32gObvYUZfAPRGd
X-Received: by 2002:a50:f60d:0:b0:521:66b4:13b4 with SMTP id c13-20020a50f60d000000b0052166b413b4mr1570534edn.0.1697546637653;
        Tue, 17 Oct 2023 05:43:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgXR6N3x4SOYrWxKnOrebgwzqYuzenBaLNccop+Jzxdq4ldhshnvqDUTzR+KrI9mtjkPdGDg==
X-Received: by 2002:a50:f60d:0:b0:521:66b4:13b4 with SMTP id c13-20020a50f60d000000b0052166b413b4mr1570513edn.0.1697546637314;
        Tue, 17 Oct 2023 05:43:57 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id p20-20020a50cd94000000b0053443c8fd90sm1184811edi.24.2023.10.17.05.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 05:43:56 -0700 (PDT)
Message-ID: <5a785173b19c30e64ffa96e491f16757e7a4b21e.camel@redhat.com>
Subject: Re: [PATCH nft v2 2/3] tests/shell: skip "table_onoff" test on
 older kernels
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 17 Oct 2023 14:43:56 +0200
In-Reply-To: <ZS5yrFEVapwXier3@calendula>
References: <20231017085133.1203402-1-thaller@redhat.com>
         <20231017085133.1203402-3-thaller@redhat.com> <ZS5OKQycMX0cScgb@calendula>
         <fa46d54e30cc0c603d555b7446d5a5485374b49a.camel@redhat.com>
         <ZS5yrFEVapwXier3@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-17 at 13:40 +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 17, 2023 at 01:21:54PM +0200, Thomas Haller wrote:
> > On Tue, 2023-10-17 at 11:04 +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 17, 2023 at 10:49:07AM +0200, Thomas Haller wrote:
> > > > The "table_onoff" test can only pass with certain (recent)
> > > > kernels.
> > > > Conditionally exit with status 77, if "eval-exit-code"
> > > > determines
> > > > that
> > > > we don't have a suitable kernel version.
> > > >=20
> > > > In this case, we can find the fixes in:
> > > >=20
> > > > =C2=A0v6.6=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Dc9bd26513b3a11b3adb3c2ed8a31a01a87173ff1
> > > > =C2=A0v6.5.6=C2=A0=C2=A0=C2=A0 :
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D5e5754e9e77ce400d70ff3c30fea466c8dfe9a9f
> > > > =C2=A0v6.1.56=C2=A0=C2=A0 :
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Dc4b0facd5c20ceae3d07018a3417f06302fa9cd1
> > > > =C2=A0v5.15.135 :
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D0dcc9b4097d860d9af52db5366a8755c13468d13
> > >=20
> > > I am not sure it worth this level of tracking.
> > >=20
> > > Soon these patches will be in upstream stable and this extra
> > > shell
> > > code will be simply deadcode in little time.
> >=20
> > I am not concerned about dead code in old tests that keep passing.
> > The code was useful once, now the test passes. No need to revisit
> > them,
> > unless you see a real problem with them.
> >=20
> > If it would be only little time, the tests should wait. But how
> > much is
> > the right time? You are not waiting for your use-case, you are
> > holding
> > back to not to break the unknown use cases of others.
> >=20
> > IMO merging tests is good. The problem just needs a good solution.
>=20
> Apologies, I don't think this kind of hints is worth.


Which hint do you mean?

Do you mean the commit message, or the

    echo "Command to re-awaken a dormant table did not fail. Lacking https:=
//git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3Dc=
9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 ?"

The echo is really just an elaborate code-comment. But it also ends up
in "testout.log", which makes it better.


I don't mind rewording commit message or the echo statement (or even
dropping it entirely). But I find this information more useful than
not.


Thomas

