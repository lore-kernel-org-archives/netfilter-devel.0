From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] MARK target doesn't allow to set highest bit
Date: 31 Oct 2002 12:47:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <veu1j2de35.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

libipt_MARK.c has been broken since iptables 1.2.7.
This patch makes it work properly again:

diff -u -r1.8 -r1.6
--- extensions/libipt_MARK.c	6 Aug 2002 18:46:18 -0000	1.8
+++ extensions/libipt_MARK.c	29 May 2002 13:08:16 -0000	1.6
@@ -46,9 +46,10 @@
 		= (struct ipt_mark_target_info *)(*target)->data;
 
 	switch (c) {
+		char *end;
 	case '1':
-		if (string_to_number(optarg, 0, 0xffffffff, 
-				     (unsigned int *)&markinfo->mark))
+		markinfo->mark = strtoul(optarg, &end, 0);
+		if (*end != '\0' || end == optarg)
 			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,



//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
