From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2
 +	2.6.11-rc2-bk5
Date: Sun, 30 Jan 2005 23:27:08 +0100
Message-ID: <41FD5F3C.1060009@eurodev.net>
References: <200501271553.j0RFr747004108@StraightRunning.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040706080306080209080000"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Colin Harrison <colin.harrison@virgin.net>
In-Reply-To: <200501271553.j0RFr747004108@StraightRunning.com>
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

This is a multi-part message in MIME format.
--------------040706080306080209080000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Colin Harrison wrote:

>Hi
>I am experimenting with the linux kernel 2.6.10 + 2.6.11-rc2 +
>2.6.11-rc2-bk5.
>When I try to build CVS snapshot iptables (iptables-1.3.0-20050125) against
>this kernel I get:-
>
>
>make KERNEL_DIR=/home/src/kernel/linux-2.6.10
>....
>cc -O2 -Wall -Wunused -I/home/src/kernel/linux-2.6.10/include -Iinclude/
>-DIPTABLES_VERSION=\"1.3.0-20050125\"  -fPIC -o
>extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
>In file included from extensions/libipt_conntrack.c:13:
>/home/src/kernel/linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_tupl
>e.h:67: error: parse error before "u8"
>  
>
u8 seems not to be defined in user space, that's why iptables complains 
in compilation time. A quick grep at /usr/include on my laptop tells me 
that such definition doesn't exist in user space. AFAICS it's only 
defined in kernel space. So, I've renamed it to u_int8_t and that fixed 
the problem.

Patrick, if this is the best way to fix this problem, are you willing to 
add it to your patchset?

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------040706080306080209080000
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== include/linux/netfilter_ipv4/ip_conntrack_tuple.h 1.6 vs edited =====
--- 1.6/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-17 23:02:05 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-30 23:19:09 +01:00
@@ -64,10 +64,10 @@
 		} u;
 
 		/* The protocol. */
-		u8 protonum;
+		u_int8_t protonum;
 
 		/* The direction (for tuplehash) */
-		u8 dir;
+		u_int8_t dir;
 	} dst;
 };
 

--------------040706080306080209080000--
