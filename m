From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Conntrack & NAT question
Date: Mon, 19 Jul 2004 08:51:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1090219917.2551.6.camel@nienna.balabit>
References: <1089882225.2556.10.camel@nienna.balabit>
	 <40F69EC8.80903@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40F69EC8.80903@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-07-15, cs keltez=E9ssel 17:12-kor Pablo Neira ezt =EDrta:
> >  The 'new' parameter means we're updating an entry we've just created=
.
> >So, unless the entry is new, we check whether the tuples in the update
> >message are the same as ours. And, unfortunately, I have a few asserti=
on
> >failed messages in the logs... :(
> > =20
> >
>=20
> maybe this could be related to the initialization of the tuple and=20
> repl_tuple contained in ct_sync message. I didn't have much time to hav=
e=20
> a look at ct_sync implementation so far, if I'm missing anything, pleas=
e=20
> let me know.

  I don't think this is a problem here, the two memcpy() calls overwrite
the whole tuples anyway. And the problem is much more rare, it happened
maybe five times an hour on our test system. (Note: the test system did
not have l2drop enabled, that is, broadcast messages on the attached
ethernet segments were received on both nodes. This was already a source
of a couple of problems before, but I thought that problem was solved by
checking if the conntrack entry is active (its timer is initialized),
and not touching it in that case.)

  But thanks for the idea, of course. :)

--=20
 Regards,
   Krisztian KOVACS
