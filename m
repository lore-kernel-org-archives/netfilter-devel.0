From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/17]: conntrack: add fixed timeout flag in connection
	tracking
Date: Tue, 30 May 2006 00:34:20 +0200 (MEST)
Message-ID: <20060529223420.24834.27353.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: add fixed timeout flag in connection tracking

Add a flag in a connection status to have a non updated timeout.
This permits to have connection that automatically die at a given
time.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fc38099c5c54d23c8cee06ba1b1450f58b5ca1c2
tree 989d91b694430d2bde828a00d81847950108d89a
parent 951256425de86a32569c787ff827554314026824
author Eric Leblond <eric@inl.fr> Tue, 30 May 2006 00:02:45 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:45 +0200

 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 net/ipv4/netfilter/ip_conntrack_core.c        |    6 ++++++
 net/netfilter/nf_conntrack_core.c             |    6 ++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3ff88c8..d2e4bd7 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -69,6 +69,10 @@ enum ip_conntrack_status {
 	/* Connection is dying (removed from lists), can not be unset. */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
+
+	/* Connection has fixed timeout. */
+	IPS_FIXED_TIMEOUT_BIT = 10,
+	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
 };
 
 /* Connection tracking event bits */
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 979a2ea..9f0d6ce 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,6 +1130,12 @@ void __ip_ct_refresh_acct(struct ip_conn
 
 	write_lock_bh(&ip_conntrack_lock);
 
+	/* Only update if this is not a fixed timeout */
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)) {
+		write_unlock_bh(&ip_conntrack_lock);
+		return;
+	}
+
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9b83f9..bc2bd4c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1396,6 +1396,12 @@ void __nf_ct_refresh_acct(struct nf_conn
 
 	write_lock_bh(&nf_conntrack_lock);
 
+	/* Only update if this is not a fixed timeout */
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)) {
+		write_unlock_bh(&nf_conntrack_lock);
+		return;
+	}
+
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
