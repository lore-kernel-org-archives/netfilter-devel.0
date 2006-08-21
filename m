From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/18]: nfnetlink: remove unnecessary packed attributes
Date: Tue, 22 Aug 2006 00:52:39 +0200 (MEST)
Message-ID: <20060821225238.10288.62091.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: remove unnecessary packed attributes

Remove unnecessary packed attributes in nfnetlink structures. Unfortunately
in a few cases they have to stay to avoid changing structure sizes.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9c8627cc82b512bf2c7d07f0a9afd9a6afc9e7ec
tree e8491a9be51317f39b98618dfee2564b27dca2c2
parent 0945146f9085ef6469e137000fd125df648a137f
author Patrick McHardy <kaber@trash.net> Fri, 18 Aug 2006 04:38:47 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 18 Aug 2006 04:38:47 +0200

 include/linux/netfilter/nfnetlink.h       |    4 ++--
 include/linux/netfilter/nfnetlink_log.h   |    6 +++---
 include/linux/netfilter/nfnetlink_queue.h |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 9f5b12c..6d8e3e5 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -43,7 +43,7 @@ struct nfattr
 	u_int16_t nfa_len;
 	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
 				 * bit to indicate whether the payload is nested */
-} __attribute__ ((packed));
+};
 
 /* FIXME: Apart from NFNL_NFA_NESTED shamelessly copy and pasted from
  * rtnetlink.h, it's time to put this in a generic file */
@@ -79,7 +79,7 @@ struct nfgenmsg {
 	u_int8_t  nfgen_family;		/* AF_xxx */
 	u_int8_t  version;		/* nfnetlink version */
 	u_int16_t res_id;		/* resource id */
-} __attribute__ ((packed));
+};
 
 #define NFNETLINK_V0	0
 
diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index a7497c7..87b92f8 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -19,18 +19,18 @@ struct nfulnl_msg_packet_hdr {
 	u_int16_t	hw_protocol;	/* hw protocol (network order) */
 	u_int8_t	hook;		/* netfilter hook */
 	u_int8_t	_pad;
-} __attribute__ ((packed));
+};
 
 struct nfulnl_msg_packet_hw {
 	u_int16_t	hw_addrlen;
 	u_int16_t	_pad;
 	u_int8_t	hw_addr[8];
-} __attribute__ ((packed));
+};
 
 struct nfulnl_msg_packet_timestamp {
 	aligned_u64	sec;
 	aligned_u64	usec;
-} __attribute__ ((packed));
+};
 
 #define NFULNL_PREFIXLEN	30	/* just like old log target */
 
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 9e77437..36af036 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -22,12 +22,12 @@ struct nfqnl_msg_packet_hw {
 	u_int16_t	hw_addrlen;
 	u_int16_t	_pad;
 	u_int8_t	hw_addr[8];
-} __attribute__ ((packed));
+};
 
 struct nfqnl_msg_packet_timestamp {
 	aligned_u64	sec;
 	aligned_u64	usec;
-} __attribute__ ((packed));
+};
 
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
@@ -49,7 +49,7 @@ #define NFQA_MAX (__NFQA_MAX - 1)
 struct nfqnl_msg_verdict_hdr {
 	u_int32_t verdict;
 	u_int32_t id;
-} __attribute__ ((packed));
+};
 
 
 enum nfqnl_msg_config_cmds {
@@ -64,7 +64,7 @@ struct nfqnl_msg_config_cmd {
 	u_int8_t	command;	/* nfqnl_msg_config_cmds */
 	u_int8_t	_pad;
 	u_int16_t	pf;		/* AF_xxx for PF_[UN]BIND */
-} __attribute__ ((packed));
+};
 
 enum nfqnl_config_mode {
 	NFQNL_COPY_NONE,
