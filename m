From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 10:56:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406211033420.31871-100000@blackhole.kfki.hu>
References: <40D60A2D.2080800@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40D60A2D.2080800@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, 21 Jun 2004, Pablo Neira wrote:

> Would you be willing to apply the patch attached to pom-ng? It applies
> to linux-2.6.patch_02-udp-icmp and it adds more checkings for invalid
> icmp combinations.

Let us be very careful here and not add half of the unclean match to
conntrack.

We always have to remind ourselves that the sole task of the connection
tracking subsystem is to keep track of connections as good as possible.
We drop packets directly only when letting trough the packet would render
connection tracking useless (therefore it's so rare). We *advice* the
admin to drop packets by flagging it as INVALID when we can surely say
that the packet in question is invalid in the context of the connection
where it seems to belong to. But it's practically as strong a decision
as dropping the packet directly, so we have to be careful there as well.

I had already hesitated over the implications of the code

++      /* 15 is the highest 'known' ICMP code. See RFC 1812 */
++      if (icmph.code > 15) {
++              if (LOG_INVALID(IPPROTO_ICMP))
++                      nf_log_packet(PF_INET, 0, skb, NULL, NULL,
++                                    "ip_ct_icmp: invalid ICMP code ");
++              return -NF_ACCEPT;
++      }

because it means that if a new ICMP code is introduced, even if we modify
the source code, all previously installed systems runnin netfilter
(estimate that number) would refuse to handle the new ICMP code: we
created a forward-incompatibility.

I'd better not add the code checkings and would even remove the one above,
unless you have strong arguments against doing so.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
