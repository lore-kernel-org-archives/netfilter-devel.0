From: "dada1" <dada1@cosmosbay.com>
Subject: TARPIT on linux-2.6
Date: Wed, 15 Oct 2003 09:30:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <0e2701c392ee$3e198f00$d800a8c0@edumazet>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all

I tried to compile TARPIT module (from patch-o-matic-20030912.tar.bz2) on a
linux-2.6.0-test5 kernel :

make modules
  CC [M]  net/ipv4/netfilter/ipt_TARPIT.o
net/ipv4/netfilter/ipt_TARPIT.c: In function `tarpit_tcp':
net/ipv4/netfilter/ipt_TARPIT.c:182: warning: implicit declaration of
function `ip_route_output'
net/ipv4/netfilter/ipt_TARPIT.c:192: structure has no member named `pmtu'
net/ipv4/netfilter/ipt_TARPIT.c: At top level:
net/ipv4/netfilter/ipt_TARPIT.c:268: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ipt_TARPIT.c:268: warning: initialization from
incompatible pointer type

It seems linux-2.6 made some changes on ip_route_output() stuff, that I dont
understand at all to try my own patches... :)

The pmtu part is easy : (line 192)

-   if (nskb->len > nskb->dst->pmtu)
+   if (nskb->len > dst_pmtu(nskb->dst))

The ipt_target part too (line 270)

- static struct ipt_target ipt_tarpit_reg
- = { { NULL, NULL }, "TARPIT", tarpit, check, NULL, THIS_MODULE };
+ static struct ipt_target ipt_tarpit_reg = {
+  .name       = "TARPIT",
+   .target     = tarpit,
+  .checkentry = check,
+    .me     = THIS_MODULE,
+ }

Anybody willing to help about ip_route_output() ?

Thanks
Eric Dumazet
