From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: suggestion, p-o-m, iplimit for ipv6 protocol
Date: Wed, 30 Apr 2003 12:57:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304301249220.3330-100000@blackhole.kfki.hu>
References: <20030430033035.GB4762@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Marek Figielski <raptorek@cki.net.pl>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Marshall <tommy@home.tig-grr.com>
In-Reply-To: <20030430033035.GB4762@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 29 Apr 2003, Tom Marshall wrote:

> > As there is no connection tracking for IPv6, there is no chance of
> > implementing an 'iplimit' match for ip6_tables :(
>
> Sorry for a perhaps naive question, but why is there no IPv6 conntrack?

A blind porting of the IPv4 conntrack is unacceptable due to the code
duplication.

A blind union with IPv4 conntrack is unacceptable due to the sheer wasting
of memory.

An intelligent unification of IPv4/6 conntrack is possible. That itself is
not so easy and one should keep in mind the relation with NAT, which
makes it at the end complicated and hard.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
