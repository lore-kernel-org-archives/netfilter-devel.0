From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] kernel panic with rpc.patch
Date: Thu, 2 Sep 2004 21:21:13 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040903042113.GA19923@linuxace.com>
References: <20040902232357.GA18422@linuxace.com> <4137CE4D.7070702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Cc: netfilter-devel@lists.netfilter.org, Phil Oester <netfilter@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4137CE4D.7070702@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 03, 2004 at 03:52:13AM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> 
> >Some useless __MOD_INC_USE_COUNT macros make rpc patch panic on boot.
> >The below removes them.  Boot tested.
> 
> Applied, but wondering on second thought. There are still two
> __MOD_DEC_USE_COUNT left, and __MOD_INC_USE_COUNT does actually
> do something :) Why are they useless ?

Yes, perhaps 'useless' is the wrong word -- they do something, but 
something which is deprecated and in 2.6 netfilter nonexistent. And
following davem's policy of no refcounts for network drivers [1], it
seems to make sense.

Agreed, however, that removing the INC without also removing the DEC
is sloppy.  Attached find a patch to do so.

Phil

[1] http://www.uwsg.iu.edu/hypermail/linux/kernel/0307.3/0403.html



--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-rpc2

diff -ru pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c
--- pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2004-09-03 00:17:53.859176224 -0400
+++ pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2004-09-03 00:17:41.524051448 -0400
@@ -412,10 +412,6 @@
 {
 	DEBUGP("unregistering match\n");
 	ipt_unregister_match(&rpc_match);
-
-	DEBUGP("decrementing usage counts\n");
-	__MOD_DEC_USE_COUNT(ip_conntrack_rpc_tcp);
-	__MOD_DEC_USE_COUNT(ip_conntrack_rpc_udp);
 }
 
 

--FCuugMFkClbJLl1L--
