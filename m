From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 12:51:41 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406211240500.31871-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0406211102000.23953-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406211102000.23953-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jun 2004, Henrik Nordstrom wrote:

> > ++      /* 15 is the highest 'known' ICMP code. See RFC 1812 */
> > ++      if (icmph.code > 15) {
> > ++              if (LOG_INVALID(IPPROTO_ICMP))
> > ++                      nf_log_packet(PF_INET, 0, skb, NULL, NULL,
> > ++                                    "ip_ct_icmp: invalid ICMP code ");
> > ++              return -NF_ACCEPT;
> > ++      }
>
> This is a good case where INVALID is the appropriate response. As the code
> is not defined today it can not be defined how/if it should be tracked,
> but this alone is not a reason to drop the packet.

So you could live happily if such packets are marked as INVALID by
conntrack, which implies then that the ICMP code/type checking would be
acceptable as well? [Pablo's patch did not want to drop the packets but
mark as INVALID.]

It's time to add documentation exactly which packets are dropped or marked
as INVALID by conntrack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
