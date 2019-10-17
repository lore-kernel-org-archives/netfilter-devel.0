Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C89ECE58D
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 17:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF4E121925
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 17:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="c1SMG1BM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409456AbfJQRbM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 13:31:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35129 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409406AbfJQRbL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 13:31:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id m7so3454365lji.2
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 10:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=l3g+/rAGZ6wGitPbTlN233R7aSk/y6N7dmInMjxPEAY=;
        b=c1SMG1BMa2DVjM7behVSHfpj737HUxB7Lt55sHMjynoeURasP0zeoyHfJ7WvmNIgBd
         yqjb/W1Vt0MyK+vXc9RT4B8CtK73fs5UbcpPX6v5eJ4R+jTHr4r4F5NpuOzVLCKsu5uX
         xBrjqqifws74rSM4qluAgkAZduIQ7d8qxmpr6KA5a8g+cm/VSigcXlFmU5wWTKIGWfKM
         RMrgjAtXCIE4nE2Dx0FNzbxwTLc71wGVcnpeo4VgTucbl2KxmOEcaX7d+5HAvN3nUh62
         cuLAEvh8ytr9LLCanGntdVkNZ5+jclVmbOiY5mguGy9hkTfQ/l9zA95Qb447Mr/BwoVy
         9OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l3g+/rAGZ6wGitPbTlN233R7aSk/y6N7dmInMjxPEAY=;
        b=AseXrFYrSjEAUBLTwL+GLKLSpR1BtvSPor7aPFXVyp9vGals2qjSDlPK9x0IWTQ7HH
         XnwpHSqB3YBBqLt7dSp2lKFqK6eZVjAaoG0JCSKbB9zQFc1wod2e4i/INID737N5aEjo
         CDNIrdPJFMh5JMjBSROWcDu0nAhCgax4B9xQXIe+mYr8S3CgMJuBVxzliJvGYw+nI6h6
         3mttoXQvf17dse47TsXbHb+Mzf09+1LBZDThJqNN4/OeseHVStJYVIMRokaV7TYoBqrW
         8TZjjjPrj9+w9aAIg3sxHCUmQ1u6LDLB+IKqIlxtemEbRWYjZ8bST1eA3GojGV1ZXtHs
         H9Wg==
X-Gm-Message-State: APjAAAXavIR8KFDeecd0OB5KSAegECYQbMMFSSd/i9llCeHpOP+HQtrk
        i4qidNRFQ1UA8kWrgsNpFc/s/g==
X-Google-Smtp-Source: APXvYqxD9wmX1HonHg5iojOcGmgX2voYwaMvyoQGzoBqlsdeyIo1VaT33SRZiWui3hlvm8yMl7VBJw==
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr3288157ljj.91.1571333469558;
        Thu, 17 Oct 2019 10:31:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b10sm1299473lji.48.2019.10.17.10.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 10:31:09 -0700 (PDT)
Date:   Thu, 17 Oct 2019 10:30:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, saeedm@mellanox.com,
        vishal@chelsio.com, vladbu@mellanox.com, ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at
 byte level
Message-ID: <20191017103059.3b7ff828@cakuba.netronome.com>
In-Reply-To: <20191017161157.rr4lrolsjbnmk3ke@salvia>
References: <20191014221051.8084-1-pablo@netfilter.org>
        <20191014221051.8084-4-pablo@netfilter.org>
        <20191016163651.230b60e1@cakuba.netronome.com>
        <20191017161157.rr4lrolsjbnmk3ke@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 17 Oct 2019 18:11:57 +0200, Pablo Neira Ayuso wrote:
> Hello Jakub,
>=20
> On Wed, Oct 16, 2019 at 04:36:51PM -0700, Jakub Kicinski wrote:
> > Let's see if I can recount the facts:
> >  (1) this is a "improvement" to simplify driver work but driver
> >      developers (Ed and I) don't like it; =20
>=20
> Ed requested to support for partial mangling of header fields. This
> patchset already supports for this, eg. mangle one single byte of a
> TCP port.

Ed said:

As Jakub said, 'We suffered through enough haphazard "updates"'.=C2=A0 Plea=
se
=C2=A0can you fix the problems your previous API changes caused (I still ha=
ven't
=C2=A0had an answer about the flow block changes since sending you my drive=
r code
=C2=A0two weeks ago) before trying to ram new ones through.

> >  (2) it's supposed to simplify things yet it makes the code longer; =20
>=20
> The driver codebase is simplified at the cost of adding more frontend
> code which is common to everyone.
>=20
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |  162 +++---------
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h |   40 ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |   80 ++----
>  drivers/net/ethernet/netronome/nfp/flower/action.c   |  191 ++++++------=
--

Well selected. Also part of the savings here are patch 2 which no one
objects to :/

> >  (3) it causes loss of functionality (looks like a single u32 changing
> >      both sport and dport is rejected by the IR since it wouldn't
> >      match fields); =20
>=20
> Not correct.

As you discovered yourself in the follow up, it is correct.

> tc filter add dev eth0 protocol ip \
>         parent ffff: \
>         pref 11 \
>         flower ip_proto tcp \
>         dst_port 80 \
>         src_ip 1.1.2.3/24 \
>         action pedit ex munge tcp src 2004 \
>         action pedit ex munge tcp dst 80
>=20
> This results in two independent tc pedit actions:
>=20
> * One tc pedit action with one single key, with value 0xd4070000 /
>   0x0000ffff.
> * Another tc pedit action with one single key, with value 0x00005000
>   / 0xffff0000.
>=20
> This works perfectly with this patchset.
>
> >  (4) at v5 it still is buggy (see below). =20
>=20
> That, I can fix, thank you for reporting.

You keep breaking flow offloads are we are tired of it.

> > The motivation for this patch remains unclear. =20
>=20
> The motivation is to provide a representation for drivers that is
> easier to interpret. Have a look at the nfp driver and tell me if it
> not easier to follow. This is already saving complexity from the
> drivers.

Obviously IMO it's just churn, otherwise why would I object?

You keep repeating that it's making drivers better yet the only driver
authors who respond to you are against this change.

How are you not seeing the irony of that?


Ed requested this was a opt-in/helper the driver can call if they
choose to. Please do that. Please provide selftests.

Thank you.
