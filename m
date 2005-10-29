From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPSET] help with netlink connector
Date: Sat, 29 Oct 2005 19:42:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0510291934030.5550@blackhole.kfki.hu>
References: <200510291616.55535.vl4d@spine-group.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: vl4d@spine-group.org
In-Reply-To: <200510291616.55535.vl4d@spine-group.org>
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

On Sat, 29 Oct 2005 vl4d@spine-group.org wrote:

> I'm trying to rewrite the ipset sockopt interface with netlink connector
> introduced in 2.6.14... anyway i need some help and directions.
>
> As far as i have understood ipset adds SO_ IP_SET option to IP and manage the
> whole stuff through {set|get}sockopt. How can i access this option using
> connector? do i have to register a connector callback at kernel level  using
> a module and send messages from ipset ??

That'd mean a complete rewriting of the kernel-userspace communication in
ipset. You would not want to access the (set|get)sockopt from netlink but
replace it with a netlink communication channel. Instead of netlink, the
netfilter specific nfnetlink is the proper tool for such a rewriting.
(The subject is on the TODO list of ipset.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
