Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7051CF7AD;
	Wed,  4 Sep 2024 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446924; cv=none; b=U4qShXxxhYMete+GvVIrhLKg3KofjmY0nKP8E6Sk3XVf5p4Hp4mDy+Z7ko9cGE4fHiBJrHiE2QVtaQotB5sVT/FkPOlPsl08mTnq7iljhCVHulTfIBSOLsxFYAGObi+UUPDYmVZnvbLD9pp3ofbPAIt0SOhW6HYqWdrKLvAKCuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446924; c=relaxed/simple;
	bh=xmSJBwy7F/nNdH3QFzvoVp49GKocm+0wpzPE0jnzqCM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUBvNBUx0iRxPZ7rJ8Elb0GY6BA18wFP1FmROWNwa32vkNaCWDVGGXKfVAgonizAGgR9k6PdAeJdzQaZsgh6BW5U8qC25IP20qp2lzX/Jpmk6YbC+nbPcBQP5n3lJ0Es9TRpMP7Wip8bxdLub/iLCJ0ixbxBjSd3IgJtP4XmLrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzJzW4k7Gz1HJ8t;
	Wed,  4 Sep 2024 18:45:11 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 22D691401E9;
	Wed,  4 Sep 2024 18:48:39 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:37 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 03/19] selftests/landlock: Test basic socket restriction
Date: Wed, 4 Sep 2024 18:48:08 +0800
Message-ID: <20240904104824.1844082-4-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Initiate socket_test.c selftests.

Add `protocol` fixture to test all possible family+type variants that
can be used to create user space socket. Add all options required by
this protocols in config. Support CAP_NET_RAW capability which is
required by some protocols.

Add simple socket access right checking test.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
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
 tools/testing/selftests/landlock/config       |  47 +++
 .../testing/selftests/landlock/socket_test.c  | 297 ++++++++++++++++++
 3 files changed, 345 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 7e2b431b9f90..28df49fa22d5 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -66,6 +66,7 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 		CAP_NET_BIND_SERVICE,
 		CAP_SYS_ADMIN,
 		CAP_SYS_CHROOT,
+		CAP_NET_RAW,
 		/* clang-format on */
 	};
 	const unsigned int noroot = SECBIT_NOROOT | SECBIT_NOROOT_LOCKED;
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 29af19c4e9f9..0b8e906ca59b 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -13,3 +13,50 @@ CONFIG_SHMEM=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
+
+#
+# Support of socket protocols for socket_test
+#
+CONFIG_AF_KCM=y
+CONFIG_AF_RXRPC=y
+CONFIG_ATALK=y
+CONFIG_ATM=y
+CONFIG_AX25=y
+CONFIG_BPF_SYSCALL=y
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
\ No newline at end of file
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
new file mode 100644
index 000000000000..63bb269c9d07
--- /dev/null
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Socket
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/landlock.h>
+#include <linux/pfkeyv2.h>
+#include <linux/kcm.h>
+#include <linux/can.h>
+#include <linux/in.h>
+#include <sys/prctl.h>
+
+#include "common.h"
+
+struct protocol_variant {
+	int family;
+	int type;
+	int protocol;
+};
+
+static int test_socket(int family, int type, int protocol)
+{
+	int fd;
+
+	fd = socket(family, type | SOCK_CLOEXEC, protocol);
+	if (fd < 0)
+		return errno;
+	/*
+	 * Mixing error codes from close(2) and socket(2) should not lead to any
+	 * (access type) confusion for this test.
+	 */
+	if (close(fd) != 0)
+		return errno;
+	return 0;
+}
+
+static int test_socket_variant(const struct protocol_variant *const prot)
+{
+	return test_socket(prot->family, prot->type, prot->protocol);
+}
+
+FIXTURE(protocol)
+{
+	struct protocol_variant prot;
+};
+
+FIXTURE_VARIANT(protocol)
+{
+	const struct protocol_variant prot;
+};
+
+FIXTURE_SETUP(protocol)
+{
+	disable_caps(_metadata);
+	self->prot = variant->prot;
+
+	/*
+	 * Some address families require this caps to be set
+	 * (e.g. AF_CAIF, AF_KEY).
+	 */
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	set_cap(_metadata, CAP_NET_ADMIN);
+	set_cap(_metadata, CAP_NET_RAW);
+};
+
+FIXTURE_TEARDOWN(protocol)
+{
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+	clear_cap(_metadata, CAP_NET_ADMIN);
+	clear_cap(_metadata, CAP_NET_RAW);
+}
+
+#define PROTOCOL_VARIANT_EXT_ADD(family_, type_, protocol_) \
+	FIXTURE_VARIANT_ADD(protocol, family_##_##type_)    \
+	{                                                   \
+		.prot = {                                   \
+			.family = AF_##family_,             \
+			.type = SOCK_##type_,               \
+			.protocol = protocol_,              \
+		},                                          \
+	}
+
+#define PROTOCOL_VARIANT_ADD(family, type) \
+	PROTOCOL_VARIANT_EXT_ADD(family, type, 0)
+
+/*
+ * Every protocol that can be used to create socket using create() method
+ * of net_proto_family structure is tested (e.g. this method is used to
+ * create socket with socket(2)).
+ *
+ * List of address families that are not tested:
+ * - AF_ASH, AF_SNA, AF_WANPIPE, AF_NETBEUI, AF_IPX, AF_DECNET, AF_ECONET
+ *   and AF_IRDA are not implemented in kernel.
+ * - AF_BRIDGE, AF_MPLS can't be used for creating sockets.
+ * - AF_SECURITY - pseudo AF (Cf. socket.h).
+ * - AF_IB is reserved by infiniband.
+ */
+
+/* Cf. unix_create */
+PROTOCOL_VARIANT_ADD(UNIX, STREAM);
+PROTOCOL_VARIANT_ADD(UNIX, RAW);
+PROTOCOL_VARIANT_ADD(UNIX, DGRAM);
+PROTOCOL_VARIANT_ADD(UNIX, SEQPACKET);
+
+/* Cf. inet_create */
+PROTOCOL_VARIANT_ADD(INET, STREAM);
+PROTOCOL_VARIANT_ADD(INET, DGRAM);
+PROTOCOL_VARIANT_EXT_ADD(INET, RAW, IPPROTO_TCP);
+PROTOCOL_VARIANT_EXT_ADD(INET, SEQPACKET, IPPROTO_SCTP);
+
+/* Cf. ax25_create */
+PROTOCOL_VARIANT_ADD(AX25, DGRAM);
+PROTOCOL_VARIANT_ADD(AX25, SEQPACKET);
+PROTOCOL_VARIANT_ADD(AX25, RAW);
+
+/* Cf. atalk_create */
+PROTOCOL_VARIANT_ADD(APPLETALK, RAW);
+PROTOCOL_VARIANT_ADD(APPLETALK, DGRAM);
+
+/* Cf. nr_create */
+PROTOCOL_VARIANT_ADD(NETROM, SEQPACKET);
+
+/* Cf. pvc_create */
+PROTOCOL_VARIANT_ADD(ATMPVC, DGRAM);
+PROTOCOL_VARIANT_ADD(ATMPVC, RAW);
+PROTOCOL_VARIANT_ADD(ATMPVC, RDM);
+PROTOCOL_VARIANT_ADD(ATMPVC, SEQPACKET);
+PROTOCOL_VARIANT_ADD(ATMPVC, DCCP);
+PROTOCOL_VARIANT_ADD(ATMPVC, PACKET);
+
+/* Cf. x25_create */
+PROTOCOL_VARIANT_ADD(X25, SEQPACKET);
+
+/* Cf. inet6_create */
+PROTOCOL_VARIANT_ADD(INET6, STREAM);
+PROTOCOL_VARIANT_ADD(INET6, DGRAM);
+PROTOCOL_VARIANT_EXT_ADD(INET6, RAW, IPPROTO_TCP);
+
+/* Cf. rose_create */
+PROTOCOL_VARIANT_ADD(ROSE, SEQPACKET);
+
+/* Cf. pfkey_create */
+PROTOCOL_VARIANT_EXT_ADD(KEY, RAW, PF_KEY_V2);
+
+/* Cf. netlink_create */
+PROTOCOL_VARIANT_ADD(NETLINK, RAW);
+PROTOCOL_VARIANT_ADD(NETLINK, DGRAM);
+
+/* Cf. packet_create */
+PROTOCOL_VARIANT_ADD(PACKET, DGRAM);
+PROTOCOL_VARIANT_ADD(PACKET, RAW);
+PROTOCOL_VARIANT_ADD(PACKET, PACKET);
+
+/* Cf. svc_create */
+PROTOCOL_VARIANT_ADD(ATMSVC, DGRAM);
+PROTOCOL_VARIANT_ADD(ATMSVC, RAW);
+PROTOCOL_VARIANT_ADD(ATMSVC, RDM);
+PROTOCOL_VARIANT_ADD(ATMSVC, SEQPACKET);
+PROTOCOL_VARIANT_ADD(ATMSVC, DCCP);
+PROTOCOL_VARIANT_ADD(ATMSVC, PACKET);
+
+/* Cf. rds_create */
+PROTOCOL_VARIANT_ADD(RDS, SEQPACKET);
+
+/* Cf. pppox_create + pppoe_create */
+PROTOCOL_VARIANT_ADD(PPPOX, STREAM);
+PROTOCOL_VARIANT_ADD(PPPOX, DGRAM);
+PROTOCOL_VARIANT_ADD(PPPOX, RAW);
+PROTOCOL_VARIANT_ADD(PPPOX, RDM);
+PROTOCOL_VARIANT_ADD(PPPOX, SEQPACKET);
+PROTOCOL_VARIANT_ADD(PPPOX, DCCP);
+PROTOCOL_VARIANT_ADD(PPPOX, PACKET);
+
+/* Cf. llc_ui_create */
+PROTOCOL_VARIANT_ADD(LLC, DGRAM);
+PROTOCOL_VARIANT_ADD(LLC, STREAM);
+
+/* Cf. can_create */
+PROTOCOL_VARIANT_EXT_ADD(CAN, DGRAM, CAN_BCM);
+
+/* Cf. tipc_sk_create */
+PROTOCOL_VARIANT_ADD(TIPC, STREAM);
+PROTOCOL_VARIANT_ADD(TIPC, SEQPACKET);
+PROTOCOL_VARIANT_ADD(TIPC, DGRAM);
+PROTOCOL_VARIANT_ADD(TIPC, RDM);
+
+/* Cf. l2cap_sock_create */
+#ifndef __s390x__
+PROTOCOL_VARIANT_ADD(BLUETOOTH, SEQPACKET);
+PROTOCOL_VARIANT_ADD(BLUETOOTH, STREAM);
+PROTOCOL_VARIANT_ADD(BLUETOOTH, DGRAM);
+PROTOCOL_VARIANT_ADD(BLUETOOTH, RAW);
+#endif
+
+/* Cf. iucv_sock_create */
+#ifdef __s390x__
+PROTOCOL_VARIANT_ADD(IUCV, STREAM);
+PROTOCOL_VARIANT_ADD(IUCV, SEQPACKET);
+#endif
+
+/* Cf. rxrpc_create */
+PROTOCOL_VARIANT_EXT_ADD(RXRPC, DGRAM, PF_INET);
+
+/* Cf. mISDN_sock_create */
+#define ISDN_P_BASE 0 /* Cf. linux/mISDNif.h */
+#define ISDN_P_TE_S0 0x01 /* Cf. linux/mISDNif.h */
+PROTOCOL_VARIANT_EXT_ADD(ISDN, RAW, ISDN_P_BASE);
+PROTOCOL_VARIANT_EXT_ADD(ISDN, DGRAM, ISDN_P_TE_S0);
+
+/* Cf. pn_socket_create */
+PROTOCOL_VARIANT_ADD(PHONET, DGRAM);
+PROTOCOL_VARIANT_ADD(PHONET, SEQPACKET);
+
+/* Cf. ieee802154_create */
+PROTOCOL_VARIANT_ADD(IEEE802154, RAW);
+PROTOCOL_VARIANT_ADD(IEEE802154, DGRAM);
+
+/* Cf. caif_create */
+PROTOCOL_VARIANT_ADD(CAIF, SEQPACKET);
+PROTOCOL_VARIANT_ADD(CAIF, STREAM);
+
+/* Cf. alg_create */
+PROTOCOL_VARIANT_ADD(ALG, SEQPACKET);
+
+/* Cf. nfc_sock_create + rawsock_create */
+PROTOCOL_VARIANT_ADD(NFC, SEQPACKET);
+
+/* Cf. vsock_create */
+#if defined(__x86_64__) || defined(__aarch64__)
+PROTOCOL_VARIANT_ADD(VSOCK, DGRAM);
+PROTOCOL_VARIANT_ADD(VSOCK, STREAM);
+PROTOCOL_VARIANT_ADD(VSOCK, SEQPACKET);
+#endif
+
+/* Cf. kcm_create */
+PROTOCOL_VARIANT_EXT_ADD(KCM, DGRAM, KCMPROTO_CONNECTED);
+PROTOCOL_VARIANT_EXT_ADD(KCM, SEQPACKET, KCMPROTO_CONNECTED);
+
+/* Cf. qrtr_create */
+PROTOCOL_VARIANT_ADD(QIPCRTR, DGRAM);
+
+/* Cf. smc_create */
+#ifndef __alpha__
+PROTOCOL_VARIANT_ADD(SMC, STREAM);
+#endif
+
+/* Cf. xsk_create */
+PROTOCOL_VARIANT_ADD(XDP, RAW);
+
+/* Cf. mctp_pf_create */
+PROTOCOL_VARIANT_ADD(MCTP, DGRAM);
+
+TEST_F(protocol, create)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->prot.family,
+		.type = self->prot.type,
+	};
+	int ruleset_fd;
+
+	/* Tries to create a socket when ruleset is not established. */
+	ASSERT_EQ(0, test_socket_variant(&self->prot));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_attr, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocol is allowed. */
+	EXPECT_EQ(0, test_socket_variant(&self->prot));
+
+	/* Denied create. */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocol is restricted. */
+	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

