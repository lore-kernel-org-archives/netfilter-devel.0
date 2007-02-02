From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Fri, 2 Feb 2007 12:05:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0702021158250.3560@blackhole.kfki.hu>
References: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
	<200701271734.46876@auguste.remlab.net>
	<200702010141.l111fFVK020135@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: nakam@linux-ipv6.org, rdenis@simphalempin.com,
	netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702010141.l111fFVK020135@toshiba.co.jp>
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

On Thu, 1 Feb 2007, Yasuyuki KOZAKAI wrote:

> >> > > What happens if a node (including a non-Linux one) receives a MH packet
> >> > > with a non-none next protocol? I might be wrong, but I would assume it
> >> > > parses it, at least in some cases.
>
> The node will send ICMP parameter problem back with code depending on
> whether the node supports MH or not.
> If it supports, the code is 0 (erroneous header field) as RFC3775.
> Otherwise, the code 1 (unrecognized Next Header).
>
>
> >> > > If this is trye, this patch might introduce a trivial way to evade
> >> > > firewall rules, as firewall admins will assume the next protocol is
> >> > > none, while it might not be.
> >> > >
> >> > > Of course, I could be plain wrong, since I do not know MH.
>
> If the sender creates MH with nexthdr=TCP for example,
> it may go through the firewall which is configured even MH=ACCEPT
> TCP=DROP. However, the receiver cannot handle it as TCP.
>
> Can I add nexthdr check, or should I rewrite it as "-m" module
> to treat MH as an extension header?

Personally, I'd prefer a check in the MH match that makes sure there is no 
more header, simply because we cannot assume that the sender keeps the 
rules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
