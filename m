From: Ryan Veety <ryan@ryanspc.com>
Subject: [PATCH] was Re: QUEUE on Alpha not working?
Date: Sat, 6 Sep 2003 21:16:22 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.55.0309062059230.31908@ryanspc.com>
References: <Pine.LNX.4.55.0309041224060.27499@ryanspc.com>
 <20030905121526.GF665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030905121526.GF665@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003, Harald Welte wrote:

> On Thu, Sep 04, 2003 at 01:17:56PM -0400, Ryan Veety wrote:
> > My DEC Alpha Multia is running debian unstable with kernel 2.4.21.  All code
> > that uses libipq fails.  ipq_message_type returns NLMSG_ERROR for every
> > packet.  Even the intercept tool from the netfilter testsuite (CVS) fails:
>
> can you please submit this to bugzilla.netfilter.org?
>
> James Morris (the ip_queue author) is currently moving from one
> continent to another... so it could take some time until he can have a
> look.

Instead of filing the bug report I decided to hunt down the bug.  The problem
was in the libipq.h header, where it assumed if the architecture was not 64bit
kernel/32bit userspace that the userspace must be 32bit for the ipq_id_t type.
I instead defined ipq_id_t the same way it is in the kernel code, as unsigned
long.  Now libipq should work everywhere (I'm assuming it was also broken on
other 64bit cpus).

--- netfilter-orig/userspace/include/libipq/libipq.h    2003-09-06
20:45:40.000000000 -0400
+++ netfilter/userspace/include/libipq/libipq.h 2003-09-06 20:44:50.000000000
-0400
@@ -35,7 +35,7 @@
 typedef u_int64_t ipq_id_t;
 #else
 #include <linux/netfilter_ipv4/ip_queue.h>
-typedef u_int32_t ipq_id_t;
+typedef unsigned long ipq_id_t;
 #endif

 #ifdef DEBUG_LIBIPQ


Ryan
     __________________________________________________________
   .'  Ryan Veety <ryan@ryanspc.com> - http://www.ryanspc.com  `.
   |          PGP Key: http://www.ryanspc.com/pgp.txt           |
    `----------------------------------------------------------'
