Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF915313525;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473633; cv=none; b=rNJLHMtWW9khuu2SkNGmqsWn+fpA0LK23L4wvxDVV1uQrs2GGW9V7FNuwE4etr5H5buZZf4wLm2UXYfBllu//7RfPsjqGRer4rQuCrk9jGn4oNxD05NOYDHBf1iQ3oyWRbLpUe2UpaL1FmneG1CsVGLzdwTNtBtN4bQJ0iWFFNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473633; c=relaxed/simple;
	bh=4zvGLi55x0SUY12v0h+iKi2I4D1H071X4QymKlPoKh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZseYOZye/TPgPLsl6Oql/JsLmHFareqIJXNcaJZpcG5g1SCiBWEp9I59DKu9Kdz+5w9bXAK+X4zDOJKj9AyK0qQZ/uP+UDu6DzqVjh0dFsTbgA1lk367fl/t4KH04zZ92ljpSeV3/goHzcLmsRCcGy57pBSIeauwaCjixaOZl5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9W2vVQzJ46c2;
	Tue, 18 Nov 2025 21:46:23 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id B0CED140277;
	Tue, 18 Nov 2025 21:47:05 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:05 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 07/19] selftests/landlock: Test basic socket restriction
Date: Tue, 18 Nov 2025 21:46:27 +0800
Message-ID: <20251118134639.3314803-8-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add `protocol` fixture to test biggest part of communication protocol
variants. Add config options required to create sockets for each of these
protocols. Support CAP_NET_RAW capability which is required by some
of the tested protocols.

Add protocols_define.h file containing definitions of tested protocols.

Add test that validates Landlock ability to control creation of sockets
via socket(2) syscall.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Removes some of the protocols from testing (SMC, KMC and XDP).
* Rewrites commit description.
* Changes test name to "restrict_socket_creation".
* Minor changes.

Changes since v2:
* Extends variants of `protocol` fixture with every socket protocol
  that can be used to create user space sockets.
* Adds `SYS_ADMIN`, `NET_ADMIN` and `NET_RAW` capabilities required for
  some socket protocols.
* Removes network namespace creation in `protocol` fixture setup.
  Sockets of some protocols can be created only in initial network
  namespace. This shouldn't cause any issues until `protocol` fixture
  is used in connection or binding tests.
* Extends config file with a set of options required by socket protocols.
* Adds CAP_NET_RAW capability to landlock selftests which is required
  to create sockets of some protocols.
* Adds protocol field to the `protocol` fixture.
* Adds test_socket_variant() helper and changes the signature of
  test_socket() helper.
* Checks socket(2) when ruleset is not established.
* Removes checks for AF_UNSPEC. This is moved to unsupported_af_and_prot
  test.
* Removes `service_fixture` struct.
* Minor fixes.
* Refactors commit message and title.

Changes since v1:
* Replaces test_socket_create() and socket_variant() helpers
with test_socket().
* Renames domain to family in protocol fixture.
* Remove AF_UNSPEC fixture entry and add unspec_srv0 fixture field to
check AF_UNSPEC socket creation case.
* Formats code with clang-format.
* Refactors commit message.
---
 tools/testing/selftests/landlock/common.h     |   1 +
 tools/testing/selftests/landlock/config       |  47 +++++
 .../selftests/landlock/protocols_define.h     | 169 ++++++++++++++++++
 .../testing/selftests/landlock/socket_test.c  | 132 ++++++++++++++
 4 files changed, 349 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/protocols_define.h

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 88a3c78f5d98..e9378a229a4c 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -47,6 +47,7 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 		CAP_SETUID,
 		CAP_SYS_ADMIN,
 		CAP_SYS_CHROOT,
+		CAP_NET_RAW,
 		/* clang-format on */
 	};
 	const unsigned int noroot = SECBIT_NOROOT | SECBIT_NOROOT_LOCKED;
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 8fe9b461b1fd..98b3996c36a8 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -17,3 +17,50 @@ CONFIG_SHMEM=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
+
+#
+# Support of socket protocols for socket_test
+#
+CONFIG_AF_RXRPC=y
+CONFIG_ATALK=y
+CONFIG_ATM=y
+CONFIG_AX25=y
+CONFIG_BT=y
+CONFIG_CAIF=y
+CONFIG_CAN_BCM=y
+CONFIG_CAN=y
+CONFIG_CRYPTO_USER_API_AEAD=y
+CONFIG_CRYPTO=y
+CONFIG_HAMRADIO=y
+CONFIG_IEEE802154_SOCKET=y
+CONFIG_IEEE802154=y
+CONFIG_INET=y
+CONFIG_INFINIBAND=y
+CONFIG_IP_SCTP=y
+CONFIG_ISDN=y
+CONFIG_LLC2=y
+CONFIG_LLC=y
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
+CONFIG_MCTP=y
+CONFIG_MISDN=y
+CONFIG_NETDEVICES=y
+CONFIG_NET_KEY=y
+CONFIG_NETROM=y
+CONFIG_NFC=y
+CONFIG_PACKET=y
+CONFIG_PCI=y
+CONFIG_PHONET=y
+CONFIG_PPPOE=y
+CONFIG_PPP=y
+CONFIG_QRTR=y
+CONFIG_RDS=y
+CONFIG_ROSE=y
+CONFIG_SMC=y
+CONFIG_TIPC=y
+CONFIG_UNIX=y
+CONFIG_VMWARE_VMCI_VSOCKETS=y
+CONFIG_VMWARE_VMCI=y
+CONFIG_VSOCKETS=y
+CONFIG_X25=y
+CONFIG_XDP_SOCKETS=y
diff --git a/tools/testing/selftests/landlock/protocols_define.h b/tools/testing/selftests/landlock/protocols_define.h
new file mode 100644
index 000000000000..e44d2278d289
--- /dev/null
+++ b/tools/testing/selftests/landlock/protocols_define.h
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Tested socket protocols definitions
+ *
+ * Copyright © 2025 Huawei Tech. Co., Ltd.
+ */
+
+/* Almost every protocol that can be used to create socket using create() method
+ * of net_proto_family structure is tested (e.g. this method is used to
+ * create socket with socket(2)).
+ *
+ * List of address families that are not tested:
+ * - Protocol families requiring CAP_SYS_ADMIN or CAP_NET_RAW (eg. AF_PACKET,
+ *   AF_CAIF).
+ * - AF_SMC, AF_KMC, AF_XDP.
+ * - AF_ASH, AF_SNA, AF_WANPIPE, AF_NETBEUI, AF_IPX, AF_DECNET, AF_ECONET
+ *   and AF_IRDA are not implemented in kernel.
+ * - AF_BRIDGE, AF_MPLS can't be used for creating sockets.
+ * - AF_SECURITY - pseudo AF (Cf. socket.h).
+ * - AF_IB is reserved by infiniband.
+ */
+
+/* Cf. unix_create */
+PROTOCOL_VARIANT_ADD(UNIX, STREAM, 0);
+PROTOCOL_VARIANT_ADD(UNIX, RAW, 0);
+PROTOCOL_VARIANT_ADD(UNIX, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(UNIX, SEQPACKET, 0);
+
+/* Cf. inet_create */
+PROTOCOL_VARIANT_ADD(INET, STREAM, 0);
+PROTOCOL_VARIANT_ADD(INET, STREAM, IPPROTO_TCP);
+PROTOCOL_VARIANT_ADD(INET, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(INET, DGRAM, IPPROTO_UDP);
+PROTOCOL_VARIANT_ADD_CAPS(INET, RAW, IPPROTO_TCP);
+PROTOCOL_VARIANT_ADD(INET, SEQPACKET, IPPROTO_SCTP);
+PROTOCOL_VARIANT_ADD(INET, STREAM, IPPROTO_MPTCP);
+
+/* Cf. ax25_create */
+PROTOCOL_VARIANT_ADD(AX25, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(AX25, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD_CAPS(AX25, RAW, 0);
+
+/* Cf. atalk_create */
+PROTOCOL_VARIANT_ADD_CAPS(APPLETALK, RAW, 0);
+PROTOCOL_VARIANT_ADD(APPLETALK, DGRAM, 0);
+
+/* Cf. nr_create */
+PROTOCOL_VARIANT_ADD(NETROM, SEQPACKET, 0);
+
+/* Cf. pvc_create */
+PROTOCOL_VARIANT_ADD(ATMPVC, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(ATMPVC, RAW, 0);
+PROTOCOL_VARIANT_ADD(ATMPVC, RDM, 0);
+PROTOCOL_VARIANT_ADD(ATMPVC, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD(ATMPVC, DCCP, 0);
+PROTOCOL_VARIANT_ADD(ATMPVC, PACKET, 0);
+
+/* Cf. x25_create */
+PROTOCOL_VARIANT_ADD(X25, SEQPACKET, 0);
+
+/* Cf. inet6_create */
+PROTOCOL_VARIANT_ADD(INET6, STREAM, 0);
+PROTOCOL_VARIANT_ADD(INET6, STREAM, IPPROTO_TCP);
+PROTOCOL_VARIANT_ADD(INET6, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(INET6, DGRAM, IPPROTO_UDP);
+PROTOCOL_VARIANT_ADD_CAPS(INET6, RAW, IPPROTO_TCP);
+PROTOCOL_VARIANT_ADD(INET6, SEQPACKET, IPPROTO_SCTP);
+PROTOCOL_VARIANT_ADD(INET6, STREAM, IPPROTO_MPTCP);
+
+/* Cf. rose_create */
+PROTOCOL_VARIANT_ADD(ROSE, SEQPACKET, 0);
+
+/* Cf. pfkey_create */
+PROTOCOL_VARIANT_ADD_CAPS(KEY, RAW, PF_KEY_V2);
+
+/* Cf. netlink_create */
+PROTOCOL_VARIANT_ADD(NETLINK, RAW, 0);
+PROTOCOL_VARIANT_ADD(NETLINK, DGRAM, 0);
+
+/* Cf. packet_create */
+PROTOCOL_VARIANT_ADD_CAPS(PACKET, DGRAM, 0);
+PROTOCOL_VARIANT_ADD_CAPS(PACKET, RAW, 0);
+PROTOCOL_VARIANT_ADD_CAPS(PACKET, PACKET, 0);
+
+/* Cf. svc_create */
+PROTOCOL_VARIANT_ADD(ATMSVC, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(ATMSVC, RAW, 0);
+PROTOCOL_VARIANT_ADD(ATMSVC, RDM, 0);
+PROTOCOL_VARIANT_ADD(ATMSVC, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD(ATMSVC, DCCP, 0);
+PROTOCOL_VARIANT_ADD(ATMSVC, PACKET, 0);
+
+/* Cf. rds_create */
+PROTOCOL_VARIANT_ADD(RDS, SEQPACKET, 0);
+
+/* Cf. pppox_create + pppoe_create */
+PROTOCOL_VARIANT_ADD(PPPOX, STREAM, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, RAW, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, RDM, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, DCCP, 0);
+PROTOCOL_VARIANT_ADD(PPPOX, PACKET, 0);
+
+/* Cf. llc_ui_create */
+PROTOCOL_VARIANT_ADD_CAPS(LLC, DGRAM, 0);
+PROTOCOL_VARIANT_ADD_CAPS(LLC, STREAM, 0);
+
+/* Cf. can_create */
+PROTOCOL_VARIANT_ADD(CAN, DGRAM, CAN_BCM);
+
+/* Cf. tipc_sk_create */
+PROTOCOL_VARIANT_ADD(TIPC, STREAM, 0);
+PROTOCOL_VARIANT_ADD(TIPC, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD(TIPC, DGRAM, 0);
+PROTOCOL_VARIANT_ADD(TIPC, RDM, 0);
+
+/* Cf. l2cap_sock_create */
+#ifndef __s390x__
+PROTOCOL_VARIANT_ADD(BLUETOOTH, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD(BLUETOOTH, STREAM, 0);
+PROTOCOL_VARIANT_ADD(BLUETOOTH, DGRAM, 0);
+PROTOCOL_VARIANT_ADD_CAPS(BLUETOOTH, RAW, 0);
+#endif
+
+/* Cf. iucv_sock_create */
+#ifdef __s390x__
+PROTOCOL_VARIANT_ADD(IUCV, STREAM, 0);
+PROTOCOL_VARIANT_ADD(IUCV, SEQPACKET, 0);
+#endif
+
+/* Cf. rxrpc_create */
+PROTOCOL_VARIANT_ADD(RXRPC, DGRAM, PF_INET);
+
+/* Cf. mISDN_sock_create */
+#define ISDN_P_BASE 0 /* Cf. linux/mISDNif.h */
+#define ISDN_P_TE_S0 0x01 /* Cf. linux/mISDNif.h */
+PROTOCOL_VARIANT_ADD_CAPS(ISDN, RAW, ISDN_P_BASE);
+PROTOCOL_VARIANT_ADD(ISDN, DGRAM, ISDN_P_TE_S0);
+
+/* Cf. pn_socket_create */
+PROTOCOL_VARIANT_ADD_CAPS(PHONET, DGRAM, 0);
+PROTOCOL_VARIANT_ADD_CAPS(PHONET, SEQPACKET, 0);
+
+/* Cf. ieee802154_create */
+PROTOCOL_VARIANT_ADD_CAPS(IEEE802154, RAW, 0);
+PROTOCOL_VARIANT_ADD(IEEE802154, DGRAM, 0);
+
+/* Cf. caif_create */
+PROTOCOL_VARIANT_ADD_CAPS(CAIF, SEQPACKET, 0);
+PROTOCOL_VARIANT_ADD_CAPS(CAIF, STREAM, 0);
+
+/* Cf. alg_create */
+PROTOCOL_VARIANT_ADD(ALG, SEQPACKET, 0);
+
+/* Cf. nfc_sock_create + rawsock_create */
+PROTOCOL_VARIANT_ADD(NFC, SEQPACKET, 0);
+
+/* Cf. vsock_create */
+#if defined(__x86_64__) || defined(__aarch64__)
+PROTOCOL_VARIANT_ADD(VSOCK, STREAM, 0);
+PROTOCOL_VARIANT_ADD(VSOCK, SEQPACKET, 0);
+#endif
+
+/* Cf. qrtr_create */
+PROTOCOL_VARIANT_ADD(QIPCRTR, DGRAM, 0);
+
+/* Cf. mctp_pf_create */
+PROTOCOL_VARIANT_ADD(MCTP, DGRAM, 0);
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 16477614dfed..1b6c709d2893 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -9,6 +9,9 @@
 
 #include <linux/landlock.h>
 #include <sys/prctl.h>
+#include <linux/pfkeyv2.h>
+#include <linux/kcm.h>
+#include <linux/can.h>
 
 #include "common.h"
 
@@ -379,4 +382,133 @@ TEST_F(prot_outside_range, add_rule)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+FIXTURE(protocol)
+{
+	struct protocol_variant prot;
+	bool requires_caps;
+};
+
+FIXTURE_VARIANT(protocol)
+{
+	struct protocol_variant prot;
+	bool requires_caps;
+};
+
+FIXTURE_SETUP(protocol)
+{
+	disable_caps(_metadata);
+
+	self->prot = variant->prot;
+	self->requires_caps = variant->requires_caps;
+};
+
+FIXTURE_TEARDOWN(protocol)
+{
+}
+
+#define _PROTOCOL_VARIANT_ADD(family_, type_, protocol_, caps_)          \
+	FIXTURE_VARIANT_ADD(protocol, family_##_##type_##_##protocol_)   \
+	{                                                                \
+		.prot = {                                              \
+			.domain = AF_##family_,                             \
+			.type = SOCK_##type_,                                 \
+			.protocol = protocol_,                         \
+		},                                                     \
+		.requires_caps = caps_, \
+	}
+
+#define PROTOCOL_VARIANT_ADD(family, type, protocol) \
+	_PROTOCOL_VARIANT_ADD(family, type, protocol, false)
+
+#define PROTOCOL_VARIANT_ADD_CAPS(family, type, protocol) \
+	_PROTOCOL_VARIANT_ADD(family, type, protocol, true)
+
+#include "protocols_define.h"
+
+#undef _PROTOCOL_VARIANT_ADD
+#undef PROTOCOL_VARIANT_ADD
+#undef PROTOCOL_VARIANT_ADD_CAPS
+
+static int test_socket(int family, int type, int protocol)
+{
+	int fd;
+
+	fd = socket(family, type | SOCK_CLOEXEC, protocol);
+	if (fd < 0)
+		return errno;
+	/*
+	 * Mixing error codes from close(2) and socket(2) should not lead to
+	 * any (access type) confusion for this tests.
+	 */
+	if (close(fd) != 0)
+		return errno;
+	return 0;
+}
+
+static int test_socket_variant(struct __test_metadata *const _metadata,
+			       const struct protocol_variant *const prot,
+			       bool requires_caps)
+{
+	int err;
+
+	if (requires_caps) {
+		set_cap(_metadata, CAP_NET_RAW);
+		set_cap(_metadata, CAP_SYS_ADMIN);
+		set_cap(_metadata, CAP_NET_ADMIN);
+	}
+
+	err = test_socket(prot->domain, prot->type, prot->protocol);
+
+	if (requires_caps) {
+		clear_cap(_metadata, CAP_NET_RAW);
+		clear_cap(_metadata, CAP_SYS_ADMIN);
+		clear_cap(_metadata, CAP_NET_ADMIN);
+	}
+
+	return err;
+}
+
+TEST_F(protocol, restrict_socket)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	int ruleset_fd;
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->prot.domain,
+		.type = self->prot.type,
+		.protocol = self->prot.protocol,
+	};
+
+	/* Verifies default socket creation. */
+	ASSERT_EQ(0, test_socket_variant(_metadata, &self->prot,
+					 self->requires_caps));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_attr, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create socket when protocol is allowed. */
+	EXPECT_EQ(0, test_socket_variant(_metadata, &self->prot,
+					 self->requires_caps));
+
+	/* Denies creation. */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocol is restricted. */
+	EXPECT_EQ(EACCES, test_socket_variant(_metadata, &self->prot,
+					      self->requires_caps));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

