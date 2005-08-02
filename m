From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] EXPORT_SYMBOL_GPL in talk-conntrack-nat and
 quake3-conntrack-nat appears to be missing (kernel 2.6.12)
Date: Tue, 2 Aug 2005 17:23:13 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508021722120.4634@yvahk01.tjqt.qr>
References: <1122917854.5098.18.camel@acer.home.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Franz Ferdinand <mojo7777@yandex.ru>
In-Reply-To: <1122917854.5098.18.camel@acer.home.org>
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


> /* Quake3 master server reply will add > 100 expectations per reply
>packet; when
>    doing lots of printk's, klogd may not be able to read /proc/kmsg
>fast enough */

The maximum you can do within one packet is the size of the printk buffer.
