From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] fix problem with netfilter compat code removal
Date: 16 Apr 2003 16:00:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1050501636.30792.50.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Here's a fix for 2.4, the netfilter compat code removal forgot to remove
one instance of 'reset'. Doesn't compile without this fix.

Please apply to 2.4 (it's ok in 2.5)

--- linux-2.4-bk.error/net/ipv4/netfilter/ipfwadm_core.c	2003-04-15 17:42:15.000000000 +0200
+++ linux-2.4-bk.fixed/net/ipv4/netfilter/ipfwadm_core.c	2003-04-16 15:44:16.000000000 +0200
@@ -1176,12 +1176,6 @@
 			len = last_len;
 			break;
 		}
-		else if(reset)
-		{
-			/* This needs to be done at this specific place! */
-			i->fw_pcnt=0L;
-			i->fw_bcnt=0L;
-		}
 		last_len = len;
 		i=i->fw_next;
 	}


-- 
/Martin
