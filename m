From: Phil Oester <kernel@linuxace.com>
Subject: Re: #263154: iptables: segfault with multiple ip hostnames
Date: Tue, 3 Aug 2004 15:11:30 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040803221130.GA25495@linuxace.com>
References: <20040803220350.GA5223@ljlane.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>
Content-Disposition: inline
In-Reply-To: <20040803220350.GA5223@ljlane.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 03, 2004 at 06:03:50PM -0400, Laurence J. Lane wrote:
> http://bugs.debian.org/263154
> 
> iptables 1.2.11 segfaults when given a domain name that resolves 
> to multiple ip addresses. The situation is the same for kernel 
> versions 2.4.26 and 2.6.7.

This is fixed in CVS.  Patch below for reference.

Phil


diff -u -r1.68 -r1.69
--- iptables/iptables.c	2004/05/26 16:04:48	1.68
+++ iptables/iptables.c	2004/07/04 15:20:53	1.69
@@ -2339,11 +2339,8 @@
 		e = NULL;
 	}
 
-	for (c = 0; c < nsaddrs; c++)
-		free(&saddrs[c]);
-
-	for (c = 0; c < ndaddrs; c++)
-		free(&daddrs[c]);
+	free(saddrs);
+	free(daddrs);
 
 	if (opts != original_opts) {
 		free(opts);
