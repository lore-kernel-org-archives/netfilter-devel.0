From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: netfilter conntrack tcp lock
Date: Wed, 22 Apr 2009 06:57:21 +0200
Message-ID: <49EEA3B1.9030803@cosmosbay.com>
References: <20090421210412.268fc4e7@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([212.99.114.194]:60042 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZDVE52 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 00:57:28 -0400
In-Reply-To: <20090421210412.268fc4e7@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger a =E9crit :
> Not sure what the performance impact would be but simply changing tcp=
_lock
> (in nf_conntrack_proto_tcp) to a spin_lock might get a performance bo=
ost.
> I thought I heard Paul say read_locks are way slower than spin_lock.
>=20
> Alternatively, going to some form of bit based hash lock might work.
>=20
>=20

I thought Patrick was OK with adding a spinlock into each nf_conn struc=
t ?
(We shrunk this struct with the rcu_head removal)

A straight forward locking schem. We have spinlocks everywhere in kerne=
l afterall, and
conntracking deserves this.
=20
Just resubmit one of your prior patch perhaps ? I can dig it in a coupl=
e of hours eventually.

Thanks

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
