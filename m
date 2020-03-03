Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A483C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 22:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E48C2206E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 22:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="im3edqPw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgCCWQ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 17:16:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22473 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726766AbgCCWQ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 17:16:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583273817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGf1/TYpf/ybE1nRohmXuagtKzNvgyYvUw2Bt24WWDs=;
        b=im3edqPwEujIv6e/zz3BvMFZ3Pnv80Nf3JjvHpqtDEnkbXXfPiWEw9RIkkmDHEiB+DZP/P
        Xr0CUShk5EH5UPwbPSjM8eahyusNqiWGJKcirq8HOpu4AD2A5AbzuCFNoRBXnN7+gFp3DB
        XN4BF1TbIkSC+FmrmFE9a8JNeqCmvok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-XhcIEfaJNMGr1coBR9NHCQ-1; Tue, 03 Mar 2020 17:16:56 -0500
X-MC-Unique: XhcIEfaJNMGr1coBR9NHCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14BA318C8C01;
        Tue,  3 Mar 2020 22:16:55 +0000 (UTC)
Received: from elisabeth (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 107695D9C9;
        Tue,  3 Mar 2020 22:16:52 +0000 (UTC)
Date:   Tue, 3 Mar 2020 23:16:46 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200303231646.472e982e@elisabeth>
In-Reply-To: <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
        <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>
        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
        <20200225215322.6fb5ecb0@redhat.com>
        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
        <20200228124039.00e5a343@redhat.com>
        <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi J=C3=B3zsef,

On Tue, 3 Mar 2020 10:36:53 +0100 (CET)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> Hi Stefano,
>=20
> On Fri, 28 Feb 2020, Stefano Brivio wrote:
>=20
> > On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >  =20
> > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > >  =20
> > > > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > >    =20
> > > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > > >    =20
> > > > > > > The logic could be changed in the user rules from
> > > > > > >=20
> > > > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j =
DROP
> > > > > > >=20
> > > > > > > to
> > > > > > >=20
> > > > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j =
ACCEPT
> > > > > > > [ otherwise DROP ]
> > > > > > >=20
> > > > > > > but of course it might be not so simple, depending on how the=
 rules are=20
> > > > > > > built up.     =20
> > > > > >=20
> > > > > > Yes, it would work, unless the user actually wants to check wit=
h the
> > > > > > same counter how many bytes are sent "in excess".     =20
> > > > >=20
> > > > > You mean the counters are still updated whenever the element is m=
atched in=20
> > > > > the set and then one could check how many bytes were sent over th=
e=20
> > > > > threshold just by listing the set elements.   =20
> > > >=20
> > > > Yes, exactly -- note that it was possible (and, I think, used) befo=
re.   =20
> > >=20
> > > I'm still not really convinced about such a feature. Why is it useful=
 to=20
> > > know how many bytes would be sent over the "limit"? =20
> >=20
> > This is useful in case one wants different treatments for packets
> > according to a number of thresholds in different rules. For example,
> >=20
> >     iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
> >     iptables -I noise -m set --match-set c src --bytes-lt 20000 -j down=
load
> >=20
> > and you want to log packets from chains 'noise' and 'download' with
> > different prefixes. =20
>=20
> What do you think about this patch?

Thanks, I think it gives a way to avoid the issue.

I'm still not convinced that keeping this disabled by default is the
best way to go (mostly because we had a kernel change affecting
semantics that were exported to userspace for a long time), but if
there's a need for the opposite of this option, introducing it as a
negation becomes linguistically awkward. :)

And anyway, it's surely better than not having this possibility at all.

Let me know if you want me to review (or try to draft) man page
changes. Just a few comments inline:

> diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/=
include/uapi/linux/netfilter/ipset/ip_set.h
> index 7545af4..6881329 100644
> --- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -186,6 +186,9 @@ enum ipset_cmd_flags {
>  	IPSET_FLAG_MAP_SKBPRIO =3D (1 << IPSET_FLAG_BIT_MAP_SKBPRIO),
>  	IPSET_FLAG_BIT_MAP_SKBQUEUE =3D 10,
>  	IPSET_FLAG_MAP_SKBQUEUE =3D (1 << IPSET_FLAG_BIT_MAP_SKBQUEUE),
> +	IPSET_FLAG_BIT_UPDATE_COUNTERS_FIRST =3D 11,
> +	IPSET_FLAG_UPDATE_COUNTERS_FIRST =3D
> +		(1 << IPSET_FLAG_BIT_UPDATE_COUNTERS_FIRST),
>  	IPSET_FLAG_CMD_MAX =3D 15,
>  };
> =20
> diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfil=
ter/ipset/ip_set_core.c
> index 1df6536..423d0de 100644
> --- a/kernel/net/netfilter/ipset/ip_set_core.c
> +++ b/kernel/net/netfilter/ipset/ip_set_core.c
> @@ -622,10 +622,9 @@ ip_set_add_packets(u64 packets, struct ip_set_counte=
r *counter)
> =20
>  static void
>  ip_set_update_counter(struct ip_set_counter *counter,
> -		      const struct ip_set_ext *ext, u32 flags)
> +		      const struct ip_set_ext *ext)
>  {
> -	if (ext->packets !=3D ULLONG_MAX &&
> -	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
> +	if (ext->packets !=3D ULLONG_MAX) {

This means that UPDATE_COUNTERS_FIRST wins over SKIP_COUNTER_UPDATE. Is
that intended? Intuitively, I would say that "skip" is more imperative
than "do it *first*". Anyway, I guess they will be mutually exclusive.

>  		ip_set_add_bytes(ext->bytes, counter);
>  		ip_set_add_packets(ext->packets, counter);
>  	}
> @@ -649,13 +648,19 @@ ip_set_match_extensions(struct ip_set *set, const s=
truct ip_set_ext *ext,
>  	if (SET_WITH_COUNTER(set)) {
>  		struct ip_set_counter *counter =3D ext_counter(data, set);
> =20
> +		if (flags & IPSET_FLAG_UPDATE_COUNTERS_FIRST)
> +			ip_set_update_counter(counter, ext);
> +
>  		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
>  		    !(ip_set_match_counter(ip_set_get_packets(counter),
>  				mext->packets, mext->packets_op) &&
>  		      ip_set_match_counter(ip_set_get_bytes(counter),
>  				mext->bytes, mext->bytes_op)))
>  			return false;
> -		ip_set_update_counter(counter, ext, flags);
> +
> +		if (!(flags & (IPSET_FLAG_UPDATE_COUNTERS_FIRST|

Nit: whitespace before |.

> +			       IPSET_FLAG_SKIP_COUNTER_UPDATE)))
> +			ip_set_update_counter(counter, ext);
>  	}
>  	if (SET_WITH_SKBINFO(set))
>  		ip_set_get_skbinfo(ext_skbinfo(data, set),
>=20
> Then the rules above would look like
>=20
> ... -m set ... --update-counters-first --bytes-lt 100 -j noise
> ... -m set ... --update-counters-first --bytes-ge 100 -j download

Sorry for the typo in my previous example, I really meant:

  iptables -I INPUT -m set --match-set c src --bytes-gt 100 -j noise
  iptables -I noise -m set --match-set c src --bytes-gt 20000 -j download

that is, "noise" is more than "a single connection attempt", and
"download" is even more. But I think your example is equivalent for
this purpose.

> > > > What I meant is really the case where "--update-counters" (or=20
> > > > "--force-update-counters") and "! --update-counters" are both=20
> > > > absent: I don't see any particular advantage in the current=20
> > > > behaviour for that case. =20
> > >=20
> > > The counters are used just for statistical purposes: reflect the=20
> > > packets/bytes which were let through, i.e. matched the whole "rule".=
=20
> > > In that case updating the counters before the counter value matching=
=20
> > > is evaluated gives false results. =20
> >=20
> > Well, but for that, iptables/x_tables counters are available and (as fa=
r=20
> > as I know) typically used. =20
>=20
> With "rules" I meant at ipset level (match element + packet/byte counters=
=20
> as specified), i.e. counters for statistical purposes per set elements=20
> level.

Ah, I see now, thanks for explaining.

--=20
Stefano

