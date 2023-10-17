Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630B7CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 11:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjJQLWl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 07:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQLWk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 07:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D2B9F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 04:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697541718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IoRkGrt+TirqqarVuJfiY8DJfcwpFSKvGjOrZinjApg=;
        b=D/zEXrnUzyePkPYD4S0Om8aMyGLlA81WT4ZgFHGz0ioyMoLc9CkA6ty2AYI1TqTYEdPTLz
        ya1AQG9k5sTitQP7gLBqrVidQqc5XHqoGvV+Qu55RU5A9S/q4oTPoEnR34ym0JgcYPBqGC
        F0kCZ3OsgIHcbD1hE2tRyQK9Q/xEXOg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-GILK9BOePbKFg2dK3zqx6w-1; Tue, 17 Oct 2023 07:21:57 -0400
X-MC-Unique: GILK9BOePbKFg2dK3zqx6w-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-53d996a15e1so1050723a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 04:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697541716; x=1698146516;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IoRkGrt+TirqqarVuJfiY8DJfcwpFSKvGjOrZinjApg=;
        b=JvbgKxyIrbQu4jfVJyjOefGC0hp2KainSlKWjjmVPMAKMEi3t32tAVsXm3pX4Ntes6
         Q9JVYybVVfUXCoUiB4WQZK6/fs7X4bGIvrWjUFVTHBEhpMYKBb7e2Xvd4DAjYWzohYz0
         Crg8VqHWou5TCLRk/Tfw3jXztLFsOZkTqm7eLdriwcX+L8FXGrdCwoxfpIqC8pCtX87U
         pXG5kDQ3oWds1ALh3KHTPaFq2Oeg0tSFaZgvoq1YSpPld+5MIeR0MU7SAr0ixTRpXRF6
         ymfOGdcpIHX3sd8uhLAhVn/xjqcda7RDxgtz1rngirEJuCVp6L1LuIg7kGnl7xeQ/j4y
         aT2g==
X-Gm-Message-State: AOJu0YxxL/DIo05RFQSlD0FRF775iVrqOQ6ntaFviitvC5D0rWGVKLfE
        C3KPjM+dKx/L2kzMU4TAXk8AAnBmLSpmUHJ7sy3hc3PDctQFN3Afzo9jDbzJEKGBKa8qzwE/ydu
        E1sq2WlAfzPf6RxzbnWG3ySeynknrVEsJM/px
X-Received: by 2002:a17:906:74c8:b0:9bd:cab6:a34a with SMTP id z8-20020a17090674c800b009bdcab6a34amr1249772ejl.6.1697541715814;
        Tue, 17 Oct 2023 04:21:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHz0/kPA12qPymDzNgcHBZhNvWCDxSIdxJv80eo/mWACF20DzPQt4OPZq0h8cqU8fhludv9wA==
X-Received: by 2002:a17:906:74c8:b0:9bd:cab6:a34a with SMTP id z8-20020a17090674c800b009bdcab6a34amr1249761ejl.6.1697541715519;
        Tue, 17 Oct 2023 04:21:55 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id kq24-20020a170906abd800b0099cc3c7ace2sm1068707ejb.140.2023.10.17.04.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 04:21:55 -0700 (PDT)
Message-ID: <fa46d54e30cc0c603d555b7446d5a5485374b49a.camel@redhat.com>
Subject: Re: [PATCH nft v2 2/3] tests/shell: skip "table_onoff" test on
 older kernels
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 17 Oct 2023 13:21:54 +0200
In-Reply-To: <ZS5OKQycMX0cScgb@calendula>
References: <20231017085133.1203402-1-thaller@redhat.com>
         <20231017085133.1203402-3-thaller@redhat.com> <ZS5OKQycMX0cScgb@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-17 at 11:04 +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 17, 2023 at 10:49:07AM +0200, Thomas Haller wrote:
> > The "table_onoff" test can only pass with certain (recent) kernels.
> > Conditionally exit with status 77, if "eval-exit-code" determines
> > that
> > we don't have a suitable kernel version.
> >=20
> > In this case, we can find the fixes in:
> >=20
> > =C2=A0v6.6=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dc9bd26513b3a11b3adb3c2ed8a31a01a87173ff1
> > =C2=A0v6.5.6=C2=A0=C2=A0=C2=A0 :
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5e5754e9e77ce400d70ff3c30fea466c8dfe9a9f
> > =C2=A0v6.1.56=C2=A0=C2=A0 :
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dc4b0facd5c20ceae3d07018a3417f06302fa9cd1
> > =C2=A0v5.15.135 :
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D0dcc9b4097d860d9af52db5366a8755c13468d13
>=20
> I am not sure it worth this level of tracking.
>=20
> Soon these patches will be in upstream stable and this extra shell
> code will be simply deadcode in little time.

I am not concerned about dead code in old tests that keep passing.
The code was useful once, now the test passes. No need to revisit them,
unless you see a real problem with them.

If it would be only little time, the tests should wait. But how much is
the right time? You are not waiting for your use-case, you are holding
back to not to break the unknown use cases of others.

IMO merging tests is good. The problem just needs a good solution.


Thomas

