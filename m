From: Phil Oester <kernel@linuxace.com>
Subject: re: find_appropriate_src() BUG also exist in 2.4.24
Date: Sun, 4 Apr 2004 15:37:35 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040404223735.GA1334@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I too am having lockups every few hours on a heavily used gateway.  

Back in September, Rusty offered this patch:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012388.html

Which to this point is not in either 2.4 or 2.6, but looks as though
it may actually fix the endless loop we seem to be experiencing.

Alternatively, the following patch was merged in 2.6, but is not present
in 2.4.24 -- could this also help?

--- 1.34/net/ipv4/netfilter/ip_nat_core.c	Sun Apr  4 15:21:19 2004
+++ 1.35/net/ipv4/netfilter/ip_nat_core.c	Sun Apr  4 15:21:19 2004
@@ -421,7 +421,8 @@
 			*tuple = ((struct ip_conntrack_tuple)
 				  { *manip, orig_tuple->dst });
 			DEBUGP("get_unique_tuple: Found current src map\n");
-			return 1;
+			if (!ip_nat_used_tuple(tuple, conntrack))
+				return 1;
 		}
 	}


Any thoughts on either of the above would be appreciated.

Phil Oester
