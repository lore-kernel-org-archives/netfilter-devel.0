From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] Kill 480 kB redundant data in conntrack application
Date: Tue, 22 Nov 2005 16:59:18 +0100
Message-ID: <43834056.7050405@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
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

the NUMBER_OF_OPT #define in the conntrack application is "a bit"
oversized. :-)


Fix bogus NUMBER_OF_OPT definition.

Index: conntrack/include/conntrack.h
===================================================================
--- conntrack/include/conntrack.h	(revision 4547)
+++ conntrack/include/conntrack.h	(working copy)
@@ -115,9 +115,9 @@
  	CT_OPT_ID_BIT		= 15,
  	CT_OPT_ID		= (1 << CT_OPT_ID_BIT),

-	CT_OPT_MAX		= CT_OPT_ID
+	CT_OPT_MAX_BIT		= CT_OPT_ID_BIT
  };
-#define NUMBER_OF_OPT   CT_OPT_MAX
+#define NUMBER_OF_OPT   (CT_OPT_MAX_BIT+1)

  struct ctproto_handler {
  	struct list_head 	head;


Signed-off-by: Marcus Sundberg <marcus@ingate.com>

-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
