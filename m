From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Tue, 22 Jun 2004 15:31:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406221528230.2546-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0406221440450.2546-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Pablo Neira <pablo@eurodev.net>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <Pine.LNX.4.33.0406221440450.2546-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 22 Jun 2004, Jozsef Kadlecsik wrote:

>
> On Tue, 22 Jun 2004, Willy Tarreau wrote:
>
> > May I ask that we could have a new result other than INVALID for such
> > packets ? It's becoming difficult to differenciate :
> >
> >   - valid packets for which there is no session
> >   - valid packets for which there is a session but which are invalid wrt
> >     this session (wrong flags, sequence numbers, retransmits, ...)
> >   - invalid packets (in the 'unclean' sense)
[...]
> > It would really help for complicated setups and for people who want a
> > high level of tracability, such as a bank I know of.
[...]
> What would be the purpose of the extension you propose? Logging is already
> supported if one wish to monitor such packets.

If the point is just fine tuned selective logging, then a new target (or
better a generic NFCACHE target) in the raw table would be the most
simple solution.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
