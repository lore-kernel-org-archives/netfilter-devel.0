From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] Missing free on error in iptables 1.3.4
Date: Wed, 09 Nov 2005 16:15:06 +0100
Message-ID: <4372127A.7040307@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

the patch below fixes a missing free() statement in TC_COMMIT(),
and moves the setting of errno to come right before the return.

//Marcus

--- iptables.4490/libiptc/libiptc.c	(revision 4490)
+++ iptables/libiptc/libiptc.c	(working copy)
@@ -2081,9 +2081,10 @@

  	ret = iptcc_compile_table(*handle, repl);
  	if (ret < 0) {
-		errno = ret;
  		free(repl->counters);
  		free(repl);
+		free(newcounters);
+		errno = ret;
  		return 0;
  	}


Signed-off-by: Marcus Sundberg <marcus@ingate.com>

-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
