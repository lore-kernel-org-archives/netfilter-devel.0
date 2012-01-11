From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: conntrack, suspicious RCU usage
Date: Wed, 11 Jan 2012 14:33:55 +0100
Message-ID: <1326288835.2767.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <201201111025.50994.hans.schillstrom@ericsson.com>
	 <1326276111.2767.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <201201111424.27282.hans.schillstrom@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hans Schillstrom <hans.schillstrom@ericsson.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51232 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2AKNd7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:33:59 -0500
Received: by wibhm14 with SMTP id hm14so358167wib.19
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2012 05:33:58 -0800 (PST)
In-Reply-To: <201201111424.27282.hans.schillstrom@ericsson.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 11 janvier 2012 =C3=A0 14:24 +0100, Hans Schillstrom a =C3=A9=
crit :
> On Wednesday 11 January 2012 11:01:51 Eric Dumazet wrote:

> > Hmm, we either need to take rcu_read_lock() while calling
> > __nf_ct_l3proto_find(), or define a variant using
> > rcu_dereference_protected() in places we hold nf_conntrack_lock
> >=20
> I made a qick test with locks /unlocks in
> __nf_ct_l3proto_find() and __nf_ct_l4proto_find()
>=20
> 	rcu_read_lock();
> ...
> 	rcu_read_unlock();
> 	return retp;
>=20
> It seems to help, I cant see the dump anymore and everything else tha=
t I run works ...
>=20
>=20

You cant do that, its just a brown paper bag :)

If "retp" is returned, then the caller must handle the rcu_read_unlock(=
)
itself, after all possible "retp" dereferences.

But really adding rcu_read_lock() should not be necessary on paths we
own the conntrack lock. We should use rcu_dereference_protected()
instead.

I'll send a patch.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
