From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH IPTABLES 0/13]: Unifies rest of ip[6]tables
	matches/targets
Date: Tue, 24 Jul 2007 10:54:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241052250.18990@fbirervta.pbzchgretzou.qr>
References: <200707240657.l6O6vfKE018716@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707240657.l6O6vfKE018716@toshiba.co.jp>
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



iptables svn6960 does not yet search for the libxt_*.so files.


# strace -e open ./iptables -t nat -L
...
open("/ws/iptables/extensions/libipt_tcp.so", O_RDONLY) = -1 ENOENT (No 
such file or directory)
REDIRECT   tcp  --  anywhere             192.168.250.2       UNKNOWN 
match `tcp' redir ports 8080 



	Jan
-- 
