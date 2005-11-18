From: Harald Welte <laforge@netfilter.org>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Fri, 18 Nov 2005 09:37:57 +0100
Message-ID: <20051118083757.GP14201@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<20051117151135.GJ14201@sunbeam.de.gnumonks.org>
	<437D4825.1060801@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <437D4825.1060801@eurodev.net>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Fri, Nov 18, 2005 at 04:19:01AM +0100, Pablo Neira wrote:
> Harald Welte wrote:
> > On Thu, Nov 17, 2005 at 01:36:35AM +0100, Pablo Neira wrote:
> > 
> >>[NETFILTER] Fix ip_conntrack_proto_find_get badness
> > 
> > thanks, applied.
> 
> Sorry Harald, that patch is incomplete :(. Please, revert it. Attached
> the final version.

ok, thanks.

> BTW, you have two trees at people.netfilter.org, which one should I use?

netfilter-2.6.14 is a convenience symlink to netfilter-2.6, so it
doesn't really matter ;)

- -- 
- - Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDfZLlXaXGVTD0i/8RArhAAJ9ctfHsQrmU/GR8SqC432WOY4LWUACfWnxt
HEKRrHwG8HftuofIc5B0HoQ=
=hr/D
-----END PGP SIGNATURE-----
