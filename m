Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55C6C7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 16:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB022206E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 16:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="f3bMHMCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbfG2Qzh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 12:55:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43963 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfG2Qzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 12:55:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id r22so953497pgk.10
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 09:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VCrgU88KkMCvWVoIPrZGlh3p115cO9rxPu95giiojSo=;
        b=f3bMHMCebuKfdXiogzFAjHwa2nvD4c8UFEoKLrQZupRU29fHVVc/OPS8zj9yQkoX+r
         lXLNqfqRHY8xphwre9/+yVbf/u0zuQFkygnXx81vNqyRwz/KRNgnWVNhLxPPIEroCCt3
         e8zYj1gKTBfLqgWk0RqvTymVV4duxgPVpJRVwwCwbcGMv9KryhgqFkBeesgWGhTy0Itz
         ZRX1sO/sAYdqa788HLD33wmgsbfEP+zuZ9JDN7xFHRJsgkcMVKczWiGi4Y7SNuJYR/oE
         MK8uZ4kgZoAmtnrNi0LWNulMaQsHNkzwlGePQxwrxf/JtawHbqZO+WcGu1pBlhmoBad/
         z0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VCrgU88KkMCvWVoIPrZGlh3p115cO9rxPu95giiojSo=;
        b=k2FWcSqoGGchIBKysHwgqVmJJAh/Js8QAsrDl3+RtOH72yKBCMSyyzaVU2eYESVene
         0Kxi7HS+5+nf04MzdHgTfHvepuZ9FXWvpoL+fYNtYYF8FKlHqu4GmzrCIe3qlqO6Wlae
         1jnyuBGvwLxn2eNnbYHSrPtR7WcnyyefqHP0aWwqH8uNZMyPM7btgdp7PeHjKglQ92Z3
         MojyVltj/eqlXquMBRuioWphjD586Rsc+vwcVON2/zjxjiI5Z7HTQGqotXVk+RufRaRo
         36Nv3Dj1JZBL5PbPYpOLRmznw+O9koayn7lKLUoWeIdZMMaf/GprCB80yPCwW0kesFvs
         /0ew==
X-Gm-Message-State: APjAAAU1FEO24bCvkmN0ATqHOuek1x/XfuRt7wPXyMwHNIhUe08TnsI1
        2J+f2+fPpRdsra2b6qYN0sVrTQ==
X-Google-Smtp-Source: APXvYqy4wVBZFW0RYGWkFo9QNdQThI6p5AIOevfYSFs+kP8gszKvYgxytXbtWwzMT64za+MUQsR61w==
X-Received: by 2002:a63:5c7:: with SMTP id 190mr103117049pgf.67.1564419336162;
        Mon, 29 Jul 2019 09:55:36 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y11sm64902766pfb.119.2019.07.29.09.55.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:55:35 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:55:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190729095526.17214c4d@cakuba.netronome.com>
In-Reply-To: <449a5603-80e9-ad7d-5c02-bf57558f9603@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
        <20190728131653.6af72a87@cakuba.netronome.com>
        <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
        <20190728214237.2c0687db@cakuba.netronome.com>
        <449a5603-80e9-ad7d-5c02-bf57558f9603@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 29 Jul 2019 15:18:03 +0800, wenxu wrote:
> On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
> > On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote: =20
> >> On 7/29/2019 4:16 AM, Jakub Kicinski wrote: =20
> >>> I don't know the nft code, but it seems unlikely it wouldn't have the
> >>> same problem/need..   =20
> >> nft don't have the same problem.=C2=A0 The offload rule can only attac=
hed
> >> to offload base chain.
> >>
> >> Th=C2=A0 offload base chain is created after the device driver loaded =
(the
> >> device exist). =20
> > For indirect blocks the block is on the tunnel device and the offload
> > target is another device. E.g. you offload rules from a VXLAN device
> > onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
> > device is created.
> >
> > So I feel like either the chain somehow directly references the offload
> > target (in which case the indirect infrastructure with hash lookup etc
> > is not needed for nft), or indirect infra is needed, and we need to take
> > care of replays. =20
>=20
> I think the nft is different with tc.=C2=A0
>=20
> In tc case we can create vxlan device add a ingress qdisc with a block su=
ccess
>=20
> Then the ASIC driver loaded,=C2=A0 then register the vxlan indr-dev and g=
et the block
> adn replay it to hardware
>=20
> But in the nft case,=C2=A0 The base chain flags with offload. Create an o=
ffload netdev
> base chain on vxlan device will fail if there is no indr-device to offloa=
d.

Can you show us the offload chain spec? Does it specify offload to the
vxlan device or the ASIC device?

Indir-devs can come and go, how do you handle a situation where offload
chain was installed with indir listener present, but then the ASIC
driver got removed?
