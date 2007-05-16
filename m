From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: nf_conntrack: fix use-after-free in helper destroy
 callback invocation
Date: Wed, 16 May 2007 18:54:37 +0200
Message-ID: <464B374D.5000205@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010209050509070608070803"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------010209050509070608070803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

These two patches fix an oops when unloading helper modules and
a incorrect config ifdef.

Please apply, thanks.


--------------010209050509070608070803
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack: fix use-after-free in helper destroy callback invocation

When the helper module is removed for a master connection that has a
fulfilled expectation, but has already timed out and got removed from
the hash tables, nf_conntrack_helper_unregister can't find the master
connection to unset the helper, causing a use-after-free when the
expected connection is destroyed and releases the last reference to
the master.

The helper destroy callback was introduced for the PPtP helper to clean
up expectations and expected connections when the master connection
times out, but doing this from destroy_conntrack only works for
unfulfilled expectations since expected connections hold a reference
to the master, preventing its destruction. Move the destroy callback to
the timeout function, which fixes both problems.

Reported/tested by Gabor Burjan <buga@buvoshetes.hu>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a49738a0ca6dbe54bbc6672b52286ed6b1d8f4ce
tree aa2324f3dd628d3b74f6c6d57355b11adb2212d3
parent af3b146d26550f0c8e0d77b2117c6f8aec5d8146
author Patrick McHardy <kaber@trash.net> Wed, 16 May 2007 18:51:42 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 16 May 2007 18:51:42 +0200

 net/netfilter/nf_conntrack_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e8b5c2d..483e927 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -298,7 +298,6 @@ static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
-	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_l4proto *l4proto;
 	typeof(nf_conntrack_destroyed) destroyed;
 
@@ -309,9 +308,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	nf_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
-	if (help && help->helper && help->helper->destroy)
-		help->helper->destroy(ct);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -353,6 +349,10 @@ destroy_conntrack(struct nf_conntrack *nfct)
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
+	struct nf_conn_help *help = nfct_help(ct);
+
+	if (help && help->helper && help->helper->destroy)
+		help->helper->destroy(ct);
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.

--------------010209050509070608070803--
