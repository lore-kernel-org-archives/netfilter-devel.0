From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset -L causing kernel panic when using macipmap
Date: Mon, 6 Dec 2004 10:36:53 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412061024150.5880@blackhole.kfki.hu>
References: <41B07CD8.8080800@routehat.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Surda <shurdeek@routehat.org>
In-Reply-To: <41B07CD8.8080800@routehat.org>
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

On Fri, 3 Dec 2004, Peter Surda wrote:

> I don't know if this is the correct mailing list for ipset, but there
> doesn't seem to be much other information online so I'm trying it here.
>
> I'm using kernel 2.4.26, iptables 1.2.11 and ipset 1.0 (at least I think
> it is 1.0, changelog claims this) and am playing with it a little.

'ipset -v' always reports the version number.

Please use ipset 2.0 (i.e ipset utility and the kernel part from
patch-o-matic-ng) from the svn repository or download the snapshots from
http://people.netfilter.org/kadlec/ipset/install.html.

It was a useful report because the bug was still present in 2.0 and
was fixed now.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
