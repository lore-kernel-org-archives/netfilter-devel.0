From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] Avoid using freed memory in iptables.c
Date: Mon, 18 Jul 2005 17:53:37 +0200
Message-ID: <42DBD081.8080408@ingate.com>
References: <20050710150548.GK20465@sunbeam.de.gnumonks.org>
	<42D90485.5050603@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D90485.5050603@ingate.com>
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

Hi, resend in slighty more conformant(?) format:

The call to free_opts() in merge_options() is invalid C. The oldopts
argument always refers to the memory pointed to by the opts global,
which may be freed by the call to free_opts(), but oldopts is used
after the free_opts() call. This patch makes sure we don't use freed
memory.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>


--- a/iptables.c	2005/07/16 12:52:33
+++ b/iptables.c	2005/07/16 12:52:45
@@ -1028,9 +1028,6 @@ merge_options(struct option *oldopts, co
 	unsigned int num_old, num_new, i;
 	struct option *merge;

-	/* Release previous options merged if any */
-	free_opts(0);
-	
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);

@@ -1039,6 +1036,7 @@ merge_options(struct option *oldopts, co

 	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
+	free_opts(0); /* Release previous options merged if any */
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
 		merge[num_old + i].val += *option_offset;


-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
