From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/05]: net/ipv[46]/netfilter.c cleanups
Date: Tue, 10 Jan 2006 01:50:56 +0100
Message-ID: <43C304F0.7080204@trash.net>
References: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
	<20060109.164529.87893152.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060101010509010604050704"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060109.164529.87893152.davem@davemloft.net>
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
--------------060101010509010604050704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 10 Jan 2006 01:38:38 +0100
> 
> 
>>following are a couple of netfilter fixes and cleanup patches. The first two
>>PPTP patches fix critical bugs, I'm going to push them to -stable as well.
> 
> 
> All applied, thanks Patrick.
> 

Oops, missed one :)

--------------060101010509010604050704
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix timeout sysctls on big-endian 64bit architectures

The connection tracking timeout variables are unsigned long, but
proc_dointvec_jiffies is used with sizeof(unsigned int) in the sysctl
tables. Since there is no proc_doulongvec_jiffies function, change the
timeout variables to unsigned int.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 16e6d946e635f88097c2e9303b9fde04e3b6e754
tree aeda640c98f827c1b205f9b9a2f15d0e57448236
parent 77b5a9142e3a53b375c6c21ec80fdbe890a8403c
author Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 07:21:58 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 07:21:58 +0100

 net/ipv4/netfilter/ip_conntrack_proto_generic.c |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c    |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c    |   16 +++++++-------
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c     |   20 +++++++++---------
 net/ipv4/netfilter/ip_conntrack_proto_udp.c     |    4 ++--
 net/ipv4/netfilter/ip_conntrack_standalone.c    |   26 ++++++++++++-----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c  |    4 ++--
 net/netfilter/nf_conntrack_proto_generic.c      |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c         |   16 +++++++-------
 net/netfilter/nf_conntrack_proto_tcp.c          |   20 +++++++++---------
 net/netfilter/nf_conntrack_proto_udp.c          |    4 ++--
 net/netfilter/nf_conntrack_standalone.c         |   24 +++++++++++----------
 13 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_generic.c b/net/ipv4/netfilter/ip_conntrack_proto_generic.c
index 88c3712..f891308 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
-unsigned long ip_ct_generic_timeout = 600*HZ;
+unsigned int ip_ct_generic_timeout = 600*HZ;
 
 static int generic_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 30fc21d..f2a90e2 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
-unsigned long ip_ct_icmp_timeout = 30*HZ;
+unsigned int ip_ct_icmp_timeout = 30*HZ;
 
 #if 0
 #define DEBUGP printk
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
index 977fb59..50963c9 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -57,15 +57,15 @@ static const char *sctp_conntrack_names[
 #define HOURS * 60 MINS
 #define DAYS  * 24 HOURS
 
-static unsigned long ip_ct_sctp_timeout_closed            =  10 SECS;
-static unsigned long ip_ct_sctp_timeout_cookie_wait       =   3 SECS;
-static unsigned long ip_ct_sctp_timeout_cookie_echoed     =   3 SECS;
-static unsigned long ip_ct_sctp_timeout_established       =   5 DAYS;
-static unsigned long ip_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
-static unsigned long ip_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
-static unsigned long ip_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
+static unsigned int ip_ct_sctp_timeout_closed            =  10 SECS;
+static unsigned int ip_ct_sctp_timeout_cookie_wait       =   3 SECS;
+static unsigned int ip_ct_sctp_timeout_cookie_echoed     =   3 SECS;
+static unsigned int ip_ct_sctp_timeout_established       =   5 DAYS;
+static unsigned int ip_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
+static unsigned int ip_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
+static unsigned int ip_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
 
-static const unsigned long * sctp_timeouts[]
+static const unsigned int * sctp_timeouts[]
 = { NULL,                                  /* SCTP_CONNTRACK_NONE  */
     &ip_ct_sctp_timeout_closed,	           /* SCTP_CONNTRACK_CLOSED */
     &ip_ct_sctp_timeout_cookie_wait,       /* SCTP_CONNTRACK_COOKIE_WAIT */
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index e7fa29e..79afbeb 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -85,21 +85,21 @@ static const char *tcp_conntrack_names[]
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-unsigned long ip_ct_tcp_timeout_syn_sent =      2 MINS;
-unsigned long ip_ct_tcp_timeout_syn_recv =     60 SECS;
-unsigned long ip_ct_tcp_timeout_established =   5 DAYS;
-unsigned long ip_ct_tcp_timeout_fin_wait =      2 MINS;
-unsigned long ip_ct_tcp_timeout_close_wait =   60 SECS;
-unsigned long ip_ct_tcp_timeout_last_ack =     30 SECS;
-unsigned long ip_ct_tcp_timeout_time_wait =     2 MINS;
-unsigned long ip_ct_tcp_timeout_close =        10 SECS;
+unsigned int ip_ct_tcp_timeout_syn_sent =      2 MINS;
+unsigned int ip_ct_tcp_timeout_syn_recv =     60 SECS;
+unsigned int ip_ct_tcp_timeout_established =   5 DAYS;
+unsigned int ip_ct_tcp_timeout_fin_wait =      2 MINS;
+unsigned int ip_ct_tcp_timeout_close_wait =   60 SECS;
+unsigned int ip_ct_tcp_timeout_last_ack =     30 SECS;
+unsigned int ip_ct_tcp_timeout_time_wait =     2 MINS;
+unsigned int ip_ct_tcp_timeout_close =        10 SECS;
 
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds 
    to ~13-30min depending on RTO. */
-unsigned long ip_ct_tcp_timeout_max_retrans =     5 MINS;
+unsigned int ip_ct_tcp_timeout_max_retrans =     5 MINS;
  
-static const unsigned long * tcp_timeouts[]
+static const unsigned int * tcp_timeouts[]
 = { NULL,                              /*      TCP_CONNTRACK_NONE */
     &ip_ct_tcp_timeout_syn_sent,       /*      TCP_CONNTRACK_SYN_SENT, */
     &ip_ct_tcp_timeout_syn_recv,       /*      TCP_CONNTRACK_SYN_RECV, */
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
index 46becbe..004003f 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -19,8 +19,8 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
-unsigned long ip_ct_udp_timeout = 30*HZ;
-unsigned long ip_ct_udp_timeout_stream = 180*HZ;
+unsigned int ip_ct_udp_timeout = 30*HZ;
+unsigned int ip_ct_udp_timeout_stream = 180*HZ;
 
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 7ba9778..9dec129 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -544,28 +544,28 @@ extern int ip_conntrack_max;
 extern unsigned int ip_conntrack_htable_size;
 
 /* From ip_conntrack_proto_tcp.c */
-extern unsigned long ip_ct_tcp_timeout_syn_sent;
-extern unsigned long ip_ct_tcp_timeout_syn_recv;
-extern unsigned long ip_ct_tcp_timeout_established;
-extern unsigned long ip_ct_tcp_timeout_fin_wait;
-extern unsigned long ip_ct_tcp_timeout_close_wait;
-extern unsigned long ip_ct_tcp_timeout_last_ack;
-extern unsigned long ip_ct_tcp_timeout_time_wait;
-extern unsigned long ip_ct_tcp_timeout_close;
-extern unsigned long ip_ct_tcp_timeout_max_retrans;
+extern unsigned int ip_ct_tcp_timeout_syn_sent;
+extern unsigned int ip_ct_tcp_timeout_syn_recv;
+extern unsigned int ip_ct_tcp_timeout_established;
+extern unsigned int ip_ct_tcp_timeout_fin_wait;
+extern unsigned int ip_ct_tcp_timeout_close_wait;
+extern unsigned int ip_ct_tcp_timeout_last_ack;
+extern unsigned int ip_ct_tcp_timeout_time_wait;
+extern unsigned int ip_ct_tcp_timeout_close;
+extern unsigned int ip_ct_tcp_timeout_max_retrans;
 extern int ip_ct_tcp_loose;
 extern int ip_ct_tcp_be_liberal;
 extern int ip_ct_tcp_max_retrans;
 
 /* From ip_conntrack_proto_udp.c */
-extern unsigned long ip_ct_udp_timeout;
-extern unsigned long ip_ct_udp_timeout_stream;
+extern unsigned int ip_ct_udp_timeout;
+extern unsigned int ip_ct_udp_timeout_stream;
 
 /* From ip_conntrack_proto_icmp.c */
-extern unsigned long ip_ct_icmp_timeout;
+extern unsigned int ip_ct_icmp_timeout;
 
 /* From ip_conntrack_proto_icmp.c */
-extern unsigned long ip_ct_generic_timeout;
+extern unsigned int ip_ct_generic_timeout;
 
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min = 0;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 9bdbb77..0c56c52 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -277,7 +277,7 @@ static struct nf_hook_ops ipv4_conntrack
 
 #ifdef CONFIG_SYSCTL
 /* From nf_conntrack_proto_icmp.c */
-extern unsigned long nf_ct_icmp_timeout;
+extern unsigned int nf_ct_icmp_timeout;
 static struct ctl_table_header *nf_ct_ipv4_sysctl_header;
 
 static ctl_table nf_ct_sysctl_table[] = {
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 704fbbe..e57d6fc 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -335,10 +335,10 @@ static struct nf_hook_ops ipv6_conntrack
 #ifdef CONFIG_SYSCTL
 
 /* From nf_conntrack_proto_icmpv6.c */
-extern unsigned long nf_ct_icmpv6_timeout;
+extern unsigned int nf_ct_icmpv6_timeout;
 
 /* From nf_conntrack_frag6.c */
-extern unsigned long nf_ct_frag6_timeout;
+extern unsigned int nf_ct_frag6_timeout;
 extern unsigned int nf_ct_frag6_low_thresh;
 extern unsigned int nf_ct_frag6_high_thresh;
 
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 36425f6..46bc27e 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
 
-unsigned long nf_ct_generic_timeout = 600*HZ;
+unsigned int nf_ct_generic_timeout = 600*HZ;
 
 static int generic_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 3a600f7..cf798e6 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -62,15 +62,15 @@ static const char *sctp_conntrack_names[
 #define HOURS * 60 MINS
 #define DAYS  * 24 HOURS
 
-static unsigned long nf_ct_sctp_timeout_closed            =  10 SECS;
-static unsigned long nf_ct_sctp_timeout_cookie_wait       =   3 SECS;
-static unsigned long nf_ct_sctp_timeout_cookie_echoed     =   3 SECS;
-static unsigned long nf_ct_sctp_timeout_established       =   5 DAYS;
-static unsigned long nf_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
-static unsigned long nf_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
-static unsigned long nf_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
+static unsigned int nf_ct_sctp_timeout_closed            =  10 SECS;
+static unsigned int nf_ct_sctp_timeout_cookie_wait       =   3 SECS;
+static unsigned int nf_ct_sctp_timeout_cookie_echoed     =   3 SECS;
+static unsigned int nf_ct_sctp_timeout_established       =   5 DAYS;
+static unsigned int nf_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
+static unsigned int nf_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
+static unsigned int nf_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
 
-static unsigned long * sctp_timeouts[]
+static unsigned int * sctp_timeouts[]
 = { NULL,                                  /* SCTP_CONNTRACK_NONE  */
     &nf_ct_sctp_timeout_closed,	           /* SCTP_CONNTRACK_CLOSED */
     &nf_ct_sctp_timeout_cookie_wait,       /* SCTP_CONNTRACK_COOKIE_WAIT */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6167137..8f20305 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -93,21 +93,21 @@ static const char *tcp_conntrack_names[]
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-unsigned long nf_ct_tcp_timeout_syn_sent =      2 MINS;
-unsigned long nf_ct_tcp_timeout_syn_recv =     60 SECS;
-unsigned long nf_ct_tcp_timeout_established =   5 DAYS;
-unsigned long nf_ct_tcp_timeout_fin_wait =      2 MINS;
-unsigned long nf_ct_tcp_timeout_close_wait =   60 SECS;
-unsigned long nf_ct_tcp_timeout_last_ack =     30 SECS;
-unsigned long nf_ct_tcp_timeout_time_wait =     2 MINS;
-unsigned long nf_ct_tcp_timeout_close =        10 SECS;
+unsigned int nf_ct_tcp_timeout_syn_sent =      2 MINS;
+unsigned int nf_ct_tcp_timeout_syn_recv =     60 SECS;
+unsigned int nf_ct_tcp_timeout_established =   5 DAYS;
+unsigned int nf_ct_tcp_timeout_fin_wait =      2 MINS;
+unsigned int nf_ct_tcp_timeout_close_wait =   60 SECS;
+unsigned int nf_ct_tcp_timeout_last_ack =     30 SECS;
+unsigned int nf_ct_tcp_timeout_time_wait =     2 MINS;
+unsigned int nf_ct_tcp_timeout_close =        10 SECS;
 
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds 
    to ~13-30min depending on RTO. */
-unsigned long nf_ct_tcp_timeout_max_retrans =     5 MINS;
+unsigned int nf_ct_tcp_timeout_max_retrans =     5 MINS;
  
-static unsigned long * tcp_timeouts[]
+static unsigned int * tcp_timeouts[]
 = { NULL,                              /* TCP_CONNTRACK_NONE */
     &nf_ct_tcp_timeout_syn_sent,       /* TCP_CONNTRACK_SYN_SENT, */
     &nf_ct_tcp_timeout_syn_recv,       /* TCP_CONNTRACK_SYN_RECV, */
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 1a592a5..4264dd0 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -27,8 +27,8 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
 
-unsigned long nf_ct_udp_timeout = 30*HZ;
-unsigned long nf_ct_udp_timeout_stream = 180*HZ;
+unsigned int nf_ct_udp_timeout = 30*HZ;
+unsigned int nf_ct_udp_timeout_stream = 180*HZ;
 
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d17e42b..3531d14 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -431,25 +431,25 @@ extern int nf_conntrack_max;
 extern unsigned int nf_conntrack_htable_size;
 
 /* From nf_conntrack_proto_tcp.c */
-extern unsigned long nf_ct_tcp_timeout_syn_sent;
-extern unsigned long nf_ct_tcp_timeout_syn_recv;
-extern unsigned long nf_ct_tcp_timeout_established;
-extern unsigned long nf_ct_tcp_timeout_fin_wait;
-extern unsigned long nf_ct_tcp_timeout_close_wait;
-extern unsigned long nf_ct_tcp_timeout_last_ack;
-extern unsigned long nf_ct_tcp_timeout_time_wait;
-extern unsigned long nf_ct_tcp_timeout_close;
-extern unsigned long nf_ct_tcp_timeout_max_retrans;
+extern unsigned int nf_ct_tcp_timeout_syn_sent;
+extern unsigned int nf_ct_tcp_timeout_syn_recv;
+extern unsigned int nf_ct_tcp_timeout_established;
+extern unsigned int nf_ct_tcp_timeout_fin_wait;
+extern unsigned int nf_ct_tcp_timeout_close_wait;
+extern unsigned int nf_ct_tcp_timeout_last_ack;
+extern unsigned int nf_ct_tcp_timeout_time_wait;
+extern unsigned int nf_ct_tcp_timeout_close;
+extern unsigned int nf_ct_tcp_timeout_max_retrans;
 extern int nf_ct_tcp_loose;
 extern int nf_ct_tcp_be_liberal;
 extern int nf_ct_tcp_max_retrans;
 
 /* From nf_conntrack_proto_udp.c */
-extern unsigned long nf_ct_udp_timeout;
-extern unsigned long nf_ct_udp_timeout_stream;
+extern unsigned int nf_ct_udp_timeout;
+extern unsigned int nf_ct_udp_timeout_stream;
 
 /* From nf_conntrack_proto_generic.c */
-extern unsigned long nf_ct_generic_timeout;
+extern unsigned int nf_ct_generic_timeout;
 
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min = 0;

--------------060101010509010604050704--
