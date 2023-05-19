Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A24C77B75
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 May 2023 15:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjESPVs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 May 2023 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjESPVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2023 11:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB7FE4D
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2023 08:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61A9E6589F
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2023 15:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2CC433D2;
        Fri, 19 May 2023 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684509704;
        bh=HK6Figxz+yH0WmvG/bIoTK/667VIbE2blzH/3yPdbjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAbNJaCy1+O25ePmrvqXyS0mYgnHB+XKKzyXYifQCfH2KgxcuKEXcwKwUyFcfXliu
         rfvAVNlpOJ1ix9z+u05+hIWIQvrC34LPiJxdzLM6gplYNjLciUkR++1pB+yT8Ralrk
         sd8kalRKJmjkNZNOK5WGlLwKXGEtXDHvnhOkEhLFt+2p2MHTaZB8FLzJhsOlaZ3HsR
         gcB5wFxKOr84kZGoLxfgs8RUtUR2zCx9H9i7kqB/v73rp/oT+kcjHuKOCM1aCDQ6Up
         IjYxsFADsG7+PhooMS4jadi20VOzobMBfzRBM8OIdiJmnBHiz2p9FN1xnCgs0/nKSI
         CDI4cHPDsVlcQ==
Date:   Fri, 19 May 2023 08:21:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH net-next 3/9] netfilter: nft_exthdr: add boolean DCCP
 option matching
Message-ID: <20230519082143.3d20db49@kernel.org>
In-Reply-To: <20230519105348.GA24477@breakpoint.cc>
References: <20230518100759.84858-1-fw@strlen.de>
        <20230518100759.84858-4-fw@strlen.de>
        <20230518140450.07248e4c@kernel.org>
        <20230519105348.GA24477@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 19 May 2023 12:53:48 +0200 Florian Westphal wrote:
> > Someone is actually using DCCP ? :o =20
>=20
> Don't know but its still seeing *some* activity.
> When I asked the same question I was pointed at
>=20
> https://multipath-dccp.org/
>=20
> respectively the out-of-tree implementation at
> https://github.com/telekom/mp-dccp/
>=20
> There is also some ietf activity for dccp, e.g.
> BBR-like CC:
> https://www.ietf.org/archive/id/draft-romo-iccrg-ccid5-00.html

Oh, Deutsche Telekom, ISDN and now DCCP?
I wonder if we could make one of them a maintainer, because DCCP
is an Orphan.. but then the GH tree has such gold as:
net/dccp/non_gpl_scheduler/=20
=F0=9F=98=91=EF=B8=8F
