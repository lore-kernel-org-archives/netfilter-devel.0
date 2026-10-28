Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.252.153.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214757;
	b=XFLJEz3IbGjJVTLlrf5n8b0qNXW+V1BDqEdlC878Gi0xjG8zXz8ua37neCpUjvjZ0ZFr
	 UctVZSFYgC685TXHGuzxdEjz0K8309af4UYT77DG8S2lGEgi1NR/0Kz1fx1R9zD+7HecR
	 Nfi+vRz1/p77HIngO3NuY83R1NOS7tOM0MaI0SHNjmm/WUDrCPjMm7ckLFBy/7oLZd1xl
	 Ap0zTwlGtyx1GK8vW7NOYXSROntmNaNiv6VGhTlaaYBDns/ph+BKK2WYLiA2PkHCduDMN
	 uK2ejbzGxFamnfYCAu9esTMxa55TtgHbU1atDcCNwr24R/rmtmPGtCftdt2xWk1OFUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214757;
	h=DMARC-Filter:DKIM-Signature:Received:X-Riseup-User-ID:Received:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=6BlKa644AtGIyyq4t7wRweFOIWKtQA+SS/IUVkSAzmM=;
	b=ZIY6Hnd+Gu1yU9d2WqufK0I8gRWs9PFhshzQSkbzTssmWXf1okri4bWrr7uxWJ7TSxsH
	 lsfOOtTVHg17pkORW9mMW3lftX+Qa53E5R2N5426IhbAspYhQm2seb0L+nGdHl94kmttO
	 oQv6GVhRqB4g9kZ/isg7bCmt3jjDqh2ZQTUU3ZMuepEWt99VEen1TE8wWzUJphZg+KSD3
	 kmkZKZ/38Cp+ddCSoMlDoIC+90iaXQ0Z0BEhPJyElEusF2qyWp71mUcF+TO/JT0YQWtqa
	 kCnC+1MI7mqm/FwmYtEC7CDRUVoC2sOKbfcF1XWm6f5SXef6vIoBd8k4WDCbK/eYoVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=riseup.net;
	spf=pass smtp.mailfrom=riseup.net;
	dkim=pass header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=Xsk8lZK+;
	arc=none smtp.remote-ip=198.252.153.129
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB19606A323;
	Wed, 28 Oct 2026 19:12:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB19606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=Xsk8lZK+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1793214749; bh=6BlKa644AtGIyyq4t7wRweFOIWKtQA+SS/IUVkSAzmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xsk8lZK+5mXBr6km6l8KVebWLEGwR8THZMfW0KlUWpLqWglyV1215EYU/sMk5n30K
	 h7Rl9NjalF6p+VEfpzQ+g6Y+tjkO80Bu9sA5zLwOPjivl2TC15KqdLPFZ4y0FmzbwB
	 2RyCj+5NCu2CCyebw4cnuxysJK84/6f3CvwhCE3A=
Received: from fews04-sea.riseup.net (fews04-sea-pn.riseup.net [10.0.1.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4jFH706DmNzDqWP;
	Wed, 28 Oct 2026 19:12:28 +0000 (UTC)
X-Riseup-User-ID: 0DF596A25A29F60A117E715EF26DCF1894AF9554ECFEEB1A1D6BE8DD06F5D053
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews04-sea.riseup.net (Postfix) with ESMTPSA id 4jFH6n6mBPz5vbL;
	Wed, 28 Oct 2026 19:12:17 +0000 (UTC)
From: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>
To: Alexei Starovoitov <ast@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>,
	bpf@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	coreteam@netfilter.org,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Jeff Layton <jlayton@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Joe Damato <joe@dama.to>,
	John Fastabend <john.fastabend@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Li RongQing <lirongqing@baidu.com>,
	linux-kselftest@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Qi Tang <tpluszz77@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Willem de Bruijn <willemb@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net v3 3/3] selftests: net: add tests for saddr, anycast and loopback subnets
Date: Wed, 28 Oct 2026 20:10:57 +0100
Message-ID: <20261028191103.623156-4-ihuguet@riseup.net>
In-Reply-To: <20261028191103.623156-1-ihuguet@riseup.net>
References: <20261028191103.623156-1-ihuguet@riseup.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add selftests covering the "check source address in outgoing packets"
behaviour covered by the previous patch. Add tests for IPv4 too, because
although this is not a new behaviour, there were no selftests for it.

Also, add selftests covering anycast and loopback subnets. During the
development of the previous patch these features were impacted and
detected at review time. Add selftests for them to avoid new
regressions.

The *_table tests in loopback_subnet.sh are marked as xfail because
currently loopback subnets are only working fine in the local table.
As this is unrelated to the current main patch, I plan to address it in
a different patch series.

Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   4 +
 tools/testing/selftests/net/ip_saddr.c        | 557 +++++++++++++++++
 tools/testing/selftests/net/ip_saddr.sh       | 575 ++++++++++++++++++
 tools/testing/selftests/net/ipv6_anycast.sh   |  68 +++
 .../testing/selftests/net/loopback_subnet.sh  | 135 ++++
 6 files changed, 1340 insertions(+)
 create mode 100644 tools/testing/selftests/net/ip_saddr.c
 create mode 100755 tools/testing/selftests/net/ip_saddr.sh
 create mode 100755 tools/testing/selftests/net/ipv6_anycast.sh
 create mode 100755 tools/testing/selftests/net/loopback_subnet.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 21412510ac26..eceaac7cb8cf 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -13,6 +13,7 @@ io_uring_zerocopy_tx
 ioam6_parser
 ip_defrag
 ip_local_port_range
+ip_saddr
 ipsec
 ipv6_flowlabel
 ipv6_flowlabel_mgr
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index df215e1a6262..08d0fae1778d 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -56,6 +56,8 @@ TEST_PROGS := \
 	ip6_tunnel.sh \
 	ip_defrag.sh \
 	ip_local_port_range.sh \
+	ip_saddr.sh \
+	ipv6_anycast.sh \
 	ipv6_flowlabel.sh \
 	ipv6_force_forwarding.sh \
 	ipv6_route_update_soft_lockup.sh \
@@ -63,6 +65,7 @@ TEST_PROGS := \
 	l2_tos_ttl_inherit.sh \
 	l2tp.sh \
 	link_netns.py \
+	loopback_subnet.sh \
 	lwt_dst_cache_ref_loop.sh \
 	macvlan_mcast_shared_mac.sh \
 	msg_zerocopy.sh \
@@ -153,6 +156,7 @@ TEST_GEN_FILES := \
 	ioam6_parser \
 	ip_defrag \
 	ip_local_port_range \
+	ip_saddr \
 	ipsec \
 	ipv6_flowlabel \
 	msg_zerocopy \
diff --git a/tools/testing/selftests/net/ip_saddr.c b/tools/testing/selftests/net/ip_saddr.c
new file mode 100644
index 000000000000..ed9b0a360b28
--- /dev/null
+++ b/tools/testing/selftests/net/ip_saddr.c
@@ -0,0 +1,557 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+
+#define MESSAGE "Hello!\n"
+
+union addr46 {
+	struct in_addr addr4;
+	struct in6_addr addr6;
+};
+
+/* -----------------------------------------------
+ * Functions for the TCP and UDP tests:
+ * - Create a STREAM or DGRAM socket, optionally with the TRANSPARENT sockopt
+ * - Act only as server, the companion script will act as client
+ * - Wait for a TCP connection or UDP datagram from the client
+ * - Wait until the client sends a sync message (via FIFO file) to continue
+ *   (the client may need to do some actions before the next step)
+ * - Send a message to the client
+ * ------------------------------------------------
+ */
+static int create_sock_ipv6(int proto, int port, bool transparent)
+{
+	struct sockaddr_in6 address;
+	int sk, opt;
+
+	sk = socket(AF_INET6, proto, 0);
+	if (sk < 0) {
+		perror("Failed to create socket");
+		exit(EXIT_FAILURE);
+	}
+
+	opt = 1;
+	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
+		perror("Failed to set SO_REUSEADDR");
+		exit(EXIT_FAILURE);
+	}
+	opt = 0;
+	if (setsockopt(sk, IPPROTO_IPV6, IPV6_V6ONLY, &opt, sizeof(opt))) {
+		perror("Failed to set IPV6_V6ONLY");
+		exit(EXIT_FAILURE);
+	}
+	opt = 1;
+	if (setsockopt(sk, IPPROTO_IPV6, IPV6_RECVPKTINFO, &opt, sizeof(opt))) {
+		perror("Failed to set IPV6_PKTINFO");
+		exit(EXIT_FAILURE);
+	}
+	opt = 1;
+	if (transparent &&
+	    setsockopt(sk, IPPROTO_IPV6, IPV6_TRANSPARENT, &opt, sizeof(opt))) {
+		perror("Failed to set IPV6_TRANSPARENT");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&address, 0, sizeof(address));
+	address.sin6_family = AF_INET6;
+	address.sin6_addr = in6addr_any;
+	address.sin6_port = htons(port);
+
+	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
+		perror("Failed to bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return sk;
+}
+
+static int create_sock_ipv4(int proto, int port, bool transparent)
+{
+	struct sockaddr_in address;
+	int sk, opt;
+
+	sk = socket(AF_INET, proto, 0);
+	if (sk < 0) {
+		perror("Failed to create socket");
+		exit(EXIT_FAILURE);
+	}
+
+	opt = 1;
+	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
+		perror("Failed to set SO_REUSEADDR");
+		exit(EXIT_FAILURE);
+	}
+	opt = 1;
+	if (setsockopt(sk, IPPROTO_IP, IP_PKTINFO, &opt, sizeof(opt))) {
+		perror("Failed to set IP_PKTINFO");
+		exit(EXIT_FAILURE);
+	}
+	opt = 1;
+	if (transparent &&
+	    setsockopt(sk, IPPROTO_IP, IP_TRANSPARENT, &opt, sizeof(opt))) {
+		perror("Failed to set IP_TRANSPARENT");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&address, 0, sizeof(address));
+	address.sin_family = AF_INET;
+	address.sin_addr.s_addr = htonl(INADDR_ANY);
+	address.sin_port = htons(port);
+
+	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
+		perror("Failed to bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return sk;
+}
+
+static void sync_wait(int sync_fd)
+{
+	uint8_t buff[256];
+
+	if (sync_fd && read(sync_fd, buff, sizeof(buff) - 1) < 0) {
+		perror("Failed to read from sync file");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void wait_and_send_tcp(int sk, int sync_fd)
+{
+	int con;
+
+	if (listen(sk, 5) < 0) {
+		perror("Failed to listen");
+		exit(EXIT_FAILURE);
+	}
+	con = accept(sk, NULL, NULL);
+	if (con < 0) {
+		perror("Failed to accept");
+		exit(EXIT_FAILURE);
+	}
+
+	sync_wait(sync_fd);
+
+	if (send(con, MESSAGE, strlen(MESSAGE), 0) < 0) {
+		perror("Failed to send");
+		exit(EXIT_FAILURE);
+	}
+
+	close(con);
+}
+
+static void maybe_chg_saddr_dport(char *data, struct msghdr *msg)
+{
+	struct in6_addr local_addr6;
+	struct in_addr local_addr4;
+	int cmsg_level, cmsg_type;
+	struct cmsghdr *cmsg;
+	size_t datalen;
+	char *portstr;
+
+	portstr = strchr(data, ' ');
+	if (!portstr)
+		return;
+
+	// remove trailing LF and split into 2 strs
+	datalen = strlen(data);
+	if (datalen > 0 && data[datalen - 1] == '\n')
+		data[datalen - 1] = '\0';
+	*(portstr++) = '\0';
+
+	// get the new saddr and dport
+	if (inet_pton(AF_INET, data, &local_addr4) == 1) {
+		struct sockaddr_in *peer_addr;
+
+		peer_addr = (struct sockaddr_in *)msg->msg_name;
+		peer_addr->sin_port = htons(atoi(portstr));
+		cmsg_level = IPPROTO_IP;
+		cmsg_type = IP_PKTINFO;
+	} else if (inet_pton(AF_INET6, data, &local_addr6) == 1) {
+		struct sockaddr_in6 *peer_addr;
+
+		peer_addr = (struct sockaddr_in6 *)msg->msg_name;
+		peer_addr->sin6_port = htons(atoi(portstr));
+		cmsg_level = IPPROTO_IPV6;
+		cmsg_type = IPV6_PKTINFO;
+	} else {
+		return;
+	}
+
+	for (cmsg = CMSG_FIRSTHDR(msg); cmsg; cmsg = CMSG_NXTHDR(msg, cmsg)) {
+		if (cmsg->cmsg_level != cmsg_level ||
+		    cmsg->cmsg_type != cmsg_type) {
+			continue;
+		}
+		if (cmsg->cmsg_level == IPPROTO_IP &&
+		    cmsg->cmsg_type == IP_PKTINFO) {
+			struct in_pktinfo *pi;
+
+			pi = (struct in_pktinfo *)CMSG_DATA(cmsg);
+			pi->ipi_addr = local_addr4;
+			pi->ipi_spec_dst = local_addr4;
+			break;
+		}
+		if (cmsg->cmsg_level == IPPROTO_IPV6 &&
+		    cmsg->cmsg_type == IPV6_PKTINFO) {
+			struct in6_pktinfo *pi;
+
+			pi = (struct in6_pktinfo *)CMSG_DATA(cmsg);
+			pi->ipi6_addr = local_addr6;
+			break;
+		}
+	}
+}
+
+static void wait_and_send_udp(int sk, int sync_fd)
+{
+	uint8_t data_buff[256], ctrl_buff[256];
+	ssize_t nbytes;
+	union {
+		struct sockaddr_in addr4;
+		struct sockaddr_in6 addr6;
+	} peer_addr;
+	struct iovec iov = {
+		.iov_base = data_buff,
+		.iov_len = sizeof(data_buff) - 1,
+	};
+	struct msghdr msg = {
+		.msg_name = &peer_addr,
+		.msg_namelen = sizeof(peer_addr),
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = ctrl_buff,
+		.msg_controllen = sizeof(ctrl_buff),
+	};
+
+	nbytes = recvmsg(sk, &msg, 0);
+	if (nbytes < 0) {
+		perror("Failed to receive");
+		exit(EXIT_FAILURE);
+	}
+
+	// The "test_foreign_addr_*" tests needs us to reply to the same address
+	// but different port, and also from a different local address. The new
+	// saddr and dport are received in the previous message with the format
+	// "new_source_address new_dest_port"
+	data_buff[nbytes] = '\0';
+	maybe_chg_saddr_dport((char *)data_buff, &msg);
+
+	sync_wait(sync_fd);
+
+	// Change the data, but keep the same ancillary data so that we use the
+	// same addresses as we received.
+	iov.iov_base = MESSAGE;
+	iov.iov_len = strlen(MESSAGE);
+
+	if (sendmsg(sk, &msg, 0) < 0) {
+		/* Contrary to the TCP case, as UDP doesn't keep a "connection",
+		 * the test cases where the source address is not configured in
+		 * the host return an error here. It is expected, ignore it.
+		 */
+	}
+}
+
+/* -----------------------------------------------
+ * Functions for the HDRINCL tests:
+ * - Create a RAW socket with the HDRINCL sockopt
+ * - If acting as server, wait for incoming data and print it
+ * - If acting as client, craft a packet with the saddr and daddr from the args
+ *   and send it.
+ * ------------------------------------------------
+ */
+static int create_sock_ipv4_hdrincl(void)
+{
+	struct sockaddr_in address;
+	int sk, opt;
+
+	sk = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
+	if (sk < 0) {
+		perror("Failed to create socket");
+		exit(EXIT_FAILURE);
+	}
+
+	opt = 1;
+	if (setsockopt(sk, IPPROTO_IP, IP_HDRINCL, &opt, sizeof(opt)) < 0) {
+		perror("Failed to set IP_HDRINCL");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&address, 0, sizeof(address));
+	address.sin_family = AF_INET;
+	address.sin_addr.s_addr = htonl(INADDR_ANY);
+
+	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
+		perror("Failed to bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return sk;
+}
+
+static int create_sock_ipv6_hdrincl(void)
+{
+	struct sockaddr_in6 address;
+	int sk, opt;
+
+	sk = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
+	if (sk < 0) {
+		perror("Failed to create socket");
+		exit(EXIT_FAILURE);
+	}
+
+	opt = 1;
+	if (setsockopt(sk, IPPROTO_IPV6, IPV6_HDRINCL, &opt, sizeof(opt)) < 0) {
+		perror("Failed to set IPV6_HDRINCL");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&address, 0, sizeof(address));
+	address.sin6_family = AF_INET6;
+	address.sin6_addr = in6addr_any;
+
+	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
+		perror("Failed to bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return sk;
+}
+
+size_t create_packet_ipv6(uint8_t *buff,
+			  struct in6_addr saddr,
+			  struct in6_addr daddr)
+{
+	struct ip6_hdr *iph = (struct ip6_hdr *)buff;
+	uint8_t *data = (uint8_t *)(buff + sizeof(struct ip6_hdr));
+
+	// header
+	iph->ip6_flow = htonl((6 << 28) | (0 << 20) | 0);
+	iph->ip6_plen = htons(sizeof(MESSAGE));
+	iph->ip6_nxt = IPPROTO_RAW;
+	iph->ip6_hops = 64;
+	iph->ip6_src = saddr;
+	iph->ip6_dst = daddr;
+
+	// data
+	memcpy(data, MESSAGE, sizeof(MESSAGE));
+
+	return sizeof(struct ip6_hdr) + sizeof(MESSAGE);
+}
+
+size_t create_packet_ipv4(uint8_t *buff,
+			  struct in_addr saddr,
+			  struct in_addr daddr)
+{
+	struct ip *iph = (struct ip *)buff;
+	uint8_t *data = (uint8_t *)(buff + sizeof(struct ip));
+
+	// header
+	iph->ip_hl = 5; // Header length (5 * 4 bytes = 20 bytes)
+	iph->ip_v = 4;  // IPv4
+	iph->ip_tos = 0;
+	iph->ip_len = htons(sizeof(struct ip) + sizeof(MESSAGE));
+	iph->ip_id = htons(12345);
+	iph->ip_off = 0;
+	iph->ip_ttl = 64;
+	iph->ip_p = IPPROTO_RAW;
+	iph->ip_src = saddr;
+	iph->ip_dst = daddr;
+	iph->ip_sum = 0;
+
+	// data
+	memcpy(data, MESSAGE, sizeof(MESSAGE));
+
+	return sizeof(struct ip) + sizeof(MESSAGE);
+}
+
+static void send_or_receive_hdrincl(int sk,
+				    bool is_ipv6,
+				    bool send_msg,
+				    union addr46 *local_addr,
+				    union addr46 *peer_addr)
+{
+	uint8_t buff[256];
+	ssize_t msglen;
+
+	if (send_msg && is_ipv6) {
+		struct sockaddr_in6 dest;
+
+		memset(&dest, 0, sizeof(dest));
+		dest.sin6_family = AF_INET6;
+		dest.sin6_addr = peer_addr->addr6;
+		msglen = create_packet_ipv6(buff,
+					    local_addr->addr6,
+					    peer_addr->addr6);
+		if (sendto(sk, buff, msglen, 0, &dest, sizeof(dest)) < 0) {
+			perror("Failed to send");
+			exit(EXIT_FAILURE);
+		}
+	} else if (send_msg && !is_ipv6) {
+		struct sockaddr_in dest;
+
+		memset(&dest, 0, sizeof(dest));
+		dest.sin_family = AF_INET;
+		dest.sin_addr = peer_addr->addr4;
+		msglen = create_packet_ipv4(buff,
+					    local_addr->addr4,
+					    peer_addr->addr4);
+		if (sendto(sk, buff, msglen, 0, &dest, sizeof(dest)) < 0) {
+			perror("Failed to send");
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		msglen = read(sk, buff, sizeof(buff) - 1);
+		if (msglen < 0) {
+			perror("Failed to read");
+			exit(EXIT_FAILURE);
+		}
+		buff[msglen] = '\0';
+
+		// output the received message
+		if (is_ipv6)
+			printf("%s", buff);
+		else if (msglen >= sizeof(struct ip))
+			printf("%s", buff + sizeof(struct ip));
+	}
+}
+
+/* -----------------------------------------------
+ * Arguments parsing
+ * ------------------------------------------------
+ */
+static void parse_gral_args(int argc,
+			    char *argv[],
+			    bool *out_is_ipv6,
+			    int *out_proto)
+{
+	if (argc < 3) {
+		fprintf(stderr, "Expected more arguments");
+		exit(EXIT_FAILURE);
+	}
+
+	if (strncmp(argv[1], "ipv4", strlen("ipv4")) == 0) {
+		*out_is_ipv6 = false;
+	} else if (strncmp(argv[1], "ipv6", strlen("ipv6")) == 0) {
+		*out_is_ipv6 = true;
+	} else {
+		fprintf(stderr, "Valid value for arg1: ipv4, ipv6");
+		exit(EXIT_FAILURE);
+	}
+
+	if (strncmp(argv[2], "tcp", strlen("tcp")) == 0) {
+		*out_proto = SOCK_STREAM;
+	} else if (strncmp(argv[2], "udp", strlen("udp")) == 0) {
+		*out_proto = SOCK_DGRAM;
+	} else if (strncmp(argv[2], "raw", strlen("raw")) == 0) {
+		*out_proto = SOCK_RAW;
+	} else {
+		fprintf(stderr, "Valid value for arg2: tcp, udp, raw");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void parse_tcp_udp_args(int argc,
+			       char *argv[],
+			       int *out_port,
+			       bool *out_transparent,
+			       int *out_sync_fd)
+{
+	if (argc < 5) {
+		fprintf(stderr, "Expected more arguments");
+		exit(EXIT_FAILURE);
+	}
+
+	*out_port = atoi(argv[3]);
+
+	if (strncmp(argv[4], "transparent", strlen("transparent")) == 0) {
+		*out_transparent = true;
+	} else if (strncmp(argv[4], "normal", strlen("normal")) == 0) {
+		*out_transparent = false;
+	} else {
+		fprintf(stderr, "Valid values for arg3: normal, transparent");
+		exit(EXIT_FAILURE);
+	}
+
+	*out_sync_fd = 0;
+	if (argc > 5 && strlen(argv[5]) > 0) {
+		*out_sync_fd = open(argv[5], O_RDWR);
+		if (*out_sync_fd < 0) {
+			perror("Failed to open sync file");
+			exit(EXIT_FAILURE);
+		}
+	}
+}
+
+static void parse_hdrincl_args(int argc,
+			       char *argv[],
+			       bool is_ipv6,
+			       bool *out_send_msg,
+			       union addr46 *out_local_addr,
+			       union addr46 *out_peer_addr)
+{
+	if (argc == 4) {
+		fprintf(stderr, "Expected more arguments");
+		exit(EXIT_FAILURE);
+	}
+
+	*out_send_msg = argc < 4 ? false : true;
+	if (*out_send_msg && is_ipv6) {
+		inet_pton(AF_INET6, argv[3], out_local_addr);
+		inet_pton(AF_INET6, argv[4], out_peer_addr);
+	} else if (*out_send_msg && !is_ipv6) {
+		inet_pton(AF_INET, argv[3], out_local_addr);
+		inet_pton(AF_INET, argv[4], out_peer_addr);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	union addr46 local_addr, peer_addr;
+	bool is_ipv6, transparent, send_msg;
+	int proto, port;
+	int sync_fd;
+	int sk;
+
+	parse_gral_args(argc, argv, &is_ipv6, &proto);
+	if (proto != SOCK_RAW)
+		parse_tcp_udp_args(argc, argv, &port, &transparent, &sync_fd);
+	else
+		parse_hdrincl_args(argc,
+				   argv,
+				   is_ipv6,
+				   &send_msg,
+				   &local_addr,
+				   &peer_addr);
+
+	if (is_ipv6 && proto != SOCK_RAW)
+		sk = create_sock_ipv6(proto, port, transparent);
+	else if (!is_ipv6 && proto != SOCK_RAW)
+		sk = create_sock_ipv4(proto, port, transparent);
+	else if (is_ipv6 && proto == SOCK_RAW)
+		sk = create_sock_ipv6_hdrincl();
+	else // !is_ipv6 && proto == SOCK_RAW
+		sk = create_sock_ipv4_hdrincl();
+
+	if (proto == SOCK_STREAM)
+		wait_and_send_tcp(sk, sync_fd);
+	else if (proto == SOCK_DGRAM)
+		wait_and_send_udp(sk, sync_fd);
+	else // SOCK_RAW
+		send_or_receive_hdrincl(sk,
+					is_ipv6,
+					send_msg,
+					&local_addr,
+					&peer_addr);
+
+	close(sk);
+	return 0;
+}
diff --git a/tools/testing/selftests/net/ip_saddr.sh b/tools/testing/selftests/net/ip_saddr.sh
new file mode 100755
index 000000000000..9345b743afd0
--- /dev/null
+++ b/tools/testing/selftests/net/ip_saddr.sh
@@ -0,0 +1,575 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test the correct behaviour with outgoing packets regarding the source address.
+# RFC 4862: an invalid address MUST NOT be used as the source address of
+# outbound packets.
+# However, with the TRANSPARENT and HDRINCL sockopts, any saddr is allowed.
+#
+# There are 2 kind of tests, all server & client in different namespaces:
+# - TCP / UDP:
+#    1. The client establish a connection with the server
+#    2. The server address is removed/invalidated
+#    3. The server tries to send a message to the client
+# - HDRINCL (using raw socket):
+#    1. The server start listening
+#    2. The client address is removed/invalidated
+#    3. The client tries to send a message to the server
+#
+# The expectation is that the message is not received by the peer, except when
+# using TRANSPARENT or HDRINCL where we expect to receive it.
+#
+# Test the following permutations:
+# - IPv4 / IPv6
+# - TCP / UDP / raw-with-HDRINCL
+# - For TCP & UDP: normal socket / TRANSPARENT socket
+# - One of the following address invalidation actions:
+#     - Don't invalidate (keep the address configured). In this case we expect
+#       to always receive the message.
+#     - Manually delete the address.
+#     - Leave the address to expire its valid_lft.
+#     - Use a foreign address (an address that it's not configured on the host).
+#       This one can't be tested with TCP, the connection cannot be established.
+#
+# Important: we have a secondary address on the same network configured all the
+# time in both the client and the server. We do this because, otherwise, the
+# kernel doesn't know a route when we invalidate/remove the main address. If it
+# failed because of this, we wouldn't be testing the validation of the source
+# address, which is this file's goal
+
+# shellcheck disable=SC2329
+
+ALL_TESTS="
+        test_keep_addr_ipv4_tcp_normal
+        test_keep_addr_ipv4_udp_normal
+        test_keep_addr_ipv6_tcp_normal
+        test_keep_addr_ipv6_udp_normal
+        test_keep_addr_ipv4_tcp_transparent
+        test_keep_addr_ipv4_udp_transparent
+        test_keep_addr_ipv6_tcp_transparent
+        test_keep_addr_ipv6_udp_transparent
+        test_keep_addr_ipv4_hdrincl
+        test_keep_addr_ipv6_hdrincl
+        test_remove_addr_ipv4_tcp_normal
+        test_remove_addr_ipv4_udp_normal
+        test_remove_addr_ipv6_tcp_normal
+        test_remove_addr_ipv6_udp_normal
+        test_remove_addr_ipv4_tcp_transparent
+        test_remove_addr_ipv4_udp_transparent
+        test_remove_addr_ipv6_tcp_transparent
+        test_remove_addr_ipv6_udp_transparent
+        test_remove_addr_ipv4_hdrincl
+        test_remove_addr_ipv6_hdrincl
+        test_expire_addr_ipv4_tcp_normal
+        test_expire_addr_ipv4_udp_normal
+        test_expire_addr_ipv6_tcp_normal
+        test_expire_addr_ipv6_udp_normal
+        test_expire_addr_ipv4_tcp_transparent
+        test_expire_addr_ipv4_udp_transparent
+        test_expire_addr_ipv6_tcp_transparent
+        test_expire_addr_ipv6_udp_transparent
+        test_expire_addr_ipv4_hdrincl
+        test_expire_addr_ipv6_hdrincl
+        test_foreign_addr_ipv4_udp_normal
+        test_foreign_addr_ipv6_udp_normal
+        test_foreign_addr_ipv4_udp_transparent
+        test_foreign_addr_ipv6_udp_transparent
+        test_foreign_addr_ipv4_hdrincl
+        test_foreign_addr_ipv6_hdrincl
+"
+
+source lib.sh
+
+SRV_ADDR4=172.16.1.1/16
+SRV_ADDR6=2001:db8:1::1/64
+CLI_ADDR4=172.16.1.2/16
+CLI_ADDR6=2001:db8:1::2/64
+SENDER_ADDR4=172.16.1.3/16
+SENDER_ADDR6=2001:db8:1::3/64
+FOREIGN_ADDR4=172.16.1.4/16
+FOREIGN_ADDR6=2001:db8:1::4/64
+PORT=12345
+
+##########################
+# Global setup & cleanup
+##########################
+
+cleanup() {
+	cleanup_ns "$ns_srv" "$ns_cli"
+	rm -rf "$SRV_SYNC_DIR"
+}
+
+setup() {
+	setup_ns ns_srv ns_cli
+	ip -n $ns_srv link add eth0 netns $ns_cli type veth peer eth0
+
+	ip -n $ns_cli link set lo up
+	ip -n $ns_cli link set eth0 up
+	ip -n $ns_cli addr add "$CLI_ADDR4" dev eth0
+	ip -n $ns_cli addr add "$CLI_ADDR6" dev eth0 nodad
+
+	ip -n $ns_srv link set lo up
+	ip -n $ns_srv link set eth0 up
+	ip -n $ns_srv addr add "$SRV_ADDR4" dev eth0
+	ip -n $ns_srv addr add "$SRV_ADDR6" dev eth0 nodad
+
+	SRV_SYNC_DIR="$(mktemp -d)"
+	SRV_SYNC_FILE="$SRV_SYNC_DIR/sync_fifo"
+	mkfifo "$SRV_SYNC_FILE"
+}
+
+#################################
+# Tests setup, cleanup & helpers
+#################################
+
+setup_test_tcp_udp() {
+	local ipvx="$1"
+	local proto="$2"
+	local sock_type="$3"
+	local sync_file="$4"
+	local nodad addr_args
+	CLOSE_FD3=
+	RET=0
+
+	if [ "$sock_type" = "hdrincl" ]; then
+		RET=$ksft_fail
+		return 1
+	fi
+
+	shift 4
+	[ "$ipvx" = "ipv6" ] && nodad="nodad"
+	[ "$#" -gt 0 ] && addr_args="$*"
+
+	if [ "$ipvx" = "ipv6" ]; then
+		SENDER_ADDR="$SENDER_ADDR6"
+		FOREIGN_ADDR="$FOREIGN_ADDR6"
+	elif [ "$ipvx" = "ipv4" ]; then
+		SENDER_ADDR="$SENDER_ADDR4"
+		FOREIGN_ADDR="$FOREIGN_ADDR4"
+	else
+		RET=$ksft_fail
+		return 1
+	fi
+
+	# start the C helper server and wait until it's listening
+	ip netns exec $ns_srv \
+		./ip_saddr "$ipvx" "$proto" "$PORT" "$sock_type" "$sync_file" &
+	SRV_PID=$!
+	wait_local_port_listen "$ns_srv" "$PORT" "$proto"
+
+	# the message is sent from the server, configure SENDER_ADDR on it
+	ip -n $ns_srv addr add "$SENDER_ADDR" dev eth0 $nodad $addr_args
+}
+
+setup_test_hdrincl() {
+	local ipvx="$1"
+	local sock_type="$2"
+	local nodad addr_args
+	RET=0
+
+	if [ "$sock_type" != "hdrincl" ]; then
+		RET=$ksft_fail
+		return 1
+	fi
+
+	shift 2
+	[ "$ipvx" = "ipv6" ] && nodad="nodad"
+	[ "$#" -gt 0 ] && addr_args="$*"
+
+	if [ "$ipvx" = "ipv6" ]; then
+		SENDER_ADDR="$SENDER_ADDR6"
+		FOREIGN_ADDR="$FOREIGN_ADDR6"
+		SRV_ADDR="$SRV_ADDR6"
+	elif [ "$ipvx" = "ipv4" ]; then
+		SENDER_ADDR="$SENDER_ADDR4"
+		FOREIGN_ADDR="$FOREIGN_ADDR4"
+		SRV_ADDR="$SRV_ADDR4"
+	else
+		RET=$ksft_fail
+		return 1
+	fi
+
+	# the message is sent from the client, configure SENDER_ADDR on it
+	ip -n $ns_cli addr add "$SENDER_ADDR" dev eth0 $nodad $addr_args
+
+	# start the C helper server and wait until it's listening
+	exec 3< <(exec ip netns exec $ns_srv ./ip_saddr "$ipvx" "raw")
+	SRV_PID=$!
+	CLOSE_FD3=yes
+	wait_raw_sock_listen_any_addr "$ipvx" "$ns_srv"
+}
+
+set_test_result() {
+	local sock_type="$1"
+	local normal_expect_empty="$2"
+	local srv_msg="$3"
+
+	if [ "$normal_expect_empty" = "yes" ] && [ "$sock_type" = "normal" ]
+        then
+		[ "$srv_msg" != "" ] && RET=$ksft_fail
+	else
+		[ "$srv_msg" = "" ] && RET=$ksft_fail
+	fi
+}
+
+cleanup_test() {
+	kill "$SRV_PID" &>/dev/null
+	wait "$SRV_PID"
+	ip -n $ns_srv addr del "$SENDER_ADDR" dev eth0 &>/dev/null
+	ip -n $ns_cli addr del "$SENDER_ADDR" dev eth0 &>/dev/null
+	[ "$CLOSE_FD3" = "yes" ] && exec 3<&-
+}
+
+wait_raw_sock_listen_any_addr() {
+	local ipvx="$1"
+	local ns="$2"
+	local ptrn proto found i
+
+	if [ "$ipvx" = "ipv4" ]; then
+		ptrn='^00000000:'
+		proto=raw
+	elif [ "$ipvx" = "ipv6" ]; then
+		ptrn='^00000000000000000000000000000000:'
+		proto=raw6
+	else
+		RET=$ksft_fail
+		return 1
+	fi
+	for i in $(seq 10); do
+		found="$(ip netns exec "$ns" cat "/proc/net/$proto" | \
+			awk -vptrn="$ptrn" '$2 ~ ptrn {print "yes"}')"
+		[ "$found" = "yes" ] && return 0
+		sleep 0.1
+	done
+	RET=$ksft_fail
+	return 1
+}
+
+wait_addr_missing() {
+	local ns="$1"
+	local iface="$2"
+	local addr="$3"
+	local timeout="${4:-1}"
+
+	for i in $(seq $((timeout * 10))); do
+		ip -n "$ns" -br a show dev "$iface" | grep -q "$addr" || return 0
+		sleep 0.1
+	done
+	RET=$ksft_fail
+	return 1
+}
+
+##########################
+# Test cases
+##########################
+
+# Open a TCP/UDP connection and wait for a message from the server. The address
+# is still configured, so the expectation is to always receive the message.
+test_keep_addr_tcp_udp() {
+	local test_name="$1"
+	local ipvx="$2"
+	local proto="$3"
+	local sock_type="$4"
+	local srv_msg
+
+	setup_test_tcp_udp "$ipvx" "$proto" "$sock_type" ""
+	srv_msg="$(ip netns exec $ns_cli bash -c "
+                        exec 3<>'/dev/$proto/${SENDER_ADDR%/*}/$PORT'
+                        [ '$proto' = 'udp' ] && echo 'x' >&3
+                        timeout 2s cat <&3
+                        exec 3<&-
+                ")"
+	set_test_result "$sock_type" "no" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Send a message to the server through a raw socket with HDRINCL.
+test_keep_addr_hdrincl() {
+	local test_name="$1"
+	local ipvx="$2"
+	local srv_msg
+
+	setup_test_hdrincl "$ipvx" "hdrincl"
+	ip netns exec $ns_cli \
+		./ip_saddr "$ipvx" "raw" "${SENDER_ADDR%/*}" "${SRV_ADDR%/*}"
+	srv_msg="$(timeout 2s cat <&3)"
+	set_test_result "hdrincl" "" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Open a TCP/UDP connection to the server, remove the address from the server
+# and wait for a message from it. As the address is no longer present, the
+# expectation is not to receive the message, except for transparent sockets.
+test_remove_addr_tcp_udp() {
+	local test_name="$1"
+	local ipvx="$2"
+	local proto="$3"
+	local sock_type="$4"
+	local srv_msg
+
+	setup_test_tcp_udp "$ipvx" "$proto" "$sock_type" "$SRV_SYNC_FILE"
+	srv_msg="$(ip netns exec $ns_cli bash -c "
+                        exec 3<>'/dev/$proto/${SENDER_ADDR%/*}/$PORT'
+                        [ '$proto' = 'udp' ] && echo 'x' >&3
+                        ip -n $ns_srv addr del '$SENDER_ADDR' dev eth0
+                        wait_addr_missing '$ns_srv' eth0 '$SENDER_ADDR'
+                        echo 'x' > '$SRV_SYNC_FILE'
+                        timeout 2s cat <&3
+                        exec 3<&-
+                ")"
+	set_test_result "$sock_type" "yes" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Start listening by the server, remove the address from the client and send a
+# message to the server through a raw socket with HDRINCL. Because of the
+# HDRINCL, the expectation is to receive the message despite the removed address
+test_remove_addr_hdrincl() {
+	local test_name="$1"
+	local ipvx="$2"
+	local srv_msg
+
+	setup_test_hdrincl "$ipvx" "hdrincl"
+	ip -n $ns_cli addr del "$SENDER_ADDR" dev eth0
+	wait_addr_missing "$ns_cli" eth0 "$SENDER_ADDR"
+	ip netns exec $ns_cli \
+		./ip_saddr "$ipvx" "raw" "${SENDER_ADDR%/*}" "${SRV_ADDR%/*}"
+	srv_msg="$(timeout 2s cat <&3)"
+	set_test_result "hdrincl" "" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Open a TCP/UDP connection to the server, wait until its address expires and
+# wait for a message from it. As the address is no longer present, the
+# expectation is not to receive the message, except for transparent sockets.
+test_expire_addr_tcp_udp() {
+	local test_name="$1"
+	local ipvx="$2"
+	local proto="$3"
+	local sock_type="$4"
+	local srv_msg
+
+	setup_test_tcp_udp "$ipvx" "$proto" "$sock_type" "$SRV_SYNC_FILE" preferred_lft 1 valid_lft 1
+	srv_msg="$(ip netns exec $ns_cli bash -c "
+                        exec 3<>'/dev/$proto/${SENDER_ADDR%/*}/$PORT'
+                        [ '$proto' = 'udp' ] && echo 'x' >&3
+                        wait_addr_missing '$ns_srv' eth0 '$SENDER_ADDR' 5
+                        echo 'x' > '$SRV_SYNC_FILE'
+                        timeout 2s cat <&3
+                        exec 3<&-
+                ")"
+	set_test_result "$sock_type" "yes" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Start listening by the server, wait until the client's address expires and
+# send a message to the server through a raw socket with HDRINCL. Because of the
+# HDRINCL, the expectation is to receive the message despite the expired address
+test_expire_addr_hdrincl() {
+	local test_name="$1"
+	local ipvx="$2"
+	local srv_msg
+
+	setup_test_hdrincl "$ipvx" "hdrincl" preferred_lft 1 valid_lft 1
+	wait_addr_missing "$ns_cli" eth0 "$SENDER_ADDR" 5
+	ip netns exec $ns_cli \
+		./ip_saddr "$ipvx" "raw" "${SENDER_ADDR%/*}" "${SRV_ADDR%/*}"
+	srv_msg="$(timeout 2s cat <&3)"
+	set_test_result "hdrincl" "" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Try to receive an UDP message from the server using a non-existent source
+# address. The expectation is not to receive the message except with transparent
+# sockets. This cannot be tested with TCP because the incoming packets are
+# dropped, so the TCP connection cannot be established.
+test_foreign_addr_udp() {
+	local test_name="$1"
+	local ipvx="$2"
+	local sock_type="$3"
+	local srv_msg
+
+	setup_test_tcp_udp "$ipvx" "udp" "$sock_type" ""
+	srv_msg="$(ip netns exec $ns_cli bash -c "
+                        exec 3<>'/dev/udp/${FOREIGN_ADDR%/*}/$PORT'
+                        cli_port=\"\$(ss -uanp | grep \"pid=\$BASHPID,fd=3\" | awk '{print \$4}' | sed 's/.*://')\"
+                        echo \"${FOREIGN_ADDR%/*} \$cli_port\" >/dev/udp/${SENDER_ADDR%/*}/$PORT
+                        timeout 2s cat <&3
+                        exec 3<&-
+                ")"
+	set_test_result "$sock_type" "yes" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+# Send a message to the server through a raw socket with HDRINCL. As the socket
+# is configured as HDRINCL, the expectation is to receive the message.
+test_foreign_addr_hdrincl() {
+	local test_name="$1"
+	local ipvx="$2"
+	local srv_msg
+
+	setup_test_hdrincl "$ipvx" "hdrincl"
+	ip netns exec $ns_cli \
+		./ip_saddr "$ipvx" "raw" "${FOREIGN_ADDR%/*}" "${SRV_ADDR%/*}"
+	srv_msg="$(timeout 2s cat <&3)"
+	set_test_result "hdrincl" "" "$srv_msg"
+	cleanup_test
+	log_test "$test_name"
+}
+
+test_keep_addr_ipv4_tcp_normal() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp normal
+}
+
+test_keep_addr_ipv4_udp_normal() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp normal
+}
+
+test_keep_addr_ipv6_tcp_normal() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp normal
+}
+
+test_keep_addr_ipv6_udp_normal() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp normal
+}
+
+test_keep_addr_ipv4_tcp_transparent() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp transparent
+}
+
+test_keep_addr_ipv4_udp_transparent() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp transparent
+}
+
+test_keep_addr_ipv6_tcp_transparent() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp transparent
+}
+
+test_keep_addr_ipv6_udp_transparent() {
+	test_keep_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp transparent
+}
+
+test_keep_addr_ipv4_hdrincl() {
+	test_keep_addr_hdrincl "${FUNCNAME[0]}" ipv4
+}
+
+test_keep_addr_ipv6_hdrincl() {
+	test_keep_addr_hdrincl "${FUNCNAME[0]}" ipv6
+}
+
+test_remove_addr_ipv4_tcp_normal() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp normal
+}
+
+test_remove_addr_ipv4_udp_normal() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp normal
+}
+
+test_remove_addr_ipv6_tcp_normal() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp normal
+}
+
+test_remove_addr_ipv6_udp_normal() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp normal
+}
+
+test_remove_addr_ipv4_tcp_transparent() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp transparent
+}
+
+test_remove_addr_ipv4_udp_transparent() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp transparent
+}
+
+test_remove_addr_ipv6_tcp_transparent() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp transparent
+}
+
+test_remove_addr_ipv6_udp_transparent() {
+	test_remove_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp transparent
+}
+
+test_remove_addr_ipv4_hdrincl() {
+	test_remove_addr_hdrincl "${FUNCNAME[0]}" ipv4
+}
+
+test_remove_addr_ipv6_hdrincl() {
+	test_remove_addr_hdrincl "${FUNCNAME[0]}" ipv6
+}
+
+test_expire_addr_ipv4_tcp_normal() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp normal
+}
+
+test_expire_addr_ipv4_udp_normal() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp normal
+}
+
+test_expire_addr_ipv6_tcp_normal() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp normal
+}
+
+test_expire_addr_ipv6_udp_normal() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp normal
+}
+
+test_expire_addr_ipv4_tcp_transparent() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv4 tcp transparent
+}
+
+test_expire_addr_ipv4_udp_transparent() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv4 udp transparent
+}
+
+test_expire_addr_ipv6_tcp_transparent() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv6 tcp transparent
+}
+
+test_expire_addr_ipv6_udp_transparent() {
+	test_expire_addr_tcp_udp "${FUNCNAME[0]}" ipv6 udp transparent
+}
+
+test_expire_addr_ipv4_hdrincl() {
+	test_expire_addr_hdrincl "${FUNCNAME[0]}" ipv4
+}
+
+test_expire_addr_ipv6_hdrincl() {
+	test_expire_addr_hdrincl "${FUNCNAME[0]}" ipv6
+}
+
+test_foreign_addr_ipv4_udp_normal() {
+	test_foreign_addr_udp "${FUNCNAME[0]}" ipv4 normal
+}
+
+test_foreign_addr_ipv6_udp_normal() {
+	test_foreign_addr_udp "${FUNCNAME[0]}" ipv6 normal
+}
+
+test_foreign_addr_ipv4_udp_transparent() {
+	test_foreign_addr_udp "${FUNCNAME[0]}" ipv4 transparent
+}
+
+test_foreign_addr_ipv6_udp_transparent() {
+	test_foreign_addr_udp "${FUNCNAME[0]}" ipv6 transparent
+}
+
+test_foreign_addr_ipv4_hdrincl() {
+	test_foreign_addr_hdrincl "${FUNCNAME[0]}" ipv4
+}
+
+test_foreign_addr_ipv6_hdrincl() {
+	test_foreign_addr_hdrincl "${FUNCNAME[0]}" ipv6
+}
+
+export -f wait_addr_missing
+trap cleanup EXIT
+setup
+tests_run
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/ipv6_anycast.sh b/tools/testing/selftests/net/ipv6_anycast.sh
new file mode 100755
index 000000000000..5fa7a2db2a81
--- /dev/null
+++ b/tools/testing/selftests/net/ipv6_anycast.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test that IPv6 anycast addresses work. There are two ways to configure IPv6
+# anycast addresses: by opening a socket with the IPV6_JOIN_ANYCAST sockopt,
+# and automatically joining to the subnet-router anycast address. For simplicity
+# we'll use the 2nd method: when forwarding is enabled, the kernel automatically
+# joins the subnet-router anycast address (prefix with all host bits zero).
+
+ALL_TESTS="
+	test_ipv6_ping_anycast
+	test_ipv6_ping_anycast_src
+"
+
+source lib.sh
+
+H1_ADDR=2001:db8::1/64
+H2_ADDR=2001:db8::2/64
+ANYCAST_ADDR="2001:db8::"
+
+# shellcheck disable=SC2329
+cleanup()
+{
+	cleanup_ns $ns1 $ns2
+}
+
+
+setup() {
+	setup_ns ns1 ns2
+	ip -netns $ns1 link add veth0 type veth peer name veth0 netns $ns2
+
+	ip netns exec $ns1 sysctl -qw net.ipv6.conf.veth0.forwarding=0
+	ip netns exec $ns2 sysctl -qw net.ipv6.conf.veth0.forwarding=1
+	ip netns exec $ns2 sysctl -qw net.ipv6.icmp.echo_ignore_anycast=0
+	ip netns exec $ns2 sysctl -qw net.ipv6.anycast_src_echo_reply=0
+
+	ip -netns $ns1 -6 addr add "$H1_ADDR" dev veth0 nodad
+	ip -netns $ns1 link set dev veth0 up
+	ip -netns $ns2 -6 addr add "$H2_ADDR" dev veth0 nodad
+	ip -netns $ns2 link set dev veth0 up
+}
+
+# shellcheck disable=SC2329
+test_ipv6_ping_anycast() {
+	RET=0
+	if ! ip netns exec $ns1 ping -6 -c 3 -w 5 "$ANYCAST_ADDR" &>/dev/null; then
+		RET=$ksft_fail
+	fi
+	log_test "${FUNCNAME[0]}"
+}
+
+# shellcheck disable=SC2329
+test_ipv6_ping_anycast_src() {
+	# Also check that the echo-reply came from saddr=$ANYCAST_ADDR
+	RET=0
+	ip netns exec $ns2 sysctl -qw net.ipv6.anycast_src_echo_reply=1
+	if ! ip netns exec $ns1 ping -6 -c 3 -w 5 "$ANYCAST_ADDR" 2>/dev/null \
+	     | grep "$ANYCAST_ADDR:" &>/dev/null; then
+		RET=$ksft_fail
+	fi
+	ip netns exec $ns2 sysctl -qw net.ipv6.anycast_src_echo_reply=0
+	log_test "${FUNCNAME[0]}"
+}
+
+trap cleanup EXIT
+setup
+tests_run
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/loopback_subnet.sh b/tools/testing/selftests/net/loopback_subnet.sh
new file mode 100755
index 000000000000..c846e65f01f3
--- /dev/null
+++ b/tools/testing/selftests/net/loopback_subnet.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test loopback subnets (a.k.a. AnyIP). The topology is a client and a server,
+# with the server having a loopback subnet. Test permutations of the following
+# variations:
+# - ipv4 / ipv6
+# - ping from client / localhost ping from the server itself
+# - loopback subnet in the local table / loopback subnet in other table
+#
+#                           ns_srv | ns_cli
+# ---------------------------------|--------------
+#     [ lo ]            [ eth0 ]---|---[ eth0 ]
+# LO_SUBNET(route)     SRV_IFADDR  |  CLI_IFADDR
+
+# shellcheck disable=SC2329
+
+ALL_TESTS="
+        test_loopback_subnet_from_localhost_ipv4
+        test_loopback_subnet_from_localhost_ipv6
+        test_loopback_subnet_from_remote_ipv4
+        test_loopback_subnet_from_remote_ipv6
+        test_loopback_subnet_from_localhost_ipv4_table
+        test_loopback_subnet_from_localhost_ipv6_table
+        test_loopback_subnet_from_remote_ipv4_table
+        test_loopback_subnet_from_remote_ipv6_table
+"
+
+source "lib.sh"
+
+LO_SUBNET4=192.168.88.0/24
+LO_ADDR4=192.168.88.14    # Just any address in LO_SUBNET4
+LO_SUBNET6=2001:db8:88::/64
+LO_ADDR6=2001:db8:88::54  # Just any address in LO_SUBNET6
+SRV_IFADDR4=192.168.99.1
+SRV_IFADDR6=2001:db8:99::1
+CLI_IFADDR4=192.168.99.2
+CLI_IFADDR6=2001:db8:99::2
+RT_TABLE=200
+
+cleanup() {
+	cleanup_ns $ns_srv $ns_cli
+}
+
+setup() {
+        setup_ns ns_srv ns_cli
+        ip -n $ns_srv link add eth0 netns $ns_cli type veth peer eth0
+
+        ip -n $ns_srv link set eth0 up
+        ip -n $ns_srv link set lo up
+        ip -n $ns_srv addr add "$SRV_IFADDR4/24" dev eth0
+        ip -n $ns_srv addr add "$SRV_IFADDR6/64" dev eth0 nodad
+
+        ip -n $ns_cli link set eth0 up
+        ip -n $ns_cli addr add "$CLI_IFADDR4/24" dev eth0
+        ip -n $ns_cli addr add "$CLI_IFADDR6/64" dev eth0 nodad
+        ip -n $ns_cli route add "$LO_SUBNET4" via "$SRV_IFADDR4"
+        ip -n $ns_cli route add "$LO_SUBNET6" via "$SRV_IFADDR6"
+}
+
+setup_loopback_subnets() {
+        local rt_table="${1:-local}"
+
+        ip -n $ns_srv route add local "$LO_SUBNET4" dev lo table "$rt_table"
+        ip -n $ns_srv route add local "$LO_SUBNET6" dev lo table "$rt_table"
+        if [[ $rt_table != local && $rt_table != 255 ]]; then
+                ip -n $ns_srv rule add from all lookup "$rt_table"
+        fi
+}
+
+cleanup_loopback_subnets() {
+        local rt_table="${1:-local}"
+
+        ip -n $ns_srv route del local "$LO_SUBNET4" dev lo table "$rt_table"
+        ip -n $ns_srv route del local "$LO_SUBNET6" dev lo table "$rt_table"
+        if [[ $rt_table != local && $rt_table != 255 ]]; then
+                ip -n $ns_srv rule del from all lookup "$rt_table"
+        fi
+}
+
+run_test() {
+        local test_name="$1"
+        local ns="$2"
+        local ping_addr="$3"
+        local rt_table="$4"
+
+        RET=0
+        setup_loopback_subnets "$rt_table"
+        if ! ip netns exec "$ns" ping -c 3 "$ping_addr" &>/dev/null; then
+                if [[ $FAIL_TO_XFAIL = yes ]]; then
+                        RET=$ksft_xfail
+                else
+                        RET=$ksft_fail
+                fi
+        fi
+        cleanup_loopback_subnets "$rt_table"
+        log_test "$test_name"
+}
+
+test_loopback_subnet_from_localhost_ipv4() {
+        run_test "${FUNCNAME[0]}" "$ns_srv" "$LO_ADDR4"
+}
+
+test_loopback_subnet_from_localhost_ipv6() {
+        run_test "${FUNCNAME[0]}" "$ns_srv" "$LO_ADDR6"
+}
+
+test_loopback_subnet_from_remote_ipv4() {
+        run_test "${FUNCNAME[0]}" "$ns_cli" "$LO_ADDR4"
+}
+
+test_loopback_subnet_from_remote_ipv6() {
+        run_test "${FUNCNAME[0]}" "$ns_cli" "$LO_ADDR6"
+}
+
+test_loopback_subnet_from_localhost_ipv4_table() {
+        xfail run_test "${FUNCNAME[0]}" "$ns_srv" "$LO_ADDR4" "$RT_TABLE"
+}
+
+test_loopback_subnet_from_localhost_ipv6_table() {
+        xfail run_test "${FUNCNAME[0]}" "$ns_srv" "$LO_ADDR6" "$RT_TABLE"
+}
+
+test_loopback_subnet_from_remote_ipv4_table() {
+        xfail run_test "${FUNCNAME[0]}" "$ns_cli" "$LO_ADDR4" "$RT_TABLE"
+}
+
+test_loopback_subnet_from_remote_ipv6_table() {
+        xfail run_test "${FUNCNAME[0]}" "$ns_cli" "$LO_ADDR6" "$RT_TABLE"
+}
+
+trap cleanup EXIT
+setup
+tests_run
+exit $EXIT_STATUS
-- 
2.54.0

