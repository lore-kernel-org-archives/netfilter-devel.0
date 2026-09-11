Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1E4657E5
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 12:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789128642; cv=pass; b=VANCW3bNgEyphHf1iDMsQiEMec+qcKX69Pqo77Ol4K/hiwnsRrBR4CUGA6yY0VW4upwglJ4MEyyrzHTCjGEFLvUrDTPzoy0nCwhD1+WYOuIgCJsqyeI9AKpah7BGKXMsEyr0Gws02zkCKhpUgpIvZrd4RnTZi4x9pjEWqGuwURY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789128642; c=relaxed/simple;
	bh=W3eM561Xa6+Lgd8YVLA7luWmizb/f/oA8Br4qDHb8p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KLnkdh3h59krnEGK0LWUPgStNfsFXci9RVC7Ib8Rzq4M+BiNWHppQQDrQNuUDadrWh5MR/nCdjvqpCCdjlcaUmvlEjYGEriyOCmysiwlPcAgaIcWV+v0+X3G/adCuFE4H1u2K9MWO1q8SoH6kQdWUp2Bpw6iB5Y5beaCVHMeCv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=uE7Ih1Rz; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="uE7Ih1Rz"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4ddd17a0so5652007b3.0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 05:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789128639; cv=none;
        d=google.com; s=arc-20260327;
        b=lLnsPvXvibIsmY/d6TeVwhnFFLh8vrqhmNhMg4hzdWjotzoMFdhldOQOi4XqtHZ/X/
         wGtUV2g5e0VKloaMegDtM4uzIRHBhiG4Hgp6D9ADp9YMv2QbvT3E9cfRWcRVJriWieoP
         9+1cvdbmZDflSdh9T0ZWEZTWGkajoK4GztVTPuTk7/Y1OhZz9GGLNrCy69J4X31bfKnG
         pIV0OBqeSJ6v1OHW7UhtDJboI6KVQMtDTXm9Uj6czwqGHZnm/+Pemc5G8x0c525NOXey
         zEkyZVCDWMgqzsV6YlDIF1R3J+K+962h3IWPB3h/b6ImKKeeNi/vwYpvaTYUlF6wE+jN
         Nl/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2yiSONf4nomVr6QfyaMestn/+O3ewewFxytikh5fBKo=;
        fh=dKoCupQ/1Vv/SybaLlgMAwTNxYgaJyN3lgSWXfWw7kQ=;
        b=hZ6gxo6DKKT7zUrKW+td2Fs0l84+ta93xk98tU+hzx9F+m1pWL9iphRKfd7Zb4Mbz2
         YJSngAmXBDnCEQUiLpPgjayzaP5WDjgxQTg8Ehge0buJvrzccyDns8j4H8W4cYS3vKt/
         5EfqDvx9Y4NcXfEQgTiWQOgVP0WdBnezH7rgYkyf6BbJMlCqeyPYPZKfyFbdL9jyuyL+
         Xnb9Si359dlMNgCHUsLRBogVZ2oNjtVDniIRRJo7MMCL0izQYvhmYOHXS26m/lWAIxZK
         27JgdARZt21ZvvphP+Ed9oAutkHIC/Mfe7xehBd4P0cXbL1OlWRIsP111bZ9LMnagFyR
         /ncw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789128639; x=1789733439; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2yiSONf4nomVr6QfyaMestn/+O3ewewFxytikh5fBKo=;
        b=uE7Ih1RzDZ3fCboQA2QzzenV2PDV72lb5SAU722vFb6TBoizIbJnEm44ZNUUBGz68f
         sMIDfh3DtDH7WgVsDTBZ4rRKtcTNvR2H4DznN2oLH9eLVHtA8Syv/S26syksBIYS1j4m
         DkGaUCg6C1dYn0I4pbY6ermV9SqxrjjTGpbyynZauEJW6w6XMtHSVC4ln/j6yfMSNqhw
         PVHcjvPFvrnHzu99zXny7THZGWgiM3uzTYDyq+9eyBWtVIo3CjCTvA2Nu+3+6RawkAuZ
         9dbZDn3wTif1qVIhZFOJq07fGdIYK/2GxbQGPOKCoicjdGMUHhRddhFBfKdmqjweGbq9
         +wUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789128639; x=1789733439;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2yiSONf4nomVr6QfyaMestn/+O3ewewFxytikh5fBKo=;
        b=jP8boUzsBVh6xyUcmS/Nxq4H5cjX4cACHBZaQ8U20r5BXR9KBcDdc2jYS2DdDYV6wJ
         20tUs6fEY/rKVo9ce0I4w0RDdf4DfNDTVDQ7TsBUlKBdlW3ehSlvi5gYlmRDpFmpNFQe
         w3J4DSPqhmrJQvszifJRppjDRCkMYAKgxvhk7wD2gwLx14NW5r7aktjIAGLkbxyCEHCS
         O86X7OVlA0a0cYAM89zt6n01LoVZoUYQLXhIWgpB4L0z3XKXkj2mZrdHOfgx37VEe3/r
         g2URskrCMHNzgR8FhM0cmCBC1b1EZvuyYwTboabTcyQhPG7Q2UEmNiDIzodNmrplDkw1
         zlPw==
X-Gm-Message-State: AFuF++m+6zVLm1pxbwCH6YZYSnWLCjuWzpr+vQz7qBmntjb2G+L5sO/U
	nors2M6Mghw/gcbuK0SXA46dOjO52lZzpVXYpYE95qLgjY8SvEEdME8XWnD0y2BLdWrUnlcPixW
	Qwwz8WnxtHmGzkH/P7I1vvMU9EIIdoyOxiaBOvWvuMdnmmCIYwvAx06xK
X-Gm-Gg: AYBFou3Qwu1lszbXJoELr3aeV9OAvWauPl7gERh4/SKtN8ba0P0LeqKLTMjDbAIWyvr
	iUKV7dfHsFYrvAfFHF9JEMQ98niG63SX4DWGDzSVVC5ZjFaF+mi/IL2qPt3UEFugYEhkthr4XP0
	nL56udM9TtxrZqU5Jy6WdPzR+AegVXEnwxW9o8q4OPAtY54xIioiVaONcn9CDZ79ekL1H6oS5I8
	Yg6QyB4BEtx8udPvpF5F3eOS8V/GUtiMO2Un8HU+sJlJj4ZvUi43W7GZCgKo6uko2dChU3by75w
	IphC/sD/FkABTyLXqo0UPZBv2Gl1kn/l20SCbStBwljxEQewaROM3AsTR5fxWE4hacwVAsg8IK8
	cHAtVnccJYOQJ8osS+zJWngP+bY5r6lbnKlXX0gqpd0RGOOloBQI6Cbv7xoRyDZg2zNGtZpfAVi
	hhoSwtqXQUFo+Mc/mp3H1zTLpM/sCsc4ki8J18BbpWdcU5b2aF27/g7raTvm94BkDnmmEa22yG6
	8wbCmaC7rq5uy2MmSiPq8T995Q3mOLDdlXhc8LKTsFyKqOPF0o4sIbrU9pla2YAwtjSynQQqoc6
	mxhP9+YRfiME
X-Received: by 2002:a05:690c:e0c4:20b0:836:ec3d:b5e6 with SMTP id
 00721157ae682-884b3b68092mr12455207b3.28.1789128639600; Fri, 11 Sep 2026
 05:10:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910090052.2034970-1-julius@bairaktaris.de> <aqPpBJvfTwKrxSGG@chamomile>
In-Reply-To: <aqPpBJvfTwKrxSGG@chamomile>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Fri, 11 Sep 2026 12:10:04 +0000
X-Gm-Features: AcwNN1WRxBFcaBBoN1hWkoSgCiY-vapNxoDiBMGxk2sFq0eOn9xkqWZYHCjex_4
Message-ID: <CAC1t37KDNB6+v7Xq51AGrPtYZ4U95kUEQ6HDJSKt5YYE6+0zdA@mail.gmail.com>
Subject: Re: [PATCH nf-next 0/4] netfilter: offload a TCP flow whose reply is
 never seen
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de, 
	coreteam@netfilter.org, netdev@vger.kernel.org, geldot@protonmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

thanks for taking your time to review.

> conntrack needs to see packets in both directions, are you assuming a
> packet-based load balancer in front of it?

No, an asymmetric route is in front of it, with two subnets sharing one
L2 segment and the server answering over that link, so the router only
ever sees one direction.

Conntrack already picks such a connection up when it misses the
handshake entirely, and patch 1 routes the SYN-seen case into that same
path, under the same nf_conntrack_tcp_loose gate.

  net/netfilter/nf_conntrack_proto_tcp.c, tcp_new():

    } else if (tn->tcp_loose == 0) {
        /* Don't try to pick up connections. */
        return false;
    } else {
        ...
        ct->proto.tcp.seen[0].flags =
        ct->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
                                      IP_CT_TCP_FLAG_BE_LIBERAL;

Julius



Am Fr., 11. Sept. 2026 um 11:42 Uhr schrieb Pablo Neira Ayuso
<pablo@netfilter.org>:

>
> On Thu, Sep 10, 2026 at 11:00:48AM +0200, Julius Bairaktaris wrote:
> > A host that forwards one direction of a TCP connection only sees the
> > client's SYN and then an ACK continuing from it; the answer took another
> > path. That ACK has no entry in the transition table, so it and every
> > packet after it are invalid, the conntrack entry stays in SYN_SENT
> > [UNREPLIED] with a single packet, and the connection reaches neither the
> > stateful part of a ruleset nor a flowtable.
>
> conntrack needs to see packets in both directions, are you assuming a
> packet-based load balancer in front of it?
>
> > Patch 1 takes such a connection over as the mid-stream pickup it is.
> > Patch 2 withholds the reply direction of a flow offloaded in one
> > direction until conntrack has seen a reply, and offloads it once
> > conntrack has. Patch 3 offers a connection whose reply was never seen to
> > the flowtable in the original direction. Patch 4 adds a selftest arm for
> > the path; without patches 1 to 3 it fails, with the router forwarding the
> > SYN of the connection and nothing else.
> >
> > Verified on an IPQ8074 router with hardware flow offload, iperf3 -P2
> > between two hosts on different subnets of one bridge with the reply
> > direction bypassing the router:
> >
> >                                   CPU port    switch port   throughput
> >   asymmetric, without the series   81k pps       81k pps    944-947 Mbit/s
> >   asymmetric, with the series      2-11 pps      81k pps    948-949 Mbit/s
> >   symmetric, with the series      11-38 pps      81k pps    926-948 Mbit/s
> >
> > I wrote this series with the help of an AI coding assistant, as the
> > Assisted-by tags record. I have reviewed and tested it myself.
> >
> > Gary Dotzler (2):
> >   netfilter: conntrack: pick up a TCP flow whose SYN was never answered
> >   netfilter: nft_flow_offload: offload a TCP flow that has no reply
> >
> > Julius Bairaktaris (2):
> >   netfilter: flowtable: promote a flow offloaded in one direction only
> >   selftests: netfilter: cover a TCP flow whose reply is never seen
> >
> >  include/net/netfilter/nf_conntrack_l4proto.h  |  7 ++
> >  net/netfilter/nf_conntrack_proto_tcp.c        | 19 +++++
> >  net/netfilter/nf_flow_table_ip.c              | 26 +++++++
> >  net/netfilter/nft_flow_offload.c              |  6 +-
> >  .../selftests/net/netfilter/nft_flowtable.sh  | 73 +++++++++++++++++++
> >  5 files changed, 129 insertions(+), 2 deletions(-)
> >
> > --
> > 2.53.0
> >
> >
