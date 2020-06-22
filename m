Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1251FC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CD82073E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hiu6SEas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgFVQXZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:23:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729451AbgFVQXZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 12:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592843004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CilW4QD63L7ddkS1ZkAZpBin2RZYz0neDQLL3pGsPE4=;
        b=Hiu6SEasS/5mI8os0ZgXE+rgoanDOGv4J3VhyLx789fDYGKiWic+2XYcZnirIznYIRQCc0
        CAFS1s1GWdZFX77lsIkpWqE51u3+AVqDGFurPnFfeckR67kqs+iDdjCb2JSq6t+cr0RcDo
        HohXw092h/8dSZUrhSQxfG/IkbxpPLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-RtF2wcKAO2mzsAwuHz4H6A-1; Mon, 22 Jun 2020 12:23:22 -0400
X-MC-Unique: RtF2wcKAO2mzsAwuHz4H6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDC121005512;
        Mon, 22 Jun 2020 16:23:20 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01ED260BE2;
        Mon, 22 Jun 2020 16:23:18 +0000 (UTC)
Date:   Mon, 22 Jun 2020 18:23:14 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Reindl Harald <h.reindl@thelounge.net>, Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622182314.6267f247@redhat.com>
In-Reply-To: <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
References: <20200619141157.GU23632@orbyte.nwl.cc>
        <20200622124207.GA25671@salvia>
        <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[Adding J=C3=B3zsef]

On Mon, 22 Jun 2020 15:34:24 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> Am 22.06.20 um 14:42 schrieb Pablo Neira Ayuso:
> > Hi Phil,
> >=20
> > On Fri, Jun 19, 2020 at 04:11:57PM +0200, Phil Sutter wrote: =20
> >> Hi Pablo,
> >>
> >> I remember you once asked for the benchmark scripts I used to compare
> >> performance of iptables-nft with -legacy in terms of command overhead
> >> and caching, as detailed in a blog[1] I wrote about it. I meanwhile
> >> managed to polish the scripts a bit and push them into a public repo,
> >> accessible here[2]. I'm not sure whether they are useful for regular
> >> runs (or even CI) as a single run takes a few hours and parallel use
> >> likely kills result precision. =20
> >=20
> > So what is the _technical_ incentive for using the iptables blob
> > interface (a.k.a. legacy) these days then?
> >=20
> > The iptables-nft frontend is transparent and it outperforms the legacy
> > code for dynamic rulesets. =20
>=20
> it is not transparent enough because it don't understand classical ipset

By the way, now nftables should natively support all the features from
ipset.

My plan (for which I haven't found the time in months) would be to
write some kind of "reference" wrapper to create nftables sets from
ipset commands, and to render them back as ipset-style output.

I wonder if this should become the job of iptables-nft, eventually.

--=20
Stefano

