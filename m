From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPSET] help with netlink connector
Date: Tue, 1 Nov 2005 19:28:36 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0511011926420.10515@blackhole.kfki.hu>
References: <20051101183023.GA6290@debian>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carlo Comin <vl4d@spine-group.org>
In-Reply-To: <20051101183023.GA6290@debian>
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

On Tue, 1 Nov 2005, Carlo Comin wrote:

> > Instead of netlink, the netfilter specific nfnetlink is the
> > proper tool for such a rewriting.
>
> ...wait, do you mean nfnetlink instead of the newest connector?

As far as I see, both the newest connector and nfnetlink are just
instances of netlink. But because netfilter are going to use nfnetlink,
ipset should use the same.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
