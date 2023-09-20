Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C623CE79B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjITJ1m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 05:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjITJ10 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 05:27:26 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA368F3;
        Wed, 20 Sep 2023 02:27:06 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RrCnt2Zg8z6K5sy;
        Wed, 20 Sep 2023 17:26:10 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 20 Sep 2023 10:27:04 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v12 10/12] selftests/landlock: Add 7 new test variants dedicated to network
Date:   Wed, 20 Sep 2023 17:26:38 +0800
Message-ID: <20230920092641.832134-11-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These test suites try to check edge cases for TCP sockets
bind() and connect() actions.

protocol:
* bind: Tests with non-landlocked/landlocked ipv4, ipv6 and unix sockets.
* connect: Tests with non-landlocked/landlocked ipv4, ipv6 and unix
sockets.
* bind_unspec: Tests with non-landlocked/landlocked restrictions
for bind action with AF_UNSPEC socket family.
* connect_unspec: Tests with non-landlocked/landlocked restrictions
for connect action with AF_UNSPEC socket family.

ipv4:
* from_unix_to_inet: Tests to make sure unix sockets' actions are not
restricted by Landlock rules applied to TCP ones.

tcp_layers:
* ruleset_overlap.
* ruleset_expand.

mini:
* network_access_rights: Tests with  legitimate access values.
* unknown_access_rights: Tests with invalid attributes, out of access range.
* inval:
    - unhandled allowed access.
    - zero access value.
* tcp_port_overflow: Tests with wrong port values more than U16_MAX.

ipv4_tcp:
* port_endianness: Tests with big/little endian port formats.

port_zero:
* bind_connect: Tests with port zero value.

layout1:
* with_net: Tests with network bind() socket action within
filesystem directory access test.

Test coverage for security/landlock is 94.7% of 933 lines according
to gcc/gcov-11.

Co-developted-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v11:
* Adds ipv4.from_unix_to_tcp test suite to check that socket family is
  the same between a socket and a sockaddr by trying to connect/bind on
  a unix socket (stream or dgram) using an inet family.  Landlock should
  not change the error code.  This found a bug (which needs to be fixed)
  with the TCP restriction.
* Revamps the inet.{bind,connect} tests into protocol.{bind,connect}:
  - Merge bind_connect_unix_dgram_socket, bind_connect_unix_dgram_socket
    and bind_connect_inval_addrlen into it: add a full test matrix of
    IPv4/TCP, IPv6/TCP, IPv4/UDP, IPv6/UDP, unix/stream, unix/dgram, all
    of them with or without sandboxing. This improve coverage and it
    enables to check that a TCP restriction work as expected but doesn't
    restrict other stream or datagram protocols. This also enables to
    check consistency of the network stack with or without Landlock.
    We now have 76 test suites for the network.
  - Add full send/recv checks.
  - Make a generic framework that will be ready for future
    protocol supports.
* Replaces most ASSERT with EXPECT according to the criticity of an
  action: if we can get more meaningful information with following
  checks.  For instance, failure to create a kernel object (e.g.
  socket(), accept() or fork() call) is critical if it is used by
  following checks. For Landlock ruleset building, the following checks
  don't make sense if the sandbox is not complete.  However, it doesn't
  make sense to continue a FIXTURE_SETUP() if any check failed.
* Adds a new unspec fixture to replace inet.bind_afunspec with
  unspec.bind and inet.connect_afunspec with unspec.connect, factoring
  and simplifying code.
* Replaces inet.bind_afunspec with protocol.bind_unspec, and
  inet.connect_afunspec with protocol.connect_unspec.  Extend these
  tests with the matrix of all "protocol" variants.  Don't test connect
  with the same socket which is already binded/listening (I guess this
  was an copy-paste error).  The protocol.bind_unspec tests found a bug
  (which needs to be fixed).
* Add* and use set_service() and setup_loopback() helpers to configure
  network services.  Add and use and test_bind_and_connect() to factor
  out a lot of checks.
* Adds new types (protocol_variant, service_fixture) and update related
  helpers to get more generic test code.
* Replaces static (port) arrays with service_fixture variables.
* Adds new helpers: {bind,connect}_variant_addrlen() and get_addrlen() to
  cover all protocols with previous bind_connect_inval_addrlen tests.
  Make them return -errno in case of error.
* Switchs from a unix socket path address to an abstract one. This
  enables to avoid file cleanup in test teardowns.
* Closes all rulesets after enforcement.
* Removes the duplicate "empty access" test.
* Replaces inet.ruleset_overlay with tcp_layers.ruleset_overlap and
  simplify test:
  - Always run sandbox tests because test were always run sandboxed and
    it doesn't give more guarantees to do it not sandboxed.
  - Rewrite test with variant->num_layers to make it simpler and
    configurable.
  - Add another test layer to tcp_layers used for ruleset_overlap and
    test without sandbox.
  - Leverage test_bind_and_connect() and avoid using SO_REUSEADDR
    because the socket was not listened to, and don't use the same
    socket/FD for server and client.
  - Replace inet.ruleset_expanding with tcp_layers.ruleset_expand.
* Drops capabilities in all FIXTURE_SETUP().
* Changes test ports to cover more ranges.
* Adds "mini" tests:
  - Replace the invalid ruleset attribute test from port.inval with
    mini.unknow_access_rights.
  - Simplify port.inval and move some code to other mini.* tests.
  - Add new mini.network_access_rights test.
* Rewrites inet.inval_port_format into mini.tcp_port_overflow:
  - Remove useless is_sandbox checks.
  - Extend tests with bind/connect checks.
  - Interleave valid requests with invalid ones.
* Adds two_srv.port_endianness test, extracted and extended from
  inet.inval_port_format .
* Adds Microsoft copyright.
* Rename some variables to make them easier to read.
* Constifies variables.
* Adds minimal logs to help debug test failures.
* Renames inet test to ipv4 and deletes is_sandboxed and prot vars from
  FIXTURE_VARIANT.
* Adds port_zero tests.
* Renames all "net_service" to "net_port".

Changes since v10:
* Replaces FIXTURE_VARIANT() with struct _fixture_variant_ .
* Changes tests names socket -> inet, standalone -> port.
* Gets rid of some DEFINEs.
* Changes names and groups tests' variables.
* Changes create_socket_variant() helper name to socket_variant().
* Refactors FIXTURE_SETUP(port) logic.
* Changes TEST_F_FORK -> TEST_F since there no teardown.
* Refactors some tests' logic.
* Minor fixes.
* Refactors commit message.

Changes since v9:
* Fixes mixing code declaration and code.
* Refactors FIXTURE_TEARDOWN() with clang-format.
* Replaces struct _fixture_variant_socket with
FIXTURE_VARIANT(socket).
* Deletes useless condition if (variant->is_sandboxed)
in multiple locations.
* Deletes zero_size argument in bind_variant() and
connect_variant().
* Adds tests for port values exceeding U16_MAX.

Changes since v8:
* Adds is_sandboxed const for FIXTURE_VARIANT(socket).
* Refactors AF_UNSPEC tests.
* Adds address length checking tests.
* Convert ports in all tests to __be16.
* Adds invalid port values tests.
* Minor fixes.

Changes since v7:
* Squashes all selftest commits.
* Adds fs test with network bind() socket action.
* Minor fixes.

---
 tools/testing/selftests/landlock/config     |    4 +
 tools/testing/selftests/landlock/fs_test.c  |   63 +
 tools/testing/selftests/landlock/net_test.c | 1592 +++++++++++++++++++
 3 files changed, 1659 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/net_test.c

diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 3dc9e438eab1..0086efaa7b68 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,5 +1,9 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
+CONFIG_INET=y
+CONFIG_IPV6=y
+CONFIG_NET=y
+CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y
 CONFIG_PROC_FS=y
 CONFIG_SECURITY=y
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 7c94d3933b68..87b56f435428 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -8,9 +8,11 @@
  */

 #define _GNU_SOURCE
+#include <arpa/inet.h>
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <linux/magic.h>
+#include <netinet/in.h>
 #include <sched.h>
 #include <stdio.h>
 #include <string.h>
@@ -18,6 +20,7 @@
 #include <sys/mount.h>
 #include <sys/prctl.h>
 #include <sys/sendfile.h>
+#include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <sys/vfs.h>
@@ -4752,4 +4755,64 @@ TEST_F_FORK(layout3_fs, release_inodes)
 	ASSERT_EQ(EACCES, test_open(TMP_DIR, O_RDONLY));
 }

+static const char loopback_ipv4[] = "127.0.0.1";
+const unsigned short sock_port = 15000;
+
+TEST_F_FORK(layout1, with_net)
+{
+	const struct rule rules[] = {
+		{
+			.path = dir_s1d2,
+			.access = ACCESS_RO,
+		},
+		{},
+	};
+	struct landlock_ruleset_attr ruleset_attr_net = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_port_attr tcp_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = sock_port,
+	};
+	int sockfd, ruleset_fd, ruleset_fd_net;
+	struct sockaddr_in addr4;
+
+	addr4.sin_family = AF_INET;
+	addr4.sin_port = htons(sock_port);
+	addr4.sin_addr.s_addr = inet_addr(loopback_ipv4);
+	memset(&addr4.sin_zero, '\0', 8);
+
+	/* Creates ruleset for network access. */
+	ruleset_fd_net = landlock_create_ruleset(&ruleset_attr_net,
+						 sizeof(ruleset_attr_net), 0);
+	ASSERT_LE(0, ruleset_fd_net);
+
+	/* Adds a network rule. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_PORT,
+				       &tcp_bind, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd_net);
+	ASSERT_EQ(0, close(ruleset_fd_net));
+
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
+
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tests on a directory with the network rule loaded. */
+	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
+
+	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, sockfd);
+	/* Binds a socket to port 15000. */
+	ASSERT_EQ(0, bind(sockfd, &addr4, sizeof(addr4)));
+
+	/* Closes bounded socket. */
+	ASSERT_EQ(0, close(sockfd));
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
new file mode 100644
index 000000000000..82eb7757fecc
--- /dev/null
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -0,0 +1,1592 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Network
+ *
+ * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#define _GNU_SOURCE
+#include <arpa/inet.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/landlock.h>
+#include <linux/in.h>
+#include <sched.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+
+#include "common.h"
+
+const short sock_port_start = (1 << 10);
+
+static const char loopback_ipv4[] = "127.0.0.1";
+static const char loopback_ipv6[] = "::1";
+
+/* Number pending connections queue to be hold. */
+const short backlog = 10;
+
+enum sandbox_type {
+	NO_SANDBOX,
+	/* This may be used to test rules that allow *and* deny accesses. */
+	TCP_SANDBOX,
+};
+
+struct protocol_variant {
+	int domain;
+	int type;
+};
+
+struct service_fixture {
+	struct protocol_variant protocol;
+	/* port is also stored in ipv4_addr.sin_port or ipv6_addr.sin6_port */
+	unsigned short port;
+	union {
+		struct sockaddr_in ipv4_addr;
+		struct sockaddr_in6 ipv6_addr;
+		struct {
+			struct sockaddr_un unix_addr;
+			socklen_t unix_addr_len;
+		};
+	};
+};
+
+static int set_service(struct service_fixture *const srv,
+		       const struct protocol_variant prot,
+		       const unsigned short index)
+{
+	memset(srv, 0, sizeof(*srv));
+
+	/*
+	 * Copies all protocol properties in case of the variant only contains
+	 * a subset of them.
+	 */
+	srv->protocol = prot;
+
+	/* Checks for port overflow. */
+	if (index > 2)
+		return 1;
+	srv->port = sock_port_start << (2 * index);
+
+	switch (prot.domain) {
+	case AF_UNSPEC:
+	case AF_INET:
+		srv->ipv4_addr.sin_family = prot.domain;
+		srv->ipv4_addr.sin_port = htons(srv->port);
+		srv->ipv4_addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
+		return 0;
+
+	case AF_INET6:
+		srv->ipv6_addr.sin6_family = prot.domain;
+		srv->ipv6_addr.sin6_port = htons(srv->port);
+		inet_pton(AF_INET6, loopback_ipv6, &srv->ipv6_addr.sin6_addr);
+		return 0;
+
+	case AF_UNIX:
+		srv->unix_addr.sun_family = prot.domain;
+		sprintf(srv->unix_addr.sun_path,
+			"_selftests-landlock-net-tid%d-index%d", gettid(),
+			index);
+		srv->unix_addr_len = SUN_LEN(&srv->unix_addr);
+		srv->unix_addr.sun_path[0] = '\0';
+		return 0;
+	}
+	return 1;
+}
+
+static void setup_loopback(struct __test_metadata *const _metadata)
+{
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	ASSERT_EQ(0, unshare(CLONE_NEWNET));
+	ASSERT_EQ(0, system("ip link set dev lo up"));
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+}
+
+static bool is_restricted(const struct protocol_variant *const prot,
+			  const enum sandbox_type sandbox)
+{
+	switch (prot->domain) {
+	case AF_INET:
+	case AF_INET6:
+		switch (prot->type) {
+		case SOCK_STREAM:
+			return sandbox == TCP_SANDBOX;
+		}
+		break;
+	}
+	return false;
+}
+
+static int socket_variant(const struct service_fixture *const srv)
+{
+	int ret;
+
+	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
+		     0);
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
+#ifndef SIN6_LEN_RFC2133
+#define SIN6_LEN_RFC2133 24
+#endif
+
+static socklen_t get_addrlen(const struct service_fixture *const srv,
+			     const bool minimal)
+{
+	switch (srv->protocol.domain) {
+	case AF_UNSPEC:
+	case AF_INET:
+		return sizeof(srv->ipv4_addr);
+
+	case AF_INET6:
+		if (minimal)
+			return SIN6_LEN_RFC2133;
+		return sizeof(srv->ipv6_addr);
+
+	case AF_UNIX:
+		if (minimal)
+			return sizeof(srv->unix_addr) -
+			       sizeof(srv->unix_addr.sun_path);
+		return srv->unix_addr_len;
+
+	default:
+		return 0;
+	}
+}
+
+static int bind_variant_addrlen(const int sock_fd,
+				const struct service_fixture *const srv,
+				const socklen_t addrlen)
+{
+	int ret;
+
+	switch (srv->protocol.domain) {
+	case AF_UNSPEC:
+	case AF_INET:
+		ret = bind(sock_fd, &srv->ipv4_addr, addrlen);
+		break;
+
+	case AF_INET6:
+		ret = bind(sock_fd, &srv->ipv6_addr, addrlen);
+		break;
+
+	case AF_UNIX:
+		ret = bind(sock_fd, &srv->unix_addr, addrlen);
+		break;
+
+	default:
+		errno = EAFNOSUPPORT;
+		return -errno;
+	}
+
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
+static int bind_variant(const int sock_fd,
+			const struct service_fixture *const srv)
+{
+	return bind_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
+}
+
+static int connect_variant_addrlen(const int sock_fd,
+				   const struct service_fixture *const srv,
+				   const socklen_t addrlen)
+{
+	int ret;
+
+	switch (srv->protocol.domain) {
+	case AF_UNSPEC:
+	case AF_INET:
+		ret = connect(sock_fd, &srv->ipv4_addr, addrlen);
+		break;
+
+	case AF_INET6:
+		ret = connect(sock_fd, &srv->ipv6_addr, addrlen);
+		break;
+
+	case AF_UNIX:
+		ret = connect(sock_fd, &srv->unix_addr, addrlen);
+		break;
+
+	default:
+		errno = -EAFNOSUPPORT;
+		return -errno;
+	}
+
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
+static int connect_variant(const int sock_fd,
+			   const struct service_fixture *const srv)
+{
+	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
+}
+
+FIXTURE(protocol)
+{
+	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
+};
+
+FIXTURE_VARIANT(protocol)
+{
+	const enum sandbox_type sandbox;
+	const struct protocol_variant prot;
+};
+
+FIXTURE_SETUP(protocol)
+{
+	const struct protocol_variant prot_unspec = {
+		.domain = AF_UNSPEC,
+		.type = SOCK_STREAM,
+	};
+
+	disable_caps(_metadata);
+
+	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
+	ASSERT_EQ(0, set_service(&self->srv1, variant->prot, 1));
+	ASSERT_EQ(0, set_service(&self->srv2, variant->prot, 2));
+
+	ASSERT_EQ(0, set_service(&self->unspec_srv0, prot_unspec, 0));
+
+	ASSERT_EQ(0, set_service(&self->unspec_any0, prot_unspec, 0));
+	self->unspec_any0.ipv4_addr.sin_addr.s_addr = htonl(INADDR_ANY);
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(protocol)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_udp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_unix_stream) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_UNIX,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_unix_datagram) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_UNIX,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_udp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_stream) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_UNIX,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_datagram) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_UNIX,
+		.type = SOCK_DGRAM,
+	},
+};
+
+static void test_bind_and_connect(struct __test_metadata *const _metadata,
+				  const struct service_fixture *const srv,
+				  const bool deny_bind, const bool deny_connect)
+{
+	char buf = '\0';
+	int inval_fd, bind_fd, client_fd, status, ret;
+	pid_t child;
+
+	/* Starts invalid addrlen tests with bind. */
+	inval_fd = socket_variant(srv);
+	ASSERT_LE(0, inval_fd)
+	{
+		TH_LOG("Failed to create socket: %s", strerror(errno));
+	}
+
+	/* Tries to bind with zero as addrlen. */
+	EXPECT_EQ(-EINVAL, bind_variant_addrlen(inval_fd, srv, 0));
+
+	/* Tries to bind with too small addrlen. */
+	EXPECT_EQ(-EINVAL, bind_variant_addrlen(inval_fd, srv,
+						get_addrlen(srv, true) - 1));
+
+	/* Tries to bind with minimal addrlen. */
+	ret = bind_variant_addrlen(inval_fd, srv, get_addrlen(srv, true));
+	if (deny_bind) {
+		EXPECT_EQ(-EACCES, ret);
+	} else {
+		EXPECT_EQ(0, ret)
+		{
+			TH_LOG("Failed to bind to socket: %s", strerror(errno));
+		}
+	}
+	EXPECT_EQ(0, close(inval_fd));
+
+	/* Starts invalid addrlen tests with connect. */
+	inval_fd = socket_variant(srv);
+	ASSERT_LE(0, inval_fd);
+
+	/* Tries to connect with zero as addrlen. */
+	EXPECT_EQ(-EINVAL, connect_variant_addrlen(inval_fd, srv, 0));
+
+	/* Tries to connect with too small addrlen. */
+	EXPECT_EQ(-EINVAL, connect_variant_addrlen(inval_fd, srv,
+						   get_addrlen(srv, true) - 1));
+
+	/* Tries to connect with minimal addrlen. */
+	ret = connect_variant_addrlen(inval_fd, srv, get_addrlen(srv, true));
+	if (srv->protocol.domain == AF_UNIX) {
+		EXPECT_EQ(-EINVAL, ret);
+	} else if (deny_connect) {
+		EXPECT_EQ(-EACCES, ret);
+	} else if (srv->protocol.type == SOCK_STREAM) {
+		/* No listening server, whatever the value of deny_bind. */
+		EXPECT_EQ(-ECONNREFUSED, ret);
+	} else {
+		EXPECT_EQ(0, ret)
+		{
+			TH_LOG("Failed to connect to socket: %s",
+			       strerror(errno));
+		}
+	}
+	EXPECT_EQ(0, close(inval_fd));
+
+	/* Starts connection tests. */
+	bind_fd = socket_variant(srv);
+	ASSERT_LE(0, bind_fd);
+
+	ret = bind_variant(bind_fd, srv);
+	if (deny_bind) {
+		EXPECT_EQ(-EACCES, ret);
+	} else {
+		EXPECT_EQ(0, ret);
+
+		/* Creates a listening socket. */
+		if (srv->protocol.type == SOCK_STREAM)
+			EXPECT_EQ(0, listen(bind_fd, backlog));
+	}
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		int connect_fd, ret;
+
+		/* Closes listening socket for the child. */
+		EXPECT_EQ(0, close(bind_fd));
+
+		/* Starts connection tests. */
+		connect_fd = socket_variant(srv);
+		ASSERT_LE(0, connect_fd);
+		ret = connect_variant(connect_fd, srv);
+		if (deny_connect) {
+			EXPECT_EQ(-EACCES, ret);
+		} else if (deny_bind) {
+			/* No listening server. */
+			EXPECT_EQ(-ECONNREFUSED, ret);
+		} else {
+			EXPECT_EQ(0, ret);
+			EXPECT_EQ(1, write(connect_fd, ".", 1));
+		}
+
+		EXPECT_EQ(0, close(connect_fd));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	/* Accepts connection from the child. */
+	client_fd = bind_fd;
+	if (!deny_bind && !deny_connect) {
+		if (srv->protocol.type == SOCK_STREAM) {
+			client_fd = accept(bind_fd, NULL, 0);
+			ASSERT_LE(0, client_fd);
+		}
+
+		EXPECT_EQ(1, read(client_fd, &buf, 1));
+		EXPECT_EQ('.', buf);
+	}
+
+	EXPECT_EQ(child, waitpid(child, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/* Closes connection, if any. */
+	if (client_fd != bind_fd)
+		EXPECT_LE(0, close(client_fd));
+
+	/* Closes listening socket. */
+	EXPECT_EQ(0, close(bind_fd));
+}
+
+TEST_F(protocol, bind)
+{
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		};
+		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = self->srv0.port,
+		};
+		const struct landlock_net_port_attr tcp_connect_p1 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = self->srv1.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows connect and bind for the first port.  */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect_p0, 0));
+
+		/* Allows connect and denies bind for the second port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_connect_p1, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	/* Binds a socket to the first port. */
+	test_bind_and_connect(_metadata, &self->srv0, false, false);
+
+	/* Binds a socket to the second port. */
+	test_bind_and_connect(_metadata, &self->srv1,
+			      is_restricted(&variant->prot, variant->sandbox),
+			      false);
+
+	/* Binds a socket to the third port. */
+	test_bind_and_connect(_metadata, &self->srv2,
+			      is_restricted(&variant->prot, variant->sandbox),
+			      is_restricted(&variant->prot, variant->sandbox));
+}
+
+TEST_F(protocol, connect)
+{
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		};
+		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = self->srv0.port,
+		};
+		const struct landlock_net_port_attr tcp_bind_p1 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = self->srv1.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows connect and bind for the first port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect_p0, 0));
+
+		/* Allows bind and denies connect for the second port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_p1, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	test_bind_and_connect(_metadata, &self->srv0, false, false);
+
+	test_bind_and_connect(_metadata, &self->srv1, false,
+			      is_restricted(&variant->prot, variant->sandbox));
+
+	test_bind_and_connect(_metadata, &self->srv2,
+			      is_restricted(&variant->prot, variant->sandbox),
+			      is_restricted(&variant->prot, variant->sandbox));
+}
+
+TEST_F(protocol, bind_unspec)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+	};
+	const struct landlock_net_port_attr tcp_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = self->srv0.port,
+	};
+	int bind_fd, ret;
+
+	if (variant->sandbox == TCP_SANDBOX) {
+		const int ruleset_fd = landlock_create_ruleset(
+			&ruleset_attr, sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows bind. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	bind_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, bind_fd);
+
+	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
+	ret = bind_variant(bind_fd, &self->unspec_any0);
+	if (variant->prot.domain == AF_INET) {
+		EXPECT_EQ(0, ret)
+		{
+			TH_LOG("Failed to bind to unspec/any socket: %s",
+			       strerror(errno));
+		}
+	} else {
+		EXPECT_EQ(-EINVAL, ret);
+	}
+	EXPECT_EQ(0, close(bind_fd));
+
+	if (variant->sandbox == TCP_SANDBOX) {
+		const int ruleset_fd = landlock_create_ruleset(
+			&ruleset_attr, sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Denies bind. */
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	bind_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, bind_fd);
+
+	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
+	ret = bind_variant(bind_fd, &self->unspec_any0);
+	if (variant->prot.domain == AF_INET) {
+		if (is_restricted(&variant->prot, variant->sandbox)) {
+			EXPECT_EQ(-EACCES, ret);
+		} else {
+			EXPECT_EQ(0, ret);
+		}
+	} else {
+		EXPECT_EQ(-EINVAL, ret);
+	}
+	EXPECT_EQ(0, close(bind_fd));
+
+	/* Checks bind with AF_UNSPEC and the loopback address. */
+	bind_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, bind_fd);
+	ret = bind_variant(bind_fd, &self->unspec_srv0);
+	if (variant->prot.domain == AF_INET) {
+		EXPECT_EQ(-EAFNOSUPPORT, ret);
+	} else {
+		EXPECT_EQ(-EINVAL, ret)
+		{
+			TH_LOG("Wrong bind error: %s", strerror(errno));
+		}
+	}
+	EXPECT_EQ(0, close(bind_fd));
+}
+
+TEST_F(protocol, connect_unspec)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	const struct landlock_net_port_attr tcp_connect = {
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->srv0.port,
+	};
+	int bind_fd, client_fd, status;
+	pid_t child;
+
+	/* Specific connection tests. */
+	bind_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, bind_fd);
+	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
+	if (self->srv0.protocol.type == SOCK_STREAM)
+		EXPECT_EQ(0, listen(bind_fd, backlog));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		int connect_fd, ret;
+
+		/* Closes listening socket for the child. */
+		EXPECT_EQ(0, close(bind_fd));
+
+		connect_fd = socket_variant(&self->srv0);
+		ASSERT_LE(0, connect_fd);
+		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
+
+		/* Tries to connect again, or set peer. */
+		ret = connect_variant(connect_fd, &self->srv0);
+		if (self->srv0.protocol.type == SOCK_STREAM) {
+			EXPECT_EQ(-EISCONN, ret);
+		} else {
+			EXPECT_EQ(0, ret);
+		}
+
+		if (variant->sandbox == TCP_SANDBOX) {
+			const int ruleset_fd = landlock_create_ruleset(
+				&ruleset_attr, sizeof(ruleset_attr), 0);
+			ASSERT_LE(0, ruleset_fd);
+
+			/* Allows connect. */
+			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
+						       LANDLOCK_RULE_NET_PORT,
+						       &tcp_connect, 0));
+			enforce_ruleset(_metadata, ruleset_fd);
+			EXPECT_EQ(0, close(ruleset_fd));
+		}
+
+		/* Disconnects already connected socket, or set peer. */
+		ret = connect_variant(connect_fd, &self->unspec_any0);
+		if (self->srv0.protocol.domain == AF_UNIX &&
+		    self->srv0.protocol.type == SOCK_STREAM) {
+			EXPECT_EQ(-EINVAL, ret);
+		} else {
+			EXPECT_EQ(0, ret);
+		}
+
+		/* Tries to reconnect, or set peer. */
+		ret = connect_variant(connect_fd, &self->srv0);
+		if (self->srv0.protocol.domain == AF_UNIX &&
+		    self->srv0.protocol.type == SOCK_STREAM) {
+			EXPECT_EQ(-EISCONN, ret);
+		} else {
+			EXPECT_EQ(0, ret);
+		}
+
+		if (variant->sandbox == TCP_SANDBOX) {
+			const int ruleset_fd = landlock_create_ruleset(
+				&ruleset_attr, sizeof(ruleset_attr), 0);
+			ASSERT_LE(0, ruleset_fd);
+
+			/* Denies connect. */
+			enforce_ruleset(_metadata, ruleset_fd);
+			EXPECT_EQ(0, close(ruleset_fd));
+		}
+
+		ret = connect_variant(connect_fd, &self->unspec_any0);
+		if (self->srv0.protocol.domain == AF_UNIX &&
+		    self->srv0.protocol.type == SOCK_STREAM) {
+			EXPECT_EQ(-EINVAL, ret);
+		} else {
+			/* Always allowed to disconnect. */
+			EXPECT_EQ(0, ret);
+		}
+
+		EXPECT_EQ(0, close(connect_fd));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	client_fd = bind_fd;
+	if (self->srv0.protocol.type == SOCK_STREAM) {
+		client_fd = accept(bind_fd, NULL, 0);
+		ASSERT_LE(0, client_fd);
+	}
+
+	EXPECT_EQ(child, waitpid(child, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/* Closes connection, if any. */
+	if (client_fd != bind_fd)
+		EXPECT_LE(0, close(client_fd));
+
+	/* Closes listening socket. */
+	EXPECT_EQ(0, close(bind_fd));
+}
+
+FIXTURE(ipv4)
+{
+	struct service_fixture srv0, srv1;
+};
+
+FIXTURE_VARIANT(ipv4)
+{
+	const enum sandbox_type sandbox;
+	const int type;
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(ipv4, no_sandbox_with_tcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.type = SOCK_STREAM,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(ipv4, tcp_sandbox_with_tcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.type = SOCK_STREAM,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(ipv4, no_sandbox_with_udp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.type = SOCK_DGRAM,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(ipv4, tcp_sandbox_with_udp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.type = SOCK_DGRAM,
+};
+
+FIXTURE_SETUP(ipv4)
+{
+	const struct protocol_variant prot = {
+		.domain = AF_INET,
+		.type = variant->type,
+	};
+
+	disable_caps(_metadata);
+
+	set_service(&self->srv0, prot, 0);
+	set_service(&self->srv1, prot, 1);
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(ipv4)
+{
+}
+
+// Kernel FIXME: tcp_sandbox_with_tcp and tcp_sandbox_with_udp
+TEST_F(ipv4, from_unix_to_inet)
+{
+	int unix_stream_fd, unix_dgram_fd;
+
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		};
+		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = self->srv0.port,
+		};
+		int ruleset_fd;
+
+		/* Denies connect and bind to check errno value. */
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows connect and bind for srv0.  */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect_p0, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	unix_stream_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, unix_stream_fd);
+
+	unix_dgram_fd = socket(AF_UNIX, SOCK_DGRAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, unix_dgram_fd);
+
+	/* Checks unix stream bind and connect for srv0. */
+	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv0));
+	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv0));
+
+	/* Checks unix stream bind and connect for srv1. */
+	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv1))
+	{
+		TH_LOG("Wrong bind error: %s", strerror(errno));
+	}
+	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv1));
+
+	/* Checks unix datagram bind and connect for srv0. */
+	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv0));
+	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv0));
+
+	/* Checks unix datagram bind and connect for srv1. */
+	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv1));
+	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv1));
+}
+
+FIXTURE(tcp_layers)
+{
+	struct service_fixture srv0, srv1;
+};
+
+FIXTURE_VARIANT(tcp_layers)
+{
+	const size_t num_layers;
+	const int domain;
+};
+
+FIXTURE_SETUP(tcp_layers)
+{
+	const struct protocol_variant prot = {
+		.domain = variant->domain,
+		.type = SOCK_STREAM,
+	};
+
+	disable_caps(_metadata);
+
+	ASSERT_EQ(0, set_service(&self->srv0, prot, 0));
+	ASSERT_EQ(0, set_service(&self->srv1, prot, 1));
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(tcp_layers)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, no_sandbox_with_ipv4) {
+	/* clang-format on */
+	.domain = AF_INET,
+	.num_layers = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, one_sandbox_with_ipv4) {
+	/* clang-format on */
+	.domain = AF_INET,
+	.num_layers = 1,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, two_sandboxes_with_ipv4) {
+	/* clang-format on */
+	.domain = AF_INET,
+	.num_layers = 2,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, three_sandboxes_with_ipv4) {
+	/* clang-format on */
+	.domain = AF_INET,
+	.num_layers = 3,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, no_sandbox_with_ipv6) {
+	/* clang-format on */
+	.domain = AF_INET6,
+	.num_layers = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, one_sandbox_with_ipv6) {
+	/* clang-format on */
+	.domain = AF_INET6,
+	.num_layers = 1,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, two_sandboxes_with_ipv6) {
+	/* clang-format on */
+	.domain = AF_INET6,
+	.num_layers = 2,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, three_sandboxes_with_ipv6) {
+	/* clang-format on */
+	.domain = AF_INET6,
+	.num_layers = 3,
+};
+
+TEST_F(tcp_layers, ruleset_overlap)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	const struct landlock_net_port_attr tcp_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = self->srv0.port,
+	};
+	const struct landlock_net_port_attr tcp_bind_connect = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->srv0.port,
+	};
+
+	if (variant->num_layers >= 1) {
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows bind. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind, 0));
+		/* Also allows bind, but allows connect too. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 2) {
+		int ruleset_fd;
+
+		/* Creates another ruleset layer. */
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Only allows bind. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 3) {
+		int ruleset_fd;
+
+		/* Creates another ruleset layer. */
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Try to allow bind and connect. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	/*
+	 * Forbids to connect to the socket because only one ruleset layer
+	 * allows connect.
+	 */
+	test_bind_and_connect(_metadata, &self->srv0, false,
+			      variant->num_layers >= 2);
+}
+
+TEST_F(tcp_layers, ruleset_expand)
+{
+	if (variant->num_layers >= 1) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+		};
+		/* Allows bind for srv0. */
+		const struct landlock_net_port_attr bind_srv0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = self->srv0.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &bind_srv0, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 2) {
+		/* Expands network mask with connect action. */
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		};
+		/* Allows bind for srv0 and connect to srv0. */
+		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = self->srv0.port,
+		};
+		/* Try to allow bind for srv1. */
+		const struct landlock_net_port_attr tcp_bind_p1 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = self->srv1.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect_p0, 0));
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_p1, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 3) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		};
+		/* Allows connect to srv0, without bind rule. */
+		const struct landlock_net_port_attr tcp_bind_p0 = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = self->srv0.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_p0, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	test_bind_and_connect(_metadata, &self->srv0, false,
+			      variant->num_layers >= 3);
+
+	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >= 1,
+			      variant->num_layers >= 2);
+}
+
+/* clang-format off */
+FIXTURE(mini) {};
+/* clang-format on */
+
+FIXTURE_SETUP(mini)
+{
+	disable_caps(_metadata);
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(mini)
+{
+}
+
+/* clang-format off */
+
+#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
+
+#define ACCESS_ALL ( \
+	LANDLOCK_ACCESS_NET_BIND_TCP | \
+	LANDLOCK_ACCESS_NET_CONNECT_TCP)
+
+/* clang-format on */
+
+TEST_F(mini, network_access_rights)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = ACCESS_ALL,
+	};
+	struct landlock_net_port_attr net_service = {
+		.port = sock_port_start,
+	};
+	int ruleset_fd;
+	__u64 access;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	for (access = 1; access <= ACCESS_LAST; access <<= 1) {
+		net_service.allowed_access = access;
+		EXPECT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &net_service, 0))
+		{
+			TH_LOG("Failed to add rule with access 0x%llx: %s",
+			       access, strerror(errno));
+		}
+	}
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
+/* Checks invalid attribute, out of landlock network access range. */
+TEST_F(mini, unknown_access_rights)
+{
+	__u64 access_mask;
+
+	for (access_mask = 1ULL << 63; access_mask != ACCESS_LAST;
+	     access_mask >>= 1) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = access_mask,
+		};
+
+		EXPECT_EQ(-1, landlock_create_ruleset(&ruleset_attr,
+						      sizeof(ruleset_attr), 0));
+		EXPECT_EQ(EINVAL, errno);
+	}
+}
+
+TEST_F(mini, inval)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
+	};
+	const struct landlock_net_port_attr tcp_bind_connect = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = sock_port_start,
+	};
+	const struct landlock_net_port_attr tcp_denied = {
+		.allowed_access = 0,
+		.port = sock_port_start,
+	};
+	const struct landlock_net_port_attr tcp_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = sock_port_start,
+	};
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Checks unhandled allowed_access. */
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&tcp_bind_connect, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	/* Checks zero access value. */
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&tcp_denied, 0));
+	EXPECT_EQ(ENOMSG, errno);
+
+	/* Adds with legitimate values. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &tcp_bind, 0));
+}
+
+TEST_F(mini, tcp_port_overflow)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	const struct landlock_net_port_attr port_max_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = UINT16_MAX,
+	};
+	const struct landlock_net_port_attr port_max_connect = {
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = UINT16_MAX,
+	};
+	const struct landlock_net_port_attr port_overflow1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = UINT16_MAX + 1,
+	};
+	const struct landlock_net_port_attr port_overflow2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = UINT16_MAX + 2,
+	};
+	const struct landlock_net_port_attr port_overflow3 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = UINT32_MAX + 1UL,
+	};
+	const struct landlock_net_port_attr port_overflow4 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = UINT32_MAX + 2UL,
+	};
+	const struct protocol_variant ipv4_tcp = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	};
+	struct service_fixture srv_denied, srv_max_allowed;
+	int ruleset_fd;
+
+	ASSERT_EQ(0, set_service(&srv_denied, ipv4_tcp, 0));
+
+	/* Be careful to avoid port inconsistencies. */
+	srv_max_allowed = srv_denied;
+	srv_max_allowed.port = port_max_bind.port;
+	srv_max_allowed.ipv4_addr.sin_port = htons(port_max_bind.port);
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &port_max_bind, 0));
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&port_overflow1, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&port_overflow2, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&port_overflow3, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	/* Interleaves with invalid rule additions. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &port_max_connect, 0));
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					&port_overflow4, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	test_bind_and_connect(_metadata, &srv_denied, true, true);
+	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
+}
+
+FIXTURE(ipv4_tcp)
+{
+	struct service_fixture srv0, srv1;
+};
+
+FIXTURE_SETUP(ipv4_tcp)
+{
+	const struct protocol_variant ipv4_tcp = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	};
+
+	disable_caps(_metadata);
+
+	ASSERT_EQ(0, set_service(&self->srv0, ipv4_tcp, 0));
+	ASSERT_EQ(0, set_service(&self->srv1, ipv4_tcp, 1));
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(ipv4_tcp)
+{
+}
+
+TEST_F(ipv4_tcp, port_endianness)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	const struct landlock_net_port_attr bind_host_endian_p0 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		/* Host port format. */
+		.port = self->srv0.port,
+	};
+	const struct landlock_net_port_attr connect_big_endian_p0 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		/* Big endian port format. */
+		.port = htons(self->srv0.port),
+	};
+	const struct landlock_net_port_attr bind_connect_host_endian_p1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		/* Host port format. */
+		.port = self->srv1.port,
+	};
+	const unsigned int one = 1;
+	const char little_endian = *(const char *)&one;
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &bind_host_endian_p0, 0));
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &connect_big_endian_p0, 0));
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &bind_connect_host_endian_p1, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* No restriction for big endinan CPU. */
+	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
+
+	/* No restriction for any CPU. */
+	test_bind_and_connect(_metadata, &self->srv1, false, false);
+}
+
+FIXTURE(port_zero)
+{
+	struct service_fixture srv0;
+};
+
+FIXTURE_VARIANT(port_zero)
+{
+	const enum sandbox_type sandbox;
+	const struct protocol_variant prot;
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(port_zero, no_sandbox_with_ipv4) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(port_zero, sandbox_with_ipv4) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(port_zero, no_sandbox_with_ipv6) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(port_zero, sandbox_with_ipv6) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+FIXTURE_SETUP(port_zero)
+{
+	disable_caps(_metadata);
+
+	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(port_zero)
+{
+}
+
+TEST_F(port_zero, bind_connect)
+{
+	int socket_fd, ret;
+
+	/* Adds the first rule layer with bind and connect actions. */
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP
+		};
+		const struct landlock_net_port_attr tcp_bind_connect = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = 0,
+		};
+
+		const struct landlock_net_port_attr tcp_connect = {
+			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.port = 0,
+		};
+
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Checks zero port value on bind and connect actions. */
+		EXPECT_EQ(-1,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_connect, 0));
+		EXPECT_EQ(EINVAL, errno);
+
+		/* Checks zero port value on the only connect action. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_connect, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	socket_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, socket_fd);
+
+	/* Set address port to 0 for both protocol families. */
+	self->srv0.ipv4_addr.sin_port = htons(0);
+	self->srv0.ipv6_addr.sin6_port = htons(0);
+
+	/* Bind on port 0. */
+	ret = bind_variant(socket_fd, &self->srv0);
+	if (is_restricted(&variant->prot, variant->sandbox)) {
+		/* Denied by Landlock. */
+		EXPECT_EQ(-EACCES, ret);
+	} else {
+		/* Binds to a random port within ip_local_port_range. */
+		EXPECT_EQ(0, ret);
+	}
+
+	/* Connect on port 0. */
+	ret = connect_variant(socket_fd, &self->srv0);
+	if (is_restricted(&variant->prot, variant->sandbox)) {
+		EXPECT_EQ(-ECONNREFUSED, ret);
+	} else {
+		EXPECT_EQ(-ECONNREFUSED, ret);
+	}
+
+	/* Adds the second rule layer with just bind action. */
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_CONNECT_TCP
+		};
+
+		const struct landlock_net_port_attr tcp_bind = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = sock_port_start,
+		};
+
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Adds with legitimate port value. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	/* Connect on port 0. */
+	ret = connect_variant(socket_fd, &self->srv0);
+	if (is_restricted(&variant->prot, variant->sandbox)) {
+		/* Denied by Landlock. */
+		EXPECT_EQ(-EACCES, ret);
+	} else {
+		EXPECT_EQ(-ECONNREFUSED, ret);
+	}
+
+	EXPECT_EQ(0, close(socket_fd));
+}
+
+TEST_HARNESS_MAIN
--
2.25.1

