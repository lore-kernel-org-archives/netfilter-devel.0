From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Tue, 22 Jun 2004 15:17:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406221440450.2546-100000@blackhole.kfki.hu>
References: <20040622043928.GA21406@alpha.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Pablo Neira <pablo@eurodev.net>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040622043928.GA21406@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

On Tue, 22 Jun 2004, Willy Tarreau wrote:

> May I ask that we could have a new result other than INVALID for such
> packets ? It's becoming difficult to differenciate :
>
>   - valid packets for which there is no session
>   - valid packets for which there is a session but which are invalid wrt
>     this session (wrong flags, sequence numbers, retransmits, ...)
>   - invalid packets (in the 'unclean' sense)
>
> and it's either not possible to differentiate between :
>   - suspicious packets which we must let go through to try to re-establish
>     a session or close a session (eg SYN), which currently generate a
>     message such as "INVALID SYN (ignored)"
>   - totally valid packets.
>
> Perhaps we would need to add NOSESSION for the first case, keep INVALID
> for the second case, add UNCLEAN for the third case, and IGNORED for the
> fourth case. We could even add this only to ctstate so that setups relying
> on the state match don't see any change.
>
> It would really help for complicated setups and for people who want a
> high level of tracability, such as a bank I know of.

I'd split the packets in question into two big categories strictly
according to wether it's an unclean packet or not.

Unclean packets are easy and could simply and elegantly be handled by
a configurable unclean match, no problem with those.

The TCP window tracking patch splits the "other" heap further into
several categories:

- drop the packet on the floor directly (conntrack is out of sync and we
  want the client to resend the SYN so that we can pick the connection up
  properly),
- packet marked as invalid (out of window packet or packet would
  lead to an invalid state),
- packet accepted by conntrack but its data is ignored with respect of
  the current connection entry (SYN we let through to detect ouf of sync
  connections and RST packets answering it when the connection is fine
  and the SYN was invalid).

Without a refreshed dropped-table patch, you are unable to handle
(i.e. log) the first case. But conntrack can log the packets for you just
fine.

In the second and third case you are unable to override the decision of
conntrack on how it treated the packet. If you let trough the second
category of the packet, it won't hurt. However, if the SYNs in the third
case are dropped by your rule, then conntrack's attempt to do its job
properly is defeated. In all case conntrack can log the packets.

What would be the purpose of the extension you propose? Logging is already
supported if one wish to monitor such packets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
