From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug-Report 3-19-03 patch-o-matic-ng
Date: Mon, 22 Mar 2004 10:12:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403221004140.24116-100000@blackhole.kfki.hu>
References: <029901c40ee1$3c847280$d100a8c0@W2RZ8L4S02>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Gifford <maillist@jg555.com>
In-Reply-To: <029901c40ee1$3c847280$d100a8c0@W2RZ8L4S02>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 20 Mar 2004, Jim Gifford wrote:

> Welcome to Patch-o-matic (1.15)!
>
> Kernel:         /usr/src/linux
> Iptables:       /usr/src/iptables
>
> Each patch is a new feature: many have minimal impact, some do not.
> Almost every one has bugs, so don't apply what you don't need!
> -------------------------------------------------------
> Already applied: init_conntrack-optimize ipt_helper-invert-fix nf-log NETMAP
> SAME TTL connlimit fuzzy iprange mport nth sctp CLASSIFY
> iptables-loopcheck-speedup netfilter-docbook
>
> Testing tcp-window-tracking... not applied
> The tcp-window-tracking patch:
>    Author: Jozsef Kadlecsik
>    Status: proven to be quite stable, but still experimental
>
> Now for the error message
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> present 'ctstat' conflicts with to-be-installed 'tcp-window-tracking'
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> apply_dependencies: unable to apply dependent nf-log: cannot apply (22
> rejects out of 24 hunks)
> -----------------------------------------------------------------
>
> As you notice ctstat is not installed and nf-log is installed.

Thank you the bug report. Unfortunately deadlines are hanging over
my head and I'm not going to have any time to look at into the problem
until the first days of April :-((.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
