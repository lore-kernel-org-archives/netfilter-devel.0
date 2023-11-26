Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCbV2hpY"
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D5D10B
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:01:22 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6cb9dd2ab56so2655069b3a.3
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700978482; x=1701583282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mrxD88T9tzl9VNoGMYQ55QYAHhgUi8TAL7tOH0H52c=;
        b=WCbV2hpYDtpSTpAF+ZdP7Zdbsiw+2sOO6YxzKMq8K6c7HembxARsylxX0/qgOulmrj
         5NOUHnspEG4aq/Ay+bAjY+ObmiiXYgBqTMtZpdgve03PbnEaUnE8+FiFFNmzQ/Dx2ygL
         JV4VcPN4jUtp1bLQBosMo7POBXfmcvo1oHPbPqXRmZMU5hpPplbOmWajPHDLVp5fi/Cs
         Bj64VUuGnE3uO+ESzViLyZRUzIejjRLiTRA4eFcy68A+RNTloZH2ZTSeOSrPyu/Gbx9B
         xlDis1g9jGvc+gwbhg851KGf+bGjXoKgVvtHvkgfwQkXrKaAjGj00fJLBOS8uvbp7RM5
         w7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700978482; x=1701583282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5mrxD88T9tzl9VNoGMYQ55QYAHhgUi8TAL7tOH0H52c=;
        b=uLB1COAz9KUd12bbUZ/NYERT6t6rK+Fdi5aSKleAelcTarq5nN1TKa87dKf15dkI/v
         kXe3TmHY9Nopv0VZ9PTTAjIjllb0JHmWB99H3YRYMdfRA/DtA8OmngPYabkAx/a7liP1
         ig1gRAnZvYlvDNOk71q1ox1YbrUoTw6XX4DCXV1JwYY3hxEuZ4nEWg8BWm/yD7rHKGiN
         bE7Vu0sfO5BMsbbV1PQz3F2dnlnkHmORSWi01sxWckPM38OaDObQgdDL+rp89c6CdSMj
         QGgHr8n+WDmD4OW3QZb4pvMdB523zMFYANeh2CpWbRsFVyXiPOs0OhFoWiOneiCkwoef
         as0Q==
X-Gm-Message-State: AOJu0YyeAyjqzpxlQ+4E6o+XYVI/zl/DL9jfBuR0BVyCuz3rpP2nxxz9
	R3fKNYrl/pkOE5isOYo5Vx1x7fFP+Gw=
X-Google-Smtp-Source: AGHT+IEyKPmwHyHwxu0wWBEgnfJ5ILUCCjUMuUhfsdxxYx6YCSZf1lnvsagvgPeuDdN4SLF1Gah91A==
X-Received: by 2002:a05:6a20:5498:b0:18c:1d42:4e12 with SMTP id i24-20020a056a20549800b0018c1d424e12mr5739295pzk.18.1700978481526;
        Sat, 25 Nov 2023 22:01:21 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902d4ca00b001cfacc54674sm3112812plg.106.2023.11.25.22.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 22:01:21 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/1] examples: add an example which uses more functions
Date: Sun, 26 Nov 2023 17:01:13 +1100
Message-Id: <20231126060113.17314-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231126060113.17314-1-duncan_roe@optusnet.com.au>
References: <20231126060113.17314-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nfq6 which started out as a copy of nf-queue and can still print packet
frameworks (that is test 16).

Usage: nfq6 [-a <alt q #>] [-q <queue length>] [-t <test #>]... queue_number
       nfq6 -h
  -a <n>: Alternate queue for test 4
  -h: give this Help and exit
  -q <n>: Set queue length to <n>
  -t <n>: do Test <n>. Tests are:
    0: If packet mark is zero, set it to 0xbeef and give verdict NF_REPEAT
    1: If packet mark is not 0xfaceb00c,
       set packet mark to 0xfaceb00c and give verdict NF_REPEAT.
       If packet mark *is* 0xfaceb00c, accept the packet
    2: Allow ENOBUFS to happen; treat as harmless when it does
    3: Configure NFQA_CFG_F_FAIL_OPEN
    4: Send packets to alternate -a queue
    5: Force on test 4 and specify BYPASS
    6: Exit nfq6 if incoming packet starts "q[:space:]" (e.g. q\n)
    7: Use pktb_setup_raw
    8: Use sendmsg to avoid memcpy after mangling
    9: Replace 1st ASD by F
   10: Replace 1st QWE by RTYUIOP (UDP packets only)
   11: Replace 2nd ASD by G
   12: Replace 2nd QWE by MNBVCXZ (UDP packets only)
   13: Set 16MB kernel socket buffer
   14: Report EINTR if we get it
   15: Log netlink packets with no checksum
   16: Log all netlink packets
   17: Replace 1st ZXC by VBN
   18: Replace 2nd ZXC by VBN
   19: Enable tests 10 & 12 for TCP (not recommended)
   20: Don't configure NFQA_CFG_F_GSO
   21: Send a nested connmark
   22: Turn on NFQA_CFG_F_CONNTRACK
   23: Turn on NFQA_CFG_F_SECCTX

nfq6 can process any combination of IPv4, IPv6, TCP & UDP packets.
Users can find examples of setting and testing packet marks,
mangling packets and sending packets to another queue.
Also the code suggests a method to deal with multiple protocols,
as someone asked about on the netfilter list recently.

v3: - If test 3 is absent and test 20 is present then don't send config message
    - Test 7 breaks from main read loop rather than exit from send_verdict
    - Test 21 sends a nested connmark (like utils/nfqnl_test)
    - Test 22 tries to turn on NFQA_CFG_F_CONNTRACK, using nfq_nlmsg_put2
      and NLM_F_ACK
    - Test 23 tries to turn on NFQA_CFG_F_SECCTX (like utils/nfqnl_test)
      using nfq_nlmsg_put2 and NLM_F_ACK
    - If sending to alternate Q via test 4, test 6 forwards the first
      "q[:space:]" (so the nfq6 -t6 on the second queue will terminate)
    - Use floating point to display read buffer size.
      With integer arithmetic, absent test 13, buffer size showed as 0MB
    - -q option sets queue length (as advised in Main page).
      Response is checked but have not yet seen failure

v2: 2 code changes:
1. Add test of no GSO
2. Accept packets we can't handle (we used to drop them)
    4 cosmetic changes
1. Explain why 'bool' is an enum
2. Rename mangler function pointer to follow same convention as others.
3. Separate function pointers from function prototypes.
4. Add instructions to convert back to single-protocol app.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore           |   1 +
 examples/Makefile.am |   6 +-
 examples/nfq6.c      | 782 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 788 insertions(+), 1 deletion(-)
 create mode 100644 examples/nfq6.c

diff --git a/.gitignore b/.gitignore
index ae3e740..b64534a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -19,6 +19,7 @@ Makefile.in
 /libnetfilter_queue.pc
 
 /examples/nf-queue
+/examples/nfq6
 /doxygen/doxyfile.stamp
 /doxygen/html/
 /doxygen/man/
diff --git a/examples/Makefile.am b/examples/Makefile.am
index 97bb70c..c1bce54 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -1,7 +1,11 @@
 include ${top_srcdir}/Make_global.am
 
-check_PROGRAMS = nf-queue
+check_PROGRAMS = nf-queue nfq6
 
 nf_queue_SOURCES = nf-queue.c
 nf_queue_LDADD = ../src/libnetfilter_queue.la -lmnl
 nf_queue_LDFLAGS = -dynamic
+
+nfq6_SOURCES = nfq6.c
+nfq6_LDADD = ../src/libnetfilter_queue.la -lmnl
+nfq6_LDFLAGS = -dynamic
diff --git a/examples/nfq6.c b/examples/nfq6.c
new file mode 100644
index 0000000..250d6b6
--- /dev/null
+++ b/examples/nfq6.c
@@ -0,0 +1,782 @@
+/* N F Q 6 */
+
+/* System headers */
+
+#define _GNU_SOURCE              /* To get memmem */
+#include <ctype.h>
+#include <errno.h>
+#include <stdio.h>
+#include <assert.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/ip.h>
+#include <arpa/inet.h>
+#include <linux/types.h>
+#include <netinet/ip6.h>
+#include <sys/resource.h>
+#include <libmnl/libmnl.h>
+#include <linux/if_ether.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <libnetfilter_queue/pktbuff.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue_tcp.h>
+#include <libnetfilter_queue/libnetfilter_queue_udp.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv4.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv6.h>
+
+/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+/* Macros */
+
+#define NUM_TESTS 24
+
+/* If bool is a macro, get rid of it */
+#ifdef bool
+#undef bool
+#undef true
+#undef false
+#endif
+
+/* Typedefs */
+
+/* Enable gdb to show Booleans as "true" or "false" */
+typedef enum bool {
+	false,
+	true
+} bool;
+
+/* Static Variables */
+
+static struct mnl_socket *nl;
+/* Largest possible packet payload, plus netlink data overhead: */
+static char nlrxbuf[0xffff + 4096];
+static char nltxbuf[sizeof nlrxbuf];
+static struct pkt_buff *pktb;
+static bool tests[NUM_TESTS] = { false };
+static bool sent_q;
+
+static uint32_t packet_mark;
+static int alternate_queue;
+static bool quit;
+static socklen_t buffersize = 1024 * 1024 * 8;
+static socklen_t socklen = sizeof buffersize, read_size;
+static struct sockaddr_nl snl = {.nl_family = AF_NETLINK };
+
+static char *myP;
+static uint8_t myPROTO, myPreviousPROTO = IPPROTO_IP;
+static uint32_t queuelen;
+
+/* Static prototypes */
+
+static uint8_t ip6_get_proto(const struct nlmsghdr *nlh, struct ip6_hdr *ip6h);
+static void usage(void);
+static int queue_cb(const struct nlmsghdr *nlh, void *data);
+static void nfq_send_verdict(int queue_num, uint32_t id, bool accept);
+
+/* Generic function pointers */
+
+static int (*my_xxp_mangle_ipvy)(struct pkt_buff *, unsigned int, unsigned int,
+		      const char *, unsigned int);
+static void *(*my_xxp_get_hdr)(struct pkt_buff *);
+static void *(*my_xxp_get_payload)(void *, struct pkt_buff *);
+static unsigned int (*my_xxp_get_payload_len)(void *, struct pkt_buff *);
+static void *(*my_ipy_get_hdr)(struct pkt_buff *);
+
+/* **************************** nfq_send_verdict **************************** */
+
+static void nfq_send_verdict(int queue_num, uint32_t id, bool accept)
+{
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	bool done = false;
+
+	nlh = nfq_nlmsg_put(nltxbuf, NFQNL_MSG_VERDICT, queue_num);
+
+	if (!accept) {
+		nfq_nlmsg_verdict_put(nlh, id, NF_DROP);
+		goto send_verdict;
+	}
+
+	if (tests[21]) {
+		nest = mnl_attr_nest_start(nlh, NFQA_CT);
+		mnl_attr_put_u32(nlh, CTA_MARK, htonl(42));
+		mnl_attr_nest_end(nlh, nest);
+	}
+
+	if (tests[0] && !packet_mark) {
+		nfq_nlmsg_verdict_put_mark(nlh, 0xbeef);
+		nfq_nlmsg_verdict_put(nlh, id, NF_REPEAT);
+		done = true;
+	}
+
+	if (tests[1] && !done) {
+		if (packet_mark == 0xfaceb00c) {
+			nfq_nlmsg_verdict_put(nlh, id, NF_ACCEPT);
+		} else {
+			nfq_nlmsg_verdict_put_mark(nlh, 0xfaceb00c);
+			nfq_nlmsg_verdict_put(nlh, id, NF_REPEAT);
+		}
+		done = true;
+	}
+
+	if (tests[4] && !done) {
+		nfq_nlmsg_verdict_put(nlh, id,
+				      NF_QUEUE_NR(alternate_queue) |
+				      (tests[5] ? NF_VERDICT_FLAG_QUEUE_BYPASS
+						: 0));
+		done = true;
+	}
+
+	if (!done)
+		nfq_nlmsg_verdict_put(nlh, id, NF_ACCEPT);
+
+	if (pktb_mangled(pktb) && tests[8]) {
+		struct nlattr *attrib = mnl_nlmsg_get_payload_tail(nlh);
+		size_t len = pktb_len(pktb);
+		struct iovec iov[2];
+		const struct msghdr msg = {
+			.msg_name = &snl,
+			.msg_namelen = sizeof snl,
+			.msg_iov = iov,
+			.msg_iovlen = 2,
+			.msg_control = NULL,
+			.msg_controllen = 0,
+			.msg_flags = 0,
+		};
+
+		attrib->nla_type = NFQA_PAYLOAD;
+		attrib->nla_len = sizeof(struct nlattr) + len;
+		nlh->nlmsg_len += sizeof(struct nlattr);
+		iov[0].iov_base = nlh;
+		iov[0].iov_len = nlh->nlmsg_len;
+		iov[1].iov_base = pktb_data(pktb);
+		iov[1].iov_len = len;
+		nlh->nlmsg_len += len;
+		if (sendmsg(mnl_socket_get_fd(nl), &msg, 0) < 0) {
+			perror("sendmsg");
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		if (pktb_mangled(pktb))
+			nfq_nlmsg_verdict_put_pkt(nlh, pktb_data(pktb),
+						  pktb_len(pktb));
+ send_verdict:
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_sendto");
+			exit(EXIT_FAILURE);
+		}
+	}
+}
+
+/* ******************************** queue_cb ******************************** */
+
+#ifdef GIVE_UP
+#undef GIVE_UP
+#endif
+#define GIVE_UP(x)\
+do {fputs(x, stderr); goto send_verdict; } while (0)
+
+#ifdef GIVE_UP2
+#undef GIVE_UP2
+#endif
+#define GIVE_UP2(x, y)\
+do {fprintf(stderr, x, y); goto send_verdict; } while (0)
+
+static int queue_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfqnl_msg_packet_hdr *ph = NULL;
+	uint32_t id = 0, skbinfo;
+	struct nfgenmsg *nfg;
+	uint8_t *payload;
+	uint8_t *xxp_payload;
+	unsigned int xxp_payload_len;
+	bool accept = true;
+	static struct udphdr *udph;
+	static struct tcphdr *tcph;
+	static struct ip6_hdr *ip6h;
+	static struct iphdr *ip4h;
+	static void **iphp;
+	static void **xxph;
+	char erbuf[4096];
+	bool normal = !tests[16]; /* Don't print record structure */
+	char record_buf[160];
+	int nc = 0;
+	uint16_t plen;
+	uint8_t *p;
+	struct nlattr *attr[NFQA_MAX + 1] = { };
+	char *errfunc;
+	char pb[pktb_head_size()];
+	uint16_t nbo_proto;
+	bool is_IPv4;
+	static bool was_IPv4;
+
+	if (nfq_nlmsg_parse(nlh, attr) < 0) {
+		perror("problems parsing");
+		return MNL_CB_ERROR;
+	}
+
+	/* Most of the lines in this next block are individually annotated in
+	 * nf-queue.c.
+	 */
+	nfg = mnl_nlmsg_get_payload(nlh);
+	if (attr[NFQA_PACKET_HDR] == NULL) {
+		fputs("metaheader not set\n", stderr);
+		return MNL_CB_ERROR;
+	}
+	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
+	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
+	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
+	packet_mark =
+	    attr[NFQA_MARK] ? ntohl(mnl_attr_get_u32(attr[NFQA_MARK])) : 0;
+	skbinfo =
+	    attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) :
+	    0;
+
+	if (attr[NFQA_CAP_LEN]) {
+		uint32_t orig_len = ntohl(mnl_attr_get_u32(attr[NFQA_CAP_LEN]));
+
+		if (orig_len != plen) {
+			nc += snprintf(record_buf, sizeof record_buf, "%s",
+				       "truncated ");
+			normal = false;
+		}
+	}
+
+	if (skbinfo & NFQA_SKB_GSO) {
+		nc += snprintf(record_buf + nc, sizeof record_buf - nc, "%s",
+			       "GSO ");
+		normal = false;
+	}
+
+	id = ntohl(ph->packet_id);
+	nc += snprintf(record_buf + nc, sizeof record_buf - nc, "packet "
+		       "received (id=%u hw=0x%04x hook=%u, payload len %u",
+		       id, nbo_proto = ntohs(ph->hw_protocol), ph->hook, plen);
+
+	/*
+	 * The code from here down to "ip/tcp checksum is not yet valid"
+	 * determines whether this packet is IP verion 4 or 6,
+	 * and within that whether TCP or UDP.
+	 *
+	 * In order to avoid repeated tests on protocol and IP version,
+	 * the code sets up function and data pointers for generic use.
+	 * Most packet buffer functions have a similar enough signature between
+	 * protocols that they can be cast to a common prototype,
+	 * albeit at the cost of type checking since the common prototype
+	 * will contain or return void pointers.
+	 *
+	 * If you are using this program as a template for a single-protocol
+	 * filter, you don't need this but you do need to do the following:
+	 * - (suggestion only) Keep a copy of this file
+	 * - Delete this code chunk, as above
+	 * - Delete function body and declaration of ip6_get_proto
+	 * - Delete declarations of myP, myPROTO, myPreviousPROTO, iphp, xxph,
+	 *                          nbo_proto, is_IPv4 & was_IPv4
+	 * - Delete declaration of either ip4h or ip6h, change "*iphp" to the
+	 *   one you kept e.g. s/\*iphp/ip4h/g
+	 * - Similarly, delete declaration of either tcph or udph, and change
+	 *   "*xxph" to the one you kept.
+	 * - Delete the generic function pointer declarations
+	 * - Edit generic function names (and other code) back to specifics:
+	 *   - "my_"  becomes "nfq_"
+	 *   - "xxp"  becomes "tcp"  or "udp"
+	 *   - "ipvy" becomes "ipv4" or "ipv6"
+	 *   - "ipy"  becomes "ip"   or "ip6" (1 occurrence)
+	 *   E.g. for udp4, my_xxp_mangle_ipvy becomes nfq_udp_mangle_ipv4.
+	 * - Replace myPROTO with IPPROTO_TCP or IPPROTO_UDP
+	 * - You *can* replace "is_IPv4" by "true" or "false" and similarly
+	 *   replace "myP" with "\"TCP\"" or \""UDP\"". Instead, you can edit
+	 *   the individual lines where these are used for a neater end result
+	 *
+	 * The rest is non-generic. From this point on, it's suggested to do
+	 * test compiles to see (from reported errors) where changes are still
+	 * required:
+	 * - Remove assignment of nbo_proto
+	 * - Fix up call to nfq_ip_set_transport_header() or
+	 *   nfq_ip6_set_transport_header(),
+	 *   to leave 2 lines from 7 lines starting "if (true) {"
+	 *
+	 * You should now have a filter program which does all that nfq6 did,
+	 * but only for your chosen protocol. Next you can modify it to do the
+	 * actual job you had in mind.
+	 */
+	is_IPv4 = nbo_proto == ETH_P_IP;
+	if (is_IPv4) {
+		my_ipy_get_hdr = (void *)nfq_ip_get_hdr;
+		iphp = (void **)&ip4h;
+		myPROTO = ((struct iphdr *)payload)->protocol;
+	} else {
+		if (nbo_proto != ETH_P_IPV6)
+			GIVE_UP2("Unrecognised L3 protocol: 0x%04hx\n",
+				 nbo_proto);
+		my_ipy_get_hdr = (void *)nfq_ip6_get_hdr;
+		iphp = (void **)&ip6h;
+		myPROTO = ip6_get_proto(nlh, (struct ip6_hdr *)payload);
+	}
+
+	/* Speedup: skip setting pointers if L3 & L4 protos same as last time
+	 * (usual case)
+	 */
+	if (!(is_IPv4 == was_IPv4 && myPROTO == myPreviousPROTO)) {
+		was_IPv4 = is_IPv4;
+		myPreviousPROTO = myPROTO;
+		if (myPROTO == IPPROTO_TCP) {
+			xxph = (void **)&tcph;
+			my_xxp_mangle_ipvy =
+			    is_IPv4 ? nfq_tcp_mangle_ipv4 : nfq_tcp_mangle_ipv6;
+			myP = "TCP";
+			my_xxp_get_hdr = (void *)nfq_tcp_get_hdr;
+			my_xxp_get_payload =
+			    (void *(*)(void *, struct pkt_buff *))
+			    nfq_tcp_get_payload;
+			my_xxp_get_payload_len =
+			    (unsigned int (*)(void *, struct pkt_buff *))
+			    nfq_tcp_get_payload_len;
+		} else if (myPROTO == IPPROTO_UDP) {
+			xxph = (void **)&udph;
+			my_xxp_mangle_ipvy =
+			    is_IPv4 ? nfq_udp_mangle_ipv4 : nfq_udp_mangle_ipv6;
+			myP = "UDP";
+			my_xxp_get_hdr = (void *)nfq_udp_get_hdr;
+			my_xxp_get_payload =
+			    (void *(*)(void *, struct pkt_buff *))
+			    nfq_udp_get_payload;
+			my_xxp_get_payload_len =
+			    (unsigned int (*)(void *, struct pkt_buff *))
+			    nfq_udp_get_payload_len;
+		} else
+			GIVE_UP2("Unrecognised L4 protocol: %02hhu\n", myPROTO);
+	}
+
+	/*
+	 * ip/tcp checksum is not yet valid, e.g. due to GRO/GSO or IPv6.
+	 * The application should behave as if the checksum is correct.
+	 *
+	 * If this packet is later forwarded/sent out, the checksum will
+	 * be corrected by kernel/hardware.
+	 *
+	 * If we mangle this packet,
+	 * the called function will update the checksum.
+	 */
+	if (skbinfo & NFQA_SKB_CSUMNOTREADY) {
+		nc += snprintf(record_buf + nc, sizeof record_buf - nc,
+			       ", checksum not ready");
+		if (ntohs(ph->hw_protocol) != ETH_P_IPV6 || tests[15])
+			normal = false;
+	}
+	if (!normal)
+		printf("%s)\n", record_buf);
+
+	/* Set up a packet buffer. If copying data, allow 255 bytes extra room;
+	 * otherwise use extra room in the receive buffer.
+	 * AF_INET6 and AF_INET work the same, no need to look at is_IPv4.
+	 */
+#define EXTRA 255
+	if (tests[7]) {
+		pktb = pktb_setup_raw(pb, AF_INET6, payload, plen,
+				      *(size_t *)data);
+		errfunc = "pktb_setup_raw";
+	} else {
+		pktb = pktb_alloc(AF_INET6, payload, plen, EXTRA);
+		errfunc = "pktb_alloc";
+	}
+	if (!pktb) {
+		snprintf(erbuf, sizeof erbuf, "%s. (%s)\n", strerror(errno),
+			 errfunc);
+		GIVE_UP(erbuf);
+	}
+
+	if (!(*iphp = my_ipy_get_hdr(pktb)))
+		GIVE_UP2("Malformed IPv%c\n", is_IPv4 ? '4' : '6');
+
+	if (is_IPv4) {
+		if (nfq_ip_set_transport_header(pktb, *iphp))
+			GIVE_UP("No payload found\n");
+	} else {
+		if (!nfq_ip6_set_transport_header(pktb, *iphp, myPROTO))
+			GIVE_UP2("No %s payload found\n", myP);
+	}
+	if (!(*xxph = my_xxp_get_hdr(pktb)))
+		GIVE_UP2("Packet too short to get %s header\n", myP);
+	if (!(xxp_payload = my_xxp_get_payload(*xxph, pktb)))
+		GIVE_UP2("Packet too short to get %s payload\n", myP);
+	xxp_payload_len = my_xxp_get_payload_len(*xxph, pktb);
+
+	if (tests[6] && xxp_payload_len >= 2 && xxp_payload[0] == 'q' &&
+	    isspace(xxp_payload[1])) {
+		if (tests[4] && !sent_q)
+			sent_q = true;
+		else {
+			accept = false;  /* Drop this packet */
+			quit = true;     /* Exit after giving verdict */
+		}
+	}
+
+	if (tests[9] && (p = memmem(xxp_payload, xxp_payload_len, "ASD", 3))) {
+		my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "F", 1);
+		xxp_payload_len -= 2;
+	}
+
+	if (tests[10] && (myPROTO == IPPROTO_UDP || tests[19]) &&
+	    (p = memmem(xxp_payload, xxp_payload_len, "QWE", 3))) {
+		if (my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "RTYUIOP", 7))
+			xxp_payload_len += 4;
+		else
+			fputs("QWE -> RTYUIOP mangle FAILED\n", stderr);
+	}
+
+	if (tests[11] && (p = memmem(xxp_payload, xxp_payload_len, "ASD", 3))) {
+		my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "G", 1);
+		xxp_payload_len -= 2;
+	}
+
+
+	if (tests[12] && (myPROTO == IPPROTO_UDP || tests[19]) &&
+	    (p = memmem(xxp_payload, xxp_payload_len, "QWE", 3))) {
+		if (my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "MNBVCXZ", 7))
+			xxp_payload_len += 4;
+		else
+			fputs("QWE -> MNBVCXZ mangle FAILED\n", stderr);
+	}
+
+	if (tests[17] && (p = memmem(xxp_payload, xxp_payload_len, "ZXC", 3)))
+		my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "VBN", 3);
+
+	if (tests[18] && (p = memmem(xxp_payload, xxp_payload_len, "ZXC", 3)))
+		my_xxp_mangle_ipvy(pktb, p - xxp_payload, 3, "VBN", 3);
+
+ send_verdict:
+	nfq_send_verdict(ntohs(nfg->res_id), id, accept);
+
+	if (!tests[7])
+		pktb_free(pktb);
+
+	return MNL_CB_OK;
+}
+
+/* ********************************** main ********************************** */
+
+int main(int argc, char *argv[])
+{
+	struct nlmsghdr *nlh;
+	int ret;
+	unsigned int portid, queue_num;
+	int i;
+	size_t sperrume;         /* Spare room */
+	uint32_t config_flags;
+
+	while ((i = getopt(argc, argv, "a:hq:t:")) != -1) {
+		switch (i) {
+		case 'a':
+			alternate_queue = atoi(optarg);
+			if (alternate_queue <= 0 || alternate_queue > 0xffff) {
+				fprintf(stderr,
+					"Alternate queue number %d is out of "
+					"range\n",
+					alternate_queue);
+				exit(EXIT_FAILURE);
+			}
+			break;
+
+		case 'h':
+			usage();
+			return 0;
+
+		case 'q':
+			queuelen = (uint32_t)atoi(optarg);
+			break;
+
+		case 't':
+			ret = atoi(optarg);
+			if (ret < 0 || ret >= NUM_TESTS) {
+				fprintf(stderr, "Test %d is out of range\n",
+					ret);
+				exit(EXIT_FAILURE);
+			}
+			tests[ret] = true;
+			break;
+
+		case '?':
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	if (argc == optind) {
+		fputs("Missing queue number\n", stderr);
+		exit(EXIT_FAILURE);
+	}
+	queue_num = atoi(argv[optind]);
+
+	if (tests[5])
+		tests[4] = true;
+
+	if (tests[4] && !alternate_queue) {
+		fputs("Missing alternate queue number for test 4\n", stderr);
+		exit(EXIT_FAILURE);
+	}
+
+	setlinebuf(stdout);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (tests[13]) {
+		if (setsockopt
+		    (mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+		     &buffersize, sizeof(socklen_t)) == -1)
+			fprintf(stderr, "%s. setsockopt SO_RCVBUFFORCE 0x%x\n",
+				strerror(errno), buffersize);
+	}
+	getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF, &read_size,
+		   &socklen);
+	printf("Read buffer set to 0x%x bytes (%.3gMB)\n", read_size,
+	       read_size / (1024.0 * 1024));
+
+	nlh = nfq_nlmsg_put(nltxbuf, NFQNL_MSG_CONFIG, queue_num);
+	nfq_nlmsg_cfg_put_cmd(nlh, AF_UNSPEC, NFQNL_CFG_CMD_BIND);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nfq_nlmsg_put(nltxbuf, NFQNL_MSG_CONFIG, queue_num);
+	nfq_nlmsg_cfg_put_params(nlh, NFQNL_COPY_PACKET, 0xffff);
+
+	config_flags = htonl((tests[20] ? 0 : NFQA_CFG_F_GSO) |
+			     (tests[3] ? NFQA_CFG_F_FAIL_OPEN : 0));
+	if (config_flags) {
+		mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, config_flags);
+		mnl_attr_put_u32(nlh, NFQA_CFG_MASK, config_flags);
+	}
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	if (tests[23]) {
+		nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num,
+				     NLM_F_ACK);
+		mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(NFQA_CFG_F_SECCTX));
+		mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(NFQA_CFG_F_SECCTX));
+
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_send");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
+		if (ret == -1)
+			perror("configure NFQA_CFG_F_SECCTX");
+	}
+
+	if (tests[22]) {
+		nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num,
+				     NLM_F_ACK);
+		mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS,
+				 htonl(NFQA_CFG_F_CONNTRACK));
+		mnl_attr_put_u32(nlh, NFQA_CFG_MASK,
+				 htonl(NFQA_CFG_F_CONNTRACK));
+
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_send");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
+		if (ret == -1)
+			perror("configure NFQA_CFG_F_CONNTRACK");
+	}
+
+	if (queuelen) {
+		nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num,
+				     NLM_F_ACK);
+		mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queuelen));
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_send");
+			exit(EXIT_FAILURE);
+		}
+		ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+		ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
+		if (ret == -1)
+			fprintf(stderr, "Set queue size %u: %s\n", queuelen,
+				strerror(errno));
+	}
+
+	/* ENOBUFS is signalled to userspace when packets were lost
+	 * on kernel side.  In most cases, userspace isn't interested
+	 * in this information, so turn it off.
+	 */
+	if (!tests[2]) {
+		ret = 1;
+		mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret,
+				      sizeof(int));
+	}
+
+	for (;;) {
+		ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			if (errno == ENOBUFS)
+				continue;
+			exit(EXIT_FAILURE);
+		}
+		assert(((struct nlmsghdr *)nlrxbuf)->nlmsg_len == ret);
+		sperrume = sizeof nlrxbuf - ret;
+
+		ret = mnl_cb_run(nlrxbuf, ret, 0, portid, queue_cb, &sperrume);
+		if (ret < 0 && (errno != EINTR || tests[14])) {
+			perror("mnl_cb_run");
+			if (errno != EINTR)
+				exit(EXIT_FAILURE);
+		}
+		if (quit)
+			break;
+	}
+
+	mnl_socket_close(nl);
+
+	return 0;
+}
+
+/* ********************************** usage ********************************* */
+
+static void usage(void)
+{
+/* N.B. Trailing empty comments are there to stop gnu indent joining lines */
+	puts("\nUsage: nfq6 [-a <alt q #>] "    /*  */
+	     "[-q <queue length>] "             /*  */
+	     "[-t <test #>]... queue_number\n"  /*  */
+	     "       nfq6 -h\n"                 /*  */
+	     "  -a <n>: Alternate queue for test 4\n"  /*  */
+	     "  -h: give this Help and exit\n"         /*  */
+	     "  -q <n>: Set queue length to <n>\n"     /*  */
+	     "  -t <n>: do Test <n>. Tests are:\n"     /*  */
+	     "    0: If packet mark is zero, set it to 0xbeef and give verdict "
+	     "NF_REPEAT\n"                                    /*  */
+	     "    1: If packet mark is not 0xfaceb00c,\n"     /*  */
+	     "       set packet mark to 0xfaceb00c and give " /*  */
+	     "verdict NF_REPEAT.\n"                           /*  */
+	     "       If packet mark *is* 0xfaceb00c, accept the packet\n"
+	     "    2: Allow ENOBUFS to happen; treat as harmless when it does\n"
+	     "    3: Configure NFQA_CFG_F_FAIL_OPEN\n"     /*  */
+	     "    4: Send packets to alternate -a queue\n" /*  */
+	     "    5: Force on test 4 and specify BYPASS\n" /*  */
+	     "    6: Exit nfq6 if incoming packet starts \"q[:space:]\""
+	     " (e.g. q\\n)\n"                /*  */
+	     "    7: Use pktb_setup_raw\n"   /*  */
+	     "    8: Use sendmsg to avoid memcpy after mangling\n" /*  */
+	     "    9: Replace 1st ASD by F\n" /*  */
+	     "   10: Replace 1st QWE by RTYUIOP (UDP packets only)\n"
+	     "   11: Replace 2nd ASD by G\n" /*  */
+	     "   12: Replace 2nd QWE by MNBVCXZ (UDP packets only)\n"
+	     "   13: Set 16MB kernel socket buffer\n"  /*  */
+	     "   14: Report EINTR if we get it\n"      /*  */
+	     "   15: Log netlink packets with no checksum\n"
+	     "   16: Log all netlink packets\n"        /*  */
+	     "   17: Replace 1st ZXC by VBN\n"         /*  */
+	     "   18: Replace 2nd ZXC by VBN\n"         /*  */
+	     "   19: Enable tests 10 & 12 for TCP (not recommended)\n"
+	     "   20: Don't configure NFQA_CFG_F_GSO\n" /*  */
+	     "   21: Send a nested connmark\n"         /*  */
+	     "   22: Turn on NFQA_CFG_F_CONNTRACK\n"   /*  */
+	     "   23: Turn on NFQA_CFG_F_SECCTX\n"      /*  */
+	    );
+}
+
+/* ****************************** ip6_get_proto ***************************** */
+
+static uint8_t ip6_get_proto(const struct nlmsghdr *nlh, struct ip6_hdr *ip6h)
+{
+	/* This code is a copy of nfq_ip6_set_transport_header(),
+	 * modified to return the upper-layer protocol instead.
+	 */
+
+	uint8_t nexthdr = ip6h->ip6_nxt;
+	uint8_t *cur = (uint8_t *)ip6h + sizeof(struct ip6_hdr);
+	const uint8_t *pkt_tail = (const uint8_t *)nlh + nlh->nlmsg_len;
+
+	/* Speedup: save 4 compares in the usual case (no extension headers)
+	 */
+	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP)
+		return nexthdr;  /* Ugly but it saves an indent level */
+
+	while (nexthdr == IPPROTO_HOPOPTS ||
+	       nexthdr == IPPROTO_ROUTING ||
+	       nexthdr == IPPROTO_FRAGMENT ||
+	       nexthdr == IPPROTO_AH ||
+	       nexthdr == IPPROTO_NONE ||
+	       nexthdr == IPPROTO_DSTOPTS) {
+		struct ip6_ext *ip6_ext;
+		uint32_t hdrlen;
+
+		/* No more extensions, we're done. */
+		if (nexthdr == IPPROTO_NONE)
+			break;
+		/* No room for extension, bad packet. */
+		if (pkt_tail - cur < sizeof(struct ip6_ext)) {
+			nexthdr = IPPROTO_NONE;
+			break;
+		}
+		ip6_ext = (struct ip6_ext *)cur;
+
+		if (nexthdr == IPPROTO_FRAGMENT) {
+
+			/* No room for full fragment header, bad packet. */
+			if (pkt_tail - cur < sizeof(struct ip6_frag)) {
+				nexthdr = IPPROTO_NONE;
+				break;
+			}
+
+			/* Fragment offset is only 13 bits long. */
+			if (ntohs(((struct ip6_frag *)cur)->ip6f_offlg) &
+			    ~0x7) {
+
+			/* Not the first fragment,
+			 * it does not contain any headers.
+			 */
+				nexthdr = IPPROTO_NONE;
+				break;
+			}
+			hdrlen = sizeof(struct ip6_frag);
+		} else if (nexthdr == IPPROTO_AH)
+			hdrlen = (ip6_ext->ip6e_len + 2) << 2;
+		else
+			hdrlen = (ip6_ext->ip6e_len + 1) << 3;
+
+		nexthdr = ip6_ext->ip6e_nxt;
+		cur += hdrlen;
+	}
+	return nexthdr;
+}
-- 
2.35.8

