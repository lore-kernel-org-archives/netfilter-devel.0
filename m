From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack/nf_nat: nf_conntrack_netlink fix
Date: Wed, 15 Nov 2006 06:14:34 +0100
Message-ID: <455AA23A.60506@trash.net>
References: <454D1C8F.5060302@trash.net> <454D291E.9010708@trash.net>
	<454D3137.40109@trash.net>
	<Pine.LNX.4.64.0611142051120.1650@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611142051120.1650@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> Attached is a simple fix on top of your git tree.
> 
> [NETFILTER]: nf_conntrack_netlink: fix hooknum
> 
> Buggy porting fixed, we can figure out the hooknum.

Thanks, I've folded it into the nf_nat patch. I'll look into
your allocation fix next, sorry for taking so long.
