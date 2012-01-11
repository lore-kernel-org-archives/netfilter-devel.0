From: Hans Schillstrom <hans.schillstrom@ericsson.com>
Subject: Re: conntrack, suspicious RCU usage
Date: Wed, 11 Jan 2012 14:44:31 +0100
Message-ID: <201201111444.31605.hans.schillstrom@ericsson.com>
References: <201201111025.50994.hans.schillstrom@ericsson.com> <201201111424.27282.hans.schillstrom@ericsson.com> <1326288835.2767.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:58618 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2AKNoe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:44:34 -0500
In-Reply-To: <1326288835.2767.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 11 January 2012 14:33:55 Eric Dumazet wrote:
> Le mercredi 11 janvier 2012 =C3=A0 14:24 +0100, Hans Schillstrom a =C3=
=A9crit :
> > On Wednesday 11 January 2012 11:01:51 Eric Dumazet wrote:
>=20
> > > Hmm, we either need to take rcu_read_lock() while calling
> > > __nf_ct_l3proto_find(), or define a variant using
> > > rcu_dereference_protected() in places we hold nf_conntrack_lock
> > >=20
> > I made a qick test with locks /unlocks in
> > __nf_ct_l3proto_find() and __nf_ct_l4proto_find()
> >=20
> > 	rcu_read_lock();
> > ...
> > 	rcu_read_unlock();
> > 	return retp;
> >=20
> > It seems to help, I cant see the dump anymore and everything else t=
hat I run works ...
> >=20
> >=20
>=20
> You cant do that, its just a brown paper bag :)
>=20
OK it didn't feel right ...

> If "retp" is returned, then the caller must handle the rcu_read_unloc=
k()
> itself, after all possible "retp" dereferences.
>=20
> But really adding rcu_read_lock() should not be necessary on paths we
> own the conntrack lock. We should use rcu_dereference_protected()
> instead.
>=20
> I'll send a patch.

Thanks
Hans
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
