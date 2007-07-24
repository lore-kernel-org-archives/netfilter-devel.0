From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH IPTABLES 0/13]: Unifies rest of ip[6]tables
 matches/targets
Date: Tue, 24 Jul 2007 18:08:55 +0900 (JST)
Message-ID: <200707240908.l6O98uqj002574@toshiba.co.jp>
References: <200707240657.l6O6vfKE018716@toshiba.co.jp>
	<Pine.LNX.4.64.0707241052250.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707241052250.18990@fbirervta.pbzchgretzou.qr>
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

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 24 Jul 2007 10:54:25 +0200 (CEST)

> iptables svn6960 does not yet search for the libxt_*.so files.
> 
> 
> # strace -e open ./iptables -t nat -L
> ...
> open("/ws/iptables/extensions/libipt_tcp.so", O_RDONLY) = -1 ENOENT (No 
> such file or directory)
> REDIRECT   tcp  --  anywhere             192.168.250.2       UNKNOWN 
> match `tcp' redir ports 8080 

Thanks for report.

I wrote Makefile to make symbolic link from libip[6]t_*.so to libxt_*.so.
How did you make and install iptables ?

-- Yasuyuki Kozakai
