Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375017BB01
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961997; cv=none; b=arq+Udr8UPwlEL2rA5POcMU0dU57nofMfU7/s5C7D+xZ/ScRZBrDWEbXwtbPISjL8WfuAtD84nv25AImSCZ8ljECSWLS2uZpOrJa/M7VAxVxCjpBZ5WCT4+d4dDWtmF2BZwCikmulS9pJOVHXeGcCxA+bpnJ7qKR51BJkSe0L1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961997; c=relaxed/simple;
	bh=81gq+otx7jHu7AOWySHvV2Tcky0fjerGRHuesV+TGts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TcFsDl0cUoArNgK+keKB/0sm/VGKBeaJgXYV5cfUHYd5TfedE9spGlUoWuxoYqDMRsT6A0VUKc7lLmi5xEvgI9NXrWlwTB6lhl5BbNWjaJm0jQfJ4+dqu7RP4hUx7Hx3T1D5cgN8hJzIdaGDsPsE4CbudX/vgW85gunFpqpQxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLzDofea; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLzDofea"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6db7a8c6910so57420847b3.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 02:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725961994; x=1726566794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EMz5B/4IJ1lXNGYRccROAw8/P8DjxPhP/Sf9/WYgr9Q=;
        b=WLzDofeaer6qGGkeP06PBcF4J84OkBeoKkMAeKrtgkOBZahSLyzYKwOqXfod1yMQZC
         9OdfxtL2zjl701rtxMD9OA8BAdm+lhj3R62L1N/DaHMAvFNvqs2XYEAfPhguyc43wJ0k
         cvqR7P7vRbgpwun6Z1WD+0TYYvhC70FZLJDVFzvdhSyWjHE3liNfqaXotD/7gNKuBbmp
         2P23se/qtFT400kFqFpw/VSPcS8A8n90A2v+9i0asji/hjN/lnceooSOGL8VA8W2WmC9
         EhZW/q7DRIDPiHrneQDe4H2bZaOID4ffWK/D3PqIoaA80HSjCo/baUCrBMPCrbQ/XptL
         qUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725961994; x=1726566794;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EMz5B/4IJ1lXNGYRccROAw8/P8DjxPhP/Sf9/WYgr9Q=;
        b=fYvoCGrjPJGeePbaVMhNo7R52nvmibDOH3hAMAQYs0WSLWpDAVktoOGWf81sR+PJXU
         s4UQD6xHjInQxxdfo8LoncWSD4Hb+hk2tTkuK06VTZVv4WH1Sb7+V3kxe/tOq/Qfsq7K
         AMX33wT3G6woQf7InrrfVXU/ytkHhzKb9ORcRaKwY7N2/0zyeiBHEj/H9wviPvmG4BQh
         imk6iMk7paNvhaLO6wio/+rntePySo3Bnn3kPclzyJHaOHcW+CrqUxW/cHzmZyYD+UFM
         zFqspBFlr/ds0NpuOR5dFRR2MZDqnztEy7a56ZW/pjbjKcfYpM0q+9NQRs7viajq2R7r
         81Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUqkxPVpTgUnhdzjlcjCwFjY3x8gqOnx9dZ5zXs2wfNe5AR+y8r/SpSV/UMfLc7oYHgRre1y0UqvpylZ0ghK78=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmL01a6k0Cq81DQ5ASHpwoWHbYFgjP3S/MNwTrQiePPUQ4Xk+8
	pQnBbpdJw4vYKHn5DgM5k/2/7DJJlMtabusw2umVYd0F3kqLbiXx4CBgoNRE6CrXl3k/0oRoE3L
	mOg==
X-Google-Smtp-Source: AGHT+IFp31mybrwSeyiZyjxrPm9wvhsdcCO1CpSJ7vKq+U2FvdT+YuHJauCLW4TelV5BwIOTdj/XRrdhEfw=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:1549:b0:e17:c4c5:bcb2 with SMTP id
 3f1490d57ef6-e1d34a16ab6mr359884276.7.1725961994133; Tue, 10 Sep 2024
 02:53:14 -0700 (PDT)
Date: Tue, 10 Sep 2024 11:53:11 +0200
In-Reply-To: <20240904104824.1844082-4-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-4-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZuAXB6wTd-neVYao@google.com>
Subject: Re: [RFC PATCH v3 03/19] selftests/landlock: Test basic socket restriction
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024 at 06:48:08PM +0800, Mikhail Ivanov wrote:
> Initiate socket_test.c selftests.
>=20
> Add `protocol` fixture to test all possible family+type variants that
> can be used to create user space socket. Add all options required by
> this protocols in config. Support CAP_NET_RAW capability which is
> required by some protocols.
>=20
> Add simple socket access right checking test.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> Changes since v2:
> * Extends variants of `protocol` fixture with every socket protocol
>   that can be used to create user space sockets.
> * Adds `SYS_ADMIN`, `NET_ADMIN` and `NET_RAW` capabilities required for
>   some socket protocols.
> * Removes network namespace creation in `protocol` fixture setup.
>   Sockets of some protocols can be created only in initial network
>   namespace. This shouldn't cause any issues until `protocol` fixture
>   is used in connection or binding tests.
> * Extends config file with a set of options required by socket protocols.
> * Adds CAP_NET_RAW capability to landlock selftests which is required
>   to create sockets of some protocols.
> * Adds protocol field to the `protocol` fixture.
> * Adds test_socket_variant() helper and changes the signature of
>   test_socket() helper.
> * Checks socket(2) when ruleset is not established.
> * Removes checks for AF_UNSPEC. This is moved to unsupported_af_and_prot
>   test.
> * Removes `service_fixture` struct.
> * Minor fixes.
> * Refactors commit message and title.
>=20
> Changes since v1:
> * Replaces test_socket_create() and socket_variant() helpers
>   with test_socket().
> * Renames domain to family in protocol fixture.
> * Remove AF_UNSPEC fixture entry and add unspec_srv0 fixture field to
>   check AF_UNSPEC socket creation case.
> * Formats code with clang-format.
> * Refactors commit message.
> ---
>  tools/testing/selftests/landlock/common.h     |   1 +
>  tools/testing/selftests/landlock/config       |  47 +++
>  .../testing/selftests/landlock/socket_test.c  | 297 ++++++++++++++++++
>  3 files changed, 345 insertions(+)
>  create mode 100644 tools/testing/selftests/landlock/socket_test.c
>=20
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/se=
lftests/landlock/common.h
> index 7e2b431b9f90..28df49fa22d5 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -66,6 +66,7 @@ static void _init_caps(struct __test_metadata *const _m=
etadata, bool drop_all)
>  		CAP_NET_BIND_SERVICE,
>  		CAP_SYS_ADMIN,
>  		CAP_SYS_CHROOT,
> +		CAP_NET_RAW,
>  		/* clang-format on */
>  	};
>  	const unsigned int noroot =3D SECBIT_NOROOT | SECBIT_NOROOT_LOCKED;
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/self=
tests/landlock/config
> index 29af19c4e9f9..0b8e906ca59b 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -13,3 +13,50 @@ CONFIG_SHMEM=3Dy
>  CONFIG_SYSFS=3Dy
>  CONFIG_TMPFS=3Dy
>  CONFIG_TMPFS_XATTR=3Dy
> +
> +#
> +# Support of socket protocols for socket_test
> +#
> +CONFIG_AF_KCM=3Dy
> +CONFIG_AF_RXRPC=3Dy
> +CONFIG_ATALK=3Dy
> +CONFIG_ATM=3Dy
> +CONFIG_AX25=3Dy
> +CONFIG_BPF_SYSCALL=3Dy
> +CONFIG_BT=3Dy
> +CONFIG_CAIF=3Dy
> +CONFIG_CAN_BCM=3Dy
> +CONFIG_CAN=3Dy
> +CONFIG_CRYPTO_USER_API_AEAD=3Dy
> +CONFIG_CRYPTO=3Dy
> +CONFIG_HAMRADIO=3Dy
> +CONFIG_IEEE802154_SOCKET=3Dy
> +CONFIG_IEEE802154=3Dy
> +CONFIG_INET=3Dy
> +CONFIG_INFINIBAND=3Dy
> +CONFIG_IP_SCTP=3Dy
> +CONFIG_ISDN=3Dy
> +CONFIG_LLC2=3Dy
> +CONFIG_LLC=3Dy
> +CONFIG_MCTP=3Dy
> +CONFIG_MISDN=3Dy
> +CONFIG_NETDEVICES=3Dy
> +CONFIG_NET_KEY=3Dy
> +CONFIG_NETROM=3Dy
> +CONFIG_NFC=3Dy
> +CONFIG_PACKET=3Dy
> +CONFIG_PCI=3Dy
> +CONFIG_PHONET=3Dy
> +CONFIG_PPPOE=3Dy
> +CONFIG_PPP=3Dy
> +CONFIG_QRTR=3Dy
> +CONFIG_RDS=3Dy
> +CONFIG_ROSE=3Dy
> +CONFIG_SMC=3Dy
> +CONFIG_TIPC=3Dy
> +CONFIG_UNIX=3Dy
> +CONFIG_VMWARE_VMCI_VSOCKETS=3Dy
> +CONFIG_VMWARE_VMCI=3Dy
> +CONFIG_VSOCKETS=3Dy
> +CONFIG_X25=3Dy
> +CONFIG_XDP_SOCKETS=3Dy
> \ No newline at end of file
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> new file mode 100644
> index 000000000000..63bb269c9d07
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -0,0 +1,297 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock tests - Socket
> + *
> + * Copyright =C2=A9 2024 Huawei Tech. Co., Ltd.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <linux/landlock.h>
> +#include <linux/pfkeyv2.h>
> +#include <linux/kcm.h>
> +#include <linux/can.h>
> +#include <linux/in.h>
> +#include <sys/prctl.h>
> +
> +#include "common.h"
> +
> +struct protocol_variant {
> +	int family;
> +	int type;
> +	int protocol;
> +};
> +
> +static int test_socket(int family, int type, int protocol)
> +{
> +	int fd;
> +
> +	fd =3D socket(family, type | SOCK_CLOEXEC, protocol);
> +	if (fd < 0)
> +		return errno;
> +	/*
> +	 * Mixing error codes from close(2) and socket(2) should not lead to an=
y
> +	 * (access type) confusion for this test.
> +	 */
> +	if (close(fd) !=3D 0)
> +		return errno;
> +	return 0;
> +}
> +
> +static int test_socket_variant(const struct protocol_variant *const prot=
)
> +{
> +	return test_socket(prot->family, prot->type, prot->protocol);
> +}
> +
> +FIXTURE(protocol)
> +{
> +	struct protocol_variant prot;
> +};
> +
> +FIXTURE_VARIANT(protocol)
> +{
> +	const struct protocol_variant prot;
> +};
> +
> +FIXTURE_SETUP(protocol)
> +{
> +	disable_caps(_metadata);
> +	self->prot =3D variant->prot;
> +
> +	/*
> +	 * Some address families require this caps to be set
> +	 * (e.g. AF_CAIF, AF_KEY).
> +	 */
> +	set_cap(_metadata, CAP_SYS_ADMIN);
> +	set_cap(_metadata, CAP_NET_ADMIN);
> +	set_cap(_metadata, CAP_NET_RAW);
> +};
> +
> +FIXTURE_TEARDOWN(protocol)
> +{
> +	clear_cap(_metadata, CAP_SYS_ADMIN);
> +	clear_cap(_metadata, CAP_NET_ADMIN);
> +	clear_cap(_metadata, CAP_NET_RAW);
> +}
> +
> +#define PROTOCOL_VARIANT_EXT_ADD(family_, type_, protocol_) \
> +	FIXTURE_VARIANT_ADD(protocol, family_##_##type_)    \
> +	{                                                   \
> +		.prot =3D {                                   \
> +			.family =3D AF_##family_,             \
> +			.type =3D SOCK_##type_,               \
> +			.protocol =3D protocol_,              \
> +		},                                          \
> +	}
> +
> +#define PROTOCOL_VARIANT_ADD(family, type) \
> +	PROTOCOL_VARIANT_EXT_ADD(family, type, 0)
> +
> +/*
> + * Every protocol that can be used to create socket using create() metho=
d
> + * of net_proto_family structure is tested (e.g. this method is used to
> + * create socket with socket(2)).
> + *
> + * List of address families that are not tested:
> + * - AF_ASH, AF_SNA, AF_WANPIPE, AF_NETBEUI, AF_IPX, AF_DECNET, AF_ECONE=
T
> + *   and AF_IRDA are not implemented in kernel.
> + * - AF_BRIDGE, AF_MPLS can't be used for creating sockets.
> + * - AF_SECURITY - pseudo AF (Cf. socket.h).
> + * - AF_IB is reserved by infiniband.
> + */
> +
> +/* Cf. unix_create */
> +PROTOCOL_VARIANT_ADD(UNIX, STREAM);
> +PROTOCOL_VARIANT_ADD(UNIX, RAW);
> +PROTOCOL_VARIANT_ADD(UNIX, DGRAM);
> +PROTOCOL_VARIANT_ADD(UNIX, SEQPACKET);
> +
> +/* Cf. inet_create */
> +PROTOCOL_VARIANT_ADD(INET, STREAM);
> +PROTOCOL_VARIANT_ADD(INET, DGRAM);
> +PROTOCOL_VARIANT_EXT_ADD(INET, RAW, IPPROTO_TCP);
> +PROTOCOL_VARIANT_EXT_ADD(INET, SEQPACKET, IPPROTO_SCTP);
> +
> +/* Cf. ax25_create */
> +PROTOCOL_VARIANT_ADD(AX25, DGRAM);
> +PROTOCOL_VARIANT_ADD(AX25, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(AX25, RAW);
> +
> +/* Cf. atalk_create */
> +PROTOCOL_VARIANT_ADD(APPLETALK, RAW);
> +PROTOCOL_VARIANT_ADD(APPLETALK, DGRAM);
> +
> +/* Cf. nr_create */
> +PROTOCOL_VARIANT_ADD(NETROM, SEQPACKET);
> +
> +/* Cf. pvc_create */
> +PROTOCOL_VARIANT_ADD(ATMPVC, DGRAM);
> +PROTOCOL_VARIANT_ADD(ATMPVC, RAW);
> +PROTOCOL_VARIANT_ADD(ATMPVC, RDM);
> +PROTOCOL_VARIANT_ADD(ATMPVC, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(ATMPVC, DCCP);
> +PROTOCOL_VARIANT_ADD(ATMPVC, PACKET);
> +
> +/* Cf. x25_create */
> +PROTOCOL_VARIANT_ADD(X25, SEQPACKET);
> +
> +/* Cf. inet6_create */
> +PROTOCOL_VARIANT_ADD(INET6, STREAM);
> +PROTOCOL_VARIANT_ADD(INET6, DGRAM);
> +PROTOCOL_VARIANT_EXT_ADD(INET6, RAW, IPPROTO_TCP);
> +
> +/* Cf. rose_create */
> +PROTOCOL_VARIANT_ADD(ROSE, SEQPACKET);
> +
> +/* Cf. pfkey_create */
> +PROTOCOL_VARIANT_EXT_ADD(KEY, RAW, PF_KEY_V2);
> +
> +/* Cf. netlink_create */
> +PROTOCOL_VARIANT_ADD(NETLINK, RAW);
> +PROTOCOL_VARIANT_ADD(NETLINK, DGRAM);
> +
> +/* Cf. packet_create */
> +PROTOCOL_VARIANT_ADD(PACKET, DGRAM);
> +PROTOCOL_VARIANT_ADD(PACKET, RAW);
> +PROTOCOL_VARIANT_ADD(PACKET, PACKET);
> +
> +/* Cf. svc_create */
> +PROTOCOL_VARIANT_ADD(ATMSVC, DGRAM);
> +PROTOCOL_VARIANT_ADD(ATMSVC, RAW);
> +PROTOCOL_VARIANT_ADD(ATMSVC, RDM);
> +PROTOCOL_VARIANT_ADD(ATMSVC, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(ATMSVC, DCCP);
> +PROTOCOL_VARIANT_ADD(ATMSVC, PACKET);
> +
> +/* Cf. rds_create */
> +PROTOCOL_VARIANT_ADD(RDS, SEQPACKET);
> +
> +/* Cf. pppox_create + pppoe_create */
> +PROTOCOL_VARIANT_ADD(PPPOX, STREAM);
> +PROTOCOL_VARIANT_ADD(PPPOX, DGRAM);
> +PROTOCOL_VARIANT_ADD(PPPOX, RAW);
> +PROTOCOL_VARIANT_ADD(PPPOX, RDM);
> +PROTOCOL_VARIANT_ADD(PPPOX, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(PPPOX, DCCP);
> +PROTOCOL_VARIANT_ADD(PPPOX, PACKET);
> +
> +/* Cf. llc_ui_create */
> +PROTOCOL_VARIANT_ADD(LLC, DGRAM);
> +PROTOCOL_VARIANT_ADD(LLC, STREAM);
> +
> +/* Cf. can_create */
> +PROTOCOL_VARIANT_EXT_ADD(CAN, DGRAM, CAN_BCM);
> +
> +/* Cf. tipc_sk_create */
> +PROTOCOL_VARIANT_ADD(TIPC, STREAM);
> +PROTOCOL_VARIANT_ADD(TIPC, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(TIPC, DGRAM);
> +PROTOCOL_VARIANT_ADD(TIPC, RDM);
> +
> +/* Cf. l2cap_sock_create */
> +#ifndef __s390x__
> +PROTOCOL_VARIANT_ADD(BLUETOOTH, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(BLUETOOTH, STREAM);
> +PROTOCOL_VARIANT_ADD(BLUETOOTH, DGRAM);
> +PROTOCOL_VARIANT_ADD(BLUETOOTH, RAW);
> +#endif
> +
> +/* Cf. iucv_sock_create */
> +#ifdef __s390x__
> +PROTOCOL_VARIANT_ADD(IUCV, STREAM);
> +PROTOCOL_VARIANT_ADD(IUCV, SEQPACKET);
> +#endif
> +
> +/* Cf. rxrpc_create */
> +PROTOCOL_VARIANT_EXT_ADD(RXRPC, DGRAM, PF_INET);
> +
> +/* Cf. mISDN_sock_create */
> +#define ISDN_P_BASE 0 /* Cf. linux/mISDNif.h */
> +#define ISDN_P_TE_S0 0x01 /* Cf. linux/mISDNif.h */
> +PROTOCOL_VARIANT_EXT_ADD(ISDN, RAW, ISDN_P_BASE);
> +PROTOCOL_VARIANT_EXT_ADD(ISDN, DGRAM, ISDN_P_TE_S0);
> +
> +/* Cf. pn_socket_create */
> +PROTOCOL_VARIANT_ADD(PHONET, DGRAM);
> +PROTOCOL_VARIANT_ADD(PHONET, SEQPACKET);
> +
> +/* Cf. ieee802154_create */
> +PROTOCOL_VARIANT_ADD(IEEE802154, RAW);
> +PROTOCOL_VARIANT_ADD(IEEE802154, DGRAM);
> +
> +/* Cf. caif_create */
> +PROTOCOL_VARIANT_ADD(CAIF, SEQPACKET);
> +PROTOCOL_VARIANT_ADD(CAIF, STREAM);
> +
> +/* Cf. alg_create */
> +PROTOCOL_VARIANT_ADD(ALG, SEQPACKET);
> +
> +/* Cf. nfc_sock_create + rawsock_create */
> +PROTOCOL_VARIANT_ADD(NFC, SEQPACKET);
> +
> +/* Cf. vsock_create */
> +#if defined(__x86_64__) || defined(__aarch64__)
> +PROTOCOL_VARIANT_ADD(VSOCK, DGRAM);
> +PROTOCOL_VARIANT_ADD(VSOCK, STREAM);
> +PROTOCOL_VARIANT_ADD(VSOCK, SEQPACKET);
> +#endif
> +
> +/* Cf. kcm_create */
> +PROTOCOL_VARIANT_EXT_ADD(KCM, DGRAM, KCMPROTO_CONNECTED);
> +PROTOCOL_VARIANT_EXT_ADD(KCM, SEQPACKET, KCMPROTO_CONNECTED);
> +
> +/* Cf. qrtr_create */
> +PROTOCOL_VARIANT_ADD(QIPCRTR, DGRAM);
> +
> +/* Cf. smc_create */
> +#ifndef __alpha__
> +PROTOCOL_VARIANT_ADD(SMC, STREAM);
> +#endif
> +
> +/* Cf. xsk_create */
> +PROTOCOL_VARIANT_ADD(XDP, RAW);
> +
> +/* Cf. mctp_pf_create */
> +PROTOCOL_VARIANT_ADD(MCTP, DGRAM);
> +
> +TEST_F(protocol, create)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	const struct landlock_socket_attr create_socket_attr =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family =3D self->prot.family,
> +		.type =3D self->prot.type,
> +	};
> +	int ruleset_fd;
> +
> +	/* Tries to create a socket when ruleset is not established. */
> +	ASSERT_EQ(0, test_socket_variant(&self->prot));
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &create_socket_attr, 0));
> +
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Tries to create a socket when protocol is allowed. */
> +	EXPECT_EQ(0, test_socket_variant(&self->prot));
> +
> +	/* Denied create. */
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Tries to create a socket when protocol is restricted. */
> +	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
> +}
> +
> +TEST_HARNESS_MAIN
> --=20
> 2.34.1
>

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
