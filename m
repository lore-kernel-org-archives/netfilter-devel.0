From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: nf_conntrack_ipv4 must be loaded explicitly
Date: Thu, 2 Aug 2007 20:11:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708021937140.9319@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: kaber@trash.net
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757730AbXHBSL3@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


in recent git kernels, I experience the following "regression" that no 
packets traverse the nat table (esp. the POSTROUTING counters just stand 
still) - and hence things like ping+SNAT do not work. Bisect nailed it 
down to:

ff09b7493c8f433d3ffd6a31ad58d190f82ef0c5 is first bad commit
commit ff09b7493c8f433d3ffd6a31ad58d190f82ef0c5
Author: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date:   Sat Jul 7 22:25:28 2007 -0700

    [NETFILTER]: nf_nat: remove unused nf_nat_module_is_loaded

    Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 177886eca60385293ac736c8e4861a2d4910d90a 32e63b6a9399e1ea65dc6cd0b357ca811e4dc835 M      include
:040000 040000 e1c20c3db28c927af62df067b2a20f8604a5fe06 84a277d1f81e3be9ce37ce6040c6d814ca20b3b0 M      net


The diff from ff09b7^...ff09b7 made me think...

End result:

After loading nf_conntrack_ipv4.ko, everything works again (also with 
the "bad" ff09b7). But I have to load it explicitly, and I think that 
unfortunately breaks a lot of setups (such as mine) which assume ipv4 
connection tracking is always there.

Comments?


	Jan
-- 
