From: Marcus Sundberg <marcus@ingate.com>
Subject: ctnetlink delete conntrack performance
Date: Mon, 07 Mar 2005 12:25:15 +0100
Message-ID: <422C3A1B.5080604@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi,

When the CTNL_MSG_DELCONNTRACK function of the ctnetlink patch is
used it calls ip_ct_selective_cleanup() to remove the conntrack.

This is highly ineffective (depending on how many hash buckets you
have ofcourse - I had 131007 of them when performing the test :-)

Is there any reason I'm missing (except that maybe the code should
go into it's own function) for not simply doing it this way:

--- nfnetlink_conntrack.c	2005/03/05 21:17:43	1.1
+++ nfnetlink_conntrack.c	2005/03/06 21:49:34
@@ -366,9 +366,11 @@
  		DUMP_TUPLE(tuple);
  		return -ENOENT;
  	}
-
-	ct_debug(0, "calling selective_cleanup\n");
-	ip_ct_selective_cleanup(ctnetlink_kill, h->ctrack);
+	
+	ct_debug(0, "deleting conntrack\n");
+	ip_conntrack_put(h->ctrack);
+	if (del_timer(&h->ctrack->timeout))
+		ip_ct_death_by_timeout((unsigned long)h->ctrack);

  	return 0;
  }

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
