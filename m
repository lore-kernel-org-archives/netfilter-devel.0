From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] nfsim: Support more netfilter modules
Date: Tue, 13 Dec 2005 14:51:01 +0100
Message-ID: <439ED1C5.7070103@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000807040409030405090408"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------000807040409030405090408
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

this patch adds nfsim support for building most of the netfilter stuff
in 2.6.15. The things still not compiling are CONFIG_IP_NF_CONNTRACK_NETLINK
and CONFIG_IP_NF_MATCH_STRING

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------000807040409030405090408
Content-Type: text/x-patch;
 name="nfsim-1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfsim-1.diff"

[NFSIM] Support more netfilter modules

This patch makes it possible to build with, and enables, the following
2.6.15 options in the nfsim framework:

CONFIG_IP_NF_CONNTRACK_EVENTS
CONFIG_IP_NF_CT_PROTO_SCTP
CONFIG_IP_NF_NETBIOS_NS
CONFIG_IP_NF_PPTP
CONFIG_IP_NF_MATCH_DCCP
CONFIG_IP_NF_MATCH_CONNBYTES
CONFIG_IP_NF_TARGET_NFQUEUE
CONFIG_IP_NF_NAT_PPTP
CONFIG_IP_NF_TARGET_TTL

It also fixes compilation of ipt_hashlimit.c and ipt_sctp.c, as well
as the external IP sets patch by Jozsef Kadlecsik.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>


--- nfsim/core/ipv4/ipv4.h	(revision 6316)
+++ nfsim/core/ipv4/ipv4.h	(working copy)
@@ -72,6 +72,7 @@
   IPPROTO_PUP = 12,		/* PUP protocol				*/
   IPPROTO_UDP = 17,		/* User Datagram Protocol		*/
   IPPROTO_IDP = 22,		/* XNS IDP protocol			*/
+  IPPROTO_DCCP = 33,		/* Datagram Congestion Control Protocol */
   IPPROTO_RSVP = 46,		/* RSVP protocol			*/
   IPPROTO_GRE = 47,		/* Cisco GRE tunnels (rfc 1701,1702)	*/
 
@@ -314,6 +315,150 @@
   } un;
 };
 
+/* sctp.h */
+
+typedef struct sctphdr {
+	__u16 source;
+	__u16 dest;
+	__u32 vtag;
+	__u32 checksum;
+} __attribute__((packed)) sctp_sctphdr_t;
+
+typedef struct sctp_chunkhdr {
+	__u8 type;
+	__u8 flags;
+	__u16 length;
+} __attribute__((packed)) sctp_chunkhdr_t;
+
+typedef enum {
+	SCTP_CID_DATA			= 0,
+        SCTP_CID_INIT			= 1,
+        SCTP_CID_INIT_ACK		= 2,
+        SCTP_CID_SACK			= 3,
+        SCTP_CID_HEARTBEAT		= 4,
+        SCTP_CID_HEARTBEAT_ACK		= 5,
+        SCTP_CID_ABORT			= 6,
+        SCTP_CID_SHUTDOWN		= 7,
+        SCTP_CID_SHUTDOWN_ACK		= 8,
+        SCTP_CID_ERROR			= 9,
+        SCTP_CID_COOKIE_ECHO		= 10,
+        SCTP_CID_COOKIE_ACK	        = 11,
+        SCTP_CID_ECN_ECNE		= 12,
+        SCTP_CID_ECN_CWR		= 13,
+        SCTP_CID_SHUTDOWN_COMPLETE	= 14,
+
+	/* PR-SCTP Sec 3.2 */
+	SCTP_CID_FWD_TSN		= 0xC0,
+
+	/* Use hex, as defined in ADDIP sec. 3.1 */
+	SCTP_CID_ASCONF			= 0xC1,
+	SCTP_CID_ASCONF_ACK		= 0x80,
+} sctp_cid_t; /* enum */
+
+typedef struct sctp_inithdr {
+	__u32 init_tag;
+	__u32 a_rwnd;
+	__u16 num_outbound_streams;
+	__u16 num_inbound_streams;
+	__u32 initial_tsn;
+	__u8  params[0];
+} __attribute__((packed)) sctp_inithdr_t;
+
+/* dccp.h */
+
+struct dccp_hdr {
+	__u16	dccph_sport,
+		dccph_dport;
+	__u8	dccph_doff;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8	dccph_cscov:4,
+		dccph_ccval:4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8	dccph_ccval:4,
+		dccph_cscov:4;
+#else
+#error  "Adjust your <asm/byteorder.h> defines"
+#endif
+	__u16	dccph_checksum;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u32	dccph_x:1,
+		dccph_type:4,
+		dccph_reserved:3,
+		dccph_seq:24;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u32	dccph_reserved:3,
+		dccph_type:4,
+		dccph_x:1,
+		dccph_seq:24;
+#else
+#error  "Adjust your <asm/byteorder.h> defines"
+#endif
+};
+
+struct dccp_hdr_ext {
+	__u32	dccph_seq_low;
+};
+struct dccp_hdr_request {
+	__u32	dccph_req_service;
+};
+struct dccp_hdr_ack_bits {
+	__u32	dccph_reserved1:8,
+		dccph_ack_nr_high:24;
+	__u32	dccph_ack_nr_low;
+};
+struct dccp_hdr_response {
+	struct dccp_hdr_ack_bits	dccph_resp_ack;
+	__u32				dccph_resp_service;
+};
+struct dccp_hdr_reset {
+	struct dccp_hdr_ack_bits	dccph_reset_ack;
+	__u8				dccph_reset_code,
+					dccph_reset_data[3];
+};
+
+enum dccp_pkt_type {
+	DCCP_PKT_REQUEST = 0,
+	DCCP_PKT_RESPONSE,
+	DCCP_PKT_DATA,
+	DCCP_PKT_ACK,
+	DCCP_PKT_DATAACK,
+	DCCP_PKT_CLOSEREQ,
+	DCCP_PKT_CLOSE,
+	DCCP_PKT_RESET,
+	DCCP_PKT_SYNC,
+	DCCP_PKT_SYNCACK,
+	DCCP_PKT_INVALID,
+};
+
+static inline unsigned int dccp_packet_hdr_len(const __u8 type)
+{
+	if (type == DCCP_PKT_DATA)
+		return 0;
+	if (type == DCCP_PKT_DATAACK	||
+	    type == DCCP_PKT_ACK	||
+	    type == DCCP_PKT_SYNC	||
+	    type == DCCP_PKT_SYNCACK	||
+	    type == DCCP_PKT_CLOSE	||
+	    type == DCCP_PKT_CLOSEREQ)
+		return sizeof(struct dccp_hdr_ack_bits);
+	if (type == DCCP_PKT_REQUEST)
+		return sizeof(struct dccp_hdr_request);
+	if (type == DCCP_PKT_RESPONSE)
+		return sizeof(struct dccp_hdr_response);
+	return sizeof(struct dccp_hdr_reset);
+}
+
+static inline unsigned int __dccp_basic_hdr_len(const struct dccp_hdr *dh)
+{
+	return sizeof(*dh) + (dh->dccph_x ? sizeof(struct dccp_hdr_ext) : 0);
+}
+
+static inline unsigned int __dccp_hdr_len(const struct dccp_hdr *dh)
+{
+	return __dccp_basic_hdr_len(dh) +
+	       dccp_packet_hdr_len(dh->dccph_type);
+}
+
 /* in_route.h */
 /* IPv4 routing cache flags */
 
@@ -503,6 +648,8 @@
 	u32			ifa_address;
 	u32			ifa_mask;
 	u32			ifa_broadcast;
+
+	unsigned char		ifa_flags;
 };
 
 
--- nfsim/kernelenv/include/kernelenv.h	(revision 6316)
+++ nfsim/kernelenv/include/kernelenv.h	(working copy)
@@ -59,6 +59,7 @@
 #define __s64 u64
 #define __be16 __u16
 #define __be32 __u32
+#define aligned_u64 uint64_t __attribute__((aligned(8)))
 
 /* Hacky, but works for now */
 #define BITS_PER_LONG (ULONG_MAX == 0xFFFFFFFFUL ? 32 : 64)
@@ -574,6 +575,14 @@
 #define LL_RESERVED_SPACE(dev) \
 	(((dev)->hard_header_len&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
+/* inetdevice.h */
+
+#define for_primary_ifa(in_dev)	{ struct in_ifaddr *ifa; \
+  for (ifa = (in_dev)->ifa_list; ifa && !(ifa->ifa_flags&IFA_F_SECONDARY); ifa = ifa->ifa_next)
+#define for_ifa(in_dev)	{ struct in_ifaddr *ifa; \
+  for (ifa = (in_dev)->ifa_list; ifa; ifa = ifa->ifa_next)
+#define endfor_ifa(in_dev) }
+
 /* skbuff */
 
 #define CHECKSUM_NONE 0
@@ -1076,6 +1085,8 @@
 
 #define RTAX_MAX RTAX_FEATURES
 
+#define IFA_F_SECONDARY		0x01
+
 /* dst.h */
 struct dst_entry
 {
@@ -1166,6 +1177,10 @@
 
 static inline void smp_read_barrier_depends(void) {;}
 
+/* delay.h */
+
+#define msleep(x)	do{unsigned int y = (x)*1000; usleep(y);}while(0)
+
 /* timer.h */
 
 /* not used at the moment */
@@ -1214,7 +1229,62 @@
 #define __set_bit set_bit
 int clear_bit(int nr, unsigned long *addr);
 int test_and_set_bit(int nr, unsigned long *addr);
+int test_and_clear_bit(int nr, unsigned long *addr);
 
+static inline int fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		x <<= 1;
+		r -= 1;
+	}
+	return r;
+}
+
+/* div64.h */
+
+#if BITS_PER_LONG == 64
+# define do_div(n,base) ({					\
+	uint32_t __base = (base);				\
+	uint32_t __rem;						\
+	__rem = ((uint64_t)(n)) % __base;			\
+	(n) = ((uint64_t)(n)) / __base;				\
+	__rem;							\
+ })
+#elif BITS_PER_LONG == 32
+extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
+# define do_div(n,base) ({				\
+	uint32_t __base = (base);			\
+	uint32_t __rem;					\
+	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
+	if (likely(((n) >> 32) == 0)) {			\
+		__rem = (uint32_t)(n) % __base;		\
+		(n) = (uint32_t)(n) / __base;		\
+	} else 						\
+		__rem = __div64_32(&(n), __base);	\
+	__rem;						\
+ })
+#endif /* BITS_PER_LONG */
+
 /* random */
 void get_random_bytes(void *buf, int nbytes);
 
--- nfsim/kernelenv/kernelenv.c	(revision 6316)
+++ nfsim/kernelenv/kernelenv.c	(working copy)
@@ -773,6 +773,15 @@
 	return ret;
 }
 
+int test_and_clear_bit(int nr, unsigned long *addr)
+{
+	/* FIXME: this is not atomic */
+	int ret = test_bit(nr, addr);
+	clear_bit(nr, addr);
+
+	return ret;
+}
+
 int clear_bit(int nr, unsigned long *addr)
 {
 	int     mask, retval;
@@ -786,6 +795,43 @@
         return retval;
 }
 
+/* div64.h */
+
+#if BITS_PER_LONG == 32
+uint32_t __div64_32(uint64_t *n, uint32_t base)
+{
+	uint64_t rem = *n;
+	uint64_t b = base;
+	uint64_t res, d = 1;
+	uint32_t high = rem >> 32;
+
+	/* Reduce the thing a bit first */
+	res = 0;
+	if (high >= base) {
+		high /= base;
+		res = (uint64_t) high << 32;
+		rem -= (uint64_t) (high*base) << 32;
+	}
+
+	while ((int64_t)b > 0 && b < rem) {
+		b = b+b;
+		d = d+d;
+	}
+
+	do {
+		if (rem >= b) {
+			rem -= b;
+			res += d;
+		}
+		b >>= 1;
+		d >>= 1;
+	} while (d);
+
+	*n = res;
+	return rem;
+}
+#endif /* BITS_PER_LONG == 32 */
+
 /* timer */
 LIST_HEAD(__timers);
 LIST_HEAD(__running_timers);
--- nfsim/.links	(revision 6316)
+++ nfsim/.links	(working copy)
@@ -57,6 +57,7 @@
 ./asm/page.h
 ./asm/types.h
 ./asm/byteorder.h
+./asm/div64.h
 ./net/tcp.h
 ./net/checksum.h
 ./net/route.h
@@ -72,3 +73,7 @@
 ./linux/swap.h
 ./linux/list.h
 ./linux/random.h
+./linux/delay.h
+./linux/sctp.h
+./linux/dccp.h
+./linux/kmalloc_sizes.h
--- nfsim/.config.sample	(revision 6316)
+++ nfsim/.config.sample	(working copy)
@@ -14,10 +14,14 @@
 CONFIG_IP_NF_CONNTRACK=m
 CONFIG_IP_NF_CT_ACCT=y
 CONFIG_IP_NF_CONNTRACK_MARK=y
+CONFIG_IP_NF_CONNTRACK_EVENTS=y
+CONFIG_IP_NF_CT_PROTO_SCTP=m
 CONFIG_IP_NF_FTP=m
 CONFIG_IP_NF_IRC=m
+CONFIG_IP_NF_NETBIOS_NS=m
 CONFIG_IP_NF_TFTP=m
 CONFIG_IP_NF_AMANDA=m
+CONFIG_IP_NF_PPTP=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_LIMIT=m
 CONFIG_IP_NF_MATCH_IPRANGE=m
@@ -39,13 +43,16 @@
 CONFIG_IP_NF_MATCH_ADDRTYPE=m
 CONFIG_IP_NF_MATCH_REALM=m
 CONFIG_IP_NF_MATCH_SCTP=m
+CONFIG_IP_NF_MATCH_DCCP=m
 CONFIG_IP_NF_MATCH_COMMENT=m
 CONFIG_IP_NF_MATCH_CONNMARK=m
+CONFIG_IP_NF_MATCH_CONNBYTES=m
 CONFIG_IP_NF_MATCH_HASHLIMIT=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IP_NF_TARGET_LOG=m
 CONFIG_IP_NF_TARGET_TCPMSS=m
+CONFIG_IP_NF_TARGET_NFQUEUE=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_NEEDED=y
@@ -57,12 +64,14 @@
 CONFIG_IP_NF_NAT_FTP=m
 CONFIG_IP_NF_NAT_TFTP=m
 CONFIG_IP_NF_NAT_AMANDA=m
+CONFIG_IP_NF_NAT_PPTP=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_TOS=m
 CONFIG_IP_NF_TARGET_ECN=m
 CONFIG_IP_NF_TARGET_DSCP=m
 CONFIG_IP_NF_TARGET_MARK=m
 CONFIG_IP_NF_TARGET_CLASSIFY=m
+CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IP_NF_TARGET_CONNMARK=m
 CONFIG_IP_NF_RAW=m
 CONFIG_IP_NF_TARGET_NOTRACK=m

--------------000807040409030405090408--
