From: Julian Anastasov <ja@ssi.bg>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Sun, 11 Jan 2004 15:55:47 +0200 (EET)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli>
References: <20030725173900.E6E952C2AE@lists.samba.org> <200307251756.VAA12609@dub.inr.ac.ru>
 <20040111130114.GJ20706@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kuznet@ms2.inr.ac.ru, Rusty Russell <rusty@rustcorp.com.au>,
	fenio@o2.pl, davem@redhat.com, linux-net@vger.kernel.org,
	kaber@trash.net,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040111130114.GJ20706@sunbeam.de.gnumonks.org>
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Sun, 11 Jan 2004, Harald Welte wrote:

> As an example case where I would suspect problems: The packet could be
> coming from a local socket, and the socket be bound to a specific
> interface (sk->bound_dev_if).

	IMO, the real example is that the people use multipath routes
and providing oif was the only way MASQUERADE to meet the netfilter
and firewalling expectations of not changing the output device during
hooks. OTOH, providing oif=0 is the valid approach for selecting the
right route but as long as the above expectation exists there are
two options for the users:

- provide oif learned from the input route (as before the discussed
change). May be in 99% of the setups it selects the right route.
I think, we should use this, at least for 2.4.

- use CONNMARK or similar functionality to keep the connection
bound to its path. As long as CONNMARK is not a standard feature
there is no safe way to use multipath routes with MASQUERADE and
SNAT in the latest kernels. Even before this change it was risky
to rely on the routing cache to keep NAT connections bound to
its path in the multipath route - the cache entries expire.

Regards

--
Julian Anastasov <ja@ssi.bg>
