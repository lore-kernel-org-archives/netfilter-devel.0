From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:39:25 +0200
Message-ID: <20060511083925.GD10324@sunbeam.de.gnumonks.org>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462CD64.1060507@net.in.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="11Y7aswkeuHtSBEs"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
Content-Disposition: inline
In-Reply-To: <4462CD64.1060507@net.in.tum.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2006 at 05:36:36PM +1200, Gregor Maier wrote:
> Hi,
>=20
> I wrote a patch about 2 month ago, that does something similiar.

mh, I must have missed that, sorry.

> Maybe some of it is usefull. If you are interested I would venture to
> update the patch.

I think we should merge them in some way.

> The patch uses only a modified version of the normal LOG target, but I
> wanted to change this to a NF_LOG target anyway.

Ok, a new LOG target would be fine, yes.

I now actually like the idea that the old LOG target and old ULOG target
just continue to do what the used to do.=20

Only NFLOG supersedes all of them, and allows to access the full
flexibility of all backends.

> * Everything uses nf_log.c as logging API (excpect the obsolete ULOG targ=
ets)

as indicated, maybe we should modify LOG back to the old syslog-only
behaviour, too.

> * Loggers in nf_log.c are stackable. More than one logger can be register=
ed
>     per PF

I don't like that idea, since it is overkill from my point of view.  If
somebody wants to log a packet twice, he can have multiple rules in the
ruleset for doing so.

> * nf_loginfo struct has been changed. Instead of the type field and the
>     union there is a "backends" field now that contains a bitmask specifi=
ng
>     which backends should process/log this packet.=20

bitmask is only required if we go for multiple backends.

> * ipt_LOGc and ip6t_LOG.c have been splitted:=20
>     * xt_LOG.c  now contains the targets. The targets
>         always use nf_log for logging. These should be the only
>         logging targets. They take care of setting up nf_loginfo for
>         logging to syslog and/or to other backends
>     * ip_log_syslog.c and ip6_log_syslog.c are new and contain the
>         syslog log backends. When these modules are loaded, the syslog
>         backend is registered with nf_log

that makes sense to a certain degree.  However, if we say that LOG
should be just like in old times, and we have a new NFLOG target, then
that change makes a little bit less sense.  Still I like it because it's
clean.

However, we need to make sure that module autoloading works, e.g. if
somebody uses your xt_LOG (or the 'LOG as in old times' target), then
the ip*_log_syslog.ko backend would have to be loaded on demand.  Also,
I'd prefer the names to indicate that they're netfilter related.

> POTENTIAL PROBLEMS / ALTERNATIVE SOLUTION
> * ipt_log_info and ip6t_log_info have been replaced by xt_log_info (which
>     has changed in size). This means iptables must be recompiled and older
>     iptables versions won't work with these changes.=20

this is not acceptable.

I'll modify my patch and merge the changes of your patch that I like and
produce a resulting patchset later today.

Thansk!
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--11Y7aswkeuHtSBEs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEYvg9XaXGVTD0i/8RAj6lAJ0Z93DnZ6SXo1PBP8Zv6i+vxxI2sQCgrKe2
TmkuELY/79K+5SpkjMSdt+4=
=zqmu
-----END PGP SIGNATURE-----

--11Y7aswkeuHtSBEs--
