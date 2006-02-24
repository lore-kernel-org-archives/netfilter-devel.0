From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: problem with ipset and 2.4.31, again...
Date: Fri, 24 Feb 2006 14:15:37 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602241409590.10263@blackhole.kfki.hu>
References: <20060224111012.GA26233@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@packetconsulting.pl>
In-Reply-To: <20060224111012.GA26233@packetconsulting.pl>
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

Hi,

On Fri, 24 Feb 2006, Piotr Chytla wrote:

> ipset from patch-o-matic-ng(r6345) fails to compile on 2.4.31/32, Problem and
> solution is the same as this :

We are at rev 6470 in p-o-m-ng, I think you are using a too old release.

lockhelp.h dependecy was completely removed from ipset so
CONFIG_NETFILTER_DEBUG does not affect it at all.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
