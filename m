From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Mon, 10 Jan 2005 20:54:40 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E1B9F1.7010106@trash.net>
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

On Mon, 10 Jan 2005, Patrick McHardy wrote:

> I have actually given up keeping nf_conntrack up to date currently, but
> I hope we can now really put ip_conntrack in maintenance mode and
> concentrate
> on nf_conntrack. Any chance you want to base this on the nf_conntrack
> patch ?

Actually, what is the opinion that nf_conntrack uses the union of IPv4 and
IPv6 addresses in the tuples?

The infrastructure is there in the patch to support IPv4/IPv6 conntrack
separatedly in spite of the common code and not to waste so many bytes at
every IPv4 connections for the sake of supporting IPv6. Shouldn't there be
put more effort into this long standing issue, before swithcing over it?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
