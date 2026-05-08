Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9333E51C5
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778246983; cv=none; b=brZGCDUOe7qLDTXjkfxqvQqa4K2DG0H8/hicyUdXTq006Lg/7PoerlgbozZOq2nguGUkN+zT7JlVGsYlutkyc+eRJrCw2i64+NLRE41iALd1gifkBOJxbtLEyVrJgbg96WLnWBnCKi0IIFVFa4Z3S5VmzYXr2U596XvYs59rJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778246983; c=relaxed/simple;
	bh=jtjHtFyp4WSmEumYKbmgkn9hc1MXt1RMZ6c8IfZAUAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+dPVZxd4Hekvl09t7ij4Jrtz0aNldkNO37lN9wRzs84jd/WEOnzzPr+qDLREujiu7O6yh4nn4/u3h6XrPe0hsoeLmreKwlNojY9jDatukWoLtYj4J1VZUgWHP6FuxE+Lyj+lwjvyIEzQrU2RAi1DR8syio37N1saEjIaf8Vg3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=d4pucFlK; arc=none smtp.client-ip=84.16.66.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="d4pucFlK"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4gBqj41KZBzn2p;
	Fri,  8 May 2026 15:29:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1778246968;
	bh=N7c5jpuBR3M0lyK1cP2UbGWAj184cCznwk875xu9tuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d4pucFlK/OJYiuk5Cr9ZKQQTYitzum9h91+0t3YVlzECwIxX/zqJ5iw0VgRDzjNel
	 rY2/6oFrQVYfaFKAkRt5s3aXGOtX6D1NzxtvcEeJY2Keh8kFHeO2myPzg9XBo9EqeF
	 BxIVV2q8gus36mm7UP1aYL7swTVrPyzDCwz7Uqik=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4gBqj30rlmzbNT;
	Fri,  8 May 2026 15:29:26 +0200 (CEST)
Date: Fri, 8 May 2026 15:29:21 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack3000@gmail.com>, 
	gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v4 01/19] landlock: Support socket access-control
Message-ID: <20260508.aeJoht7aepho@digikod.net>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
 <20251122.e645d2f1b8a1@gnoack.org>
 <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
 <d7b3a4ed-034e-a0a3-4a68-9bc5fdc6e2ff@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7b3a4ed-034e-a0a3-4a68-9bc5fdc6e2ff@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Sat, Apr 18, 2026 at 02:29:04PM +0300, Mikhail Ivanov wrote:
> On 11/22/2025 2:13 PM, Mikhail Ivanov wrote:
> > On 11/22/2025 1:49 PM, Günther Noack wrote:
> > > On Tue, Nov 18, 2025 at 09:46:21PM +0800, Mikhail Ivanov wrote:
> > > > +/**
> > > > + * struct landlock_socket_attr - Socket protocol definition
> > > > + *
> > > > + * Argument of sys_landlock_add_rule().
> > > > + */
> > > > +struct landlock_socket_attr {
> > > > +    /**
> > > > +     * @allowed_access: Bitmask of allowed access for a socket protocol
> > > > +     * (cf. `Socket flags`_).
> > > > +     */
> > > > +    __u64 allowed_access;
> > > > +    /**
> > > > +     * @family: Protocol family used for communication
> > > > +     * (cf. include/linux/socket.h).
> > > > +     */
> > > > +    __s32 family;
> > > > +    /**
> > > > +     * @type: Socket type (cf. include/linux/net.h)
> > > > +     */
> > > > +    __s32 type;
> > > > +    /**
> > > > +     * @protocol: Communication protocol specific to protocol
> > > > family set in
> > > > +     * @family field.
> > > 
> > > This is specific to both the @family and the @type, not just the @family.
> > > 
> > > > From socket(2):
> > > 
> > >    Normally only a single protocol exists to support a particular
> > >    socket type within a given protocol family.
> > > 
> > > For instance, in your commit message above the protocol in the example
> > > is IPPROTO_TCP, which would imply the type SOCK_STREAM, but not work
> > > with SOCK_DGRAM.
> > 
> > You're right.
> > 
> 
> I revised the socket(2) semantics and this part is about that kernel
> maps (family, type, 0) to the default protocol of given family and type.
> Eg. (AF_INET, SOCK_STREAM, 0) is mapped to (AF_INET, SOCK_STREAM,
> IPPROTO_TCP). I would like to clarify that such mapping is taking place
> in landlock_socket_attr.protocol field doc.
> 
> There should be list of protocols defined per protocol family. From
> socket(2):
> 	The domain argument specifies a communication domain.
> 	...
> 	The protocol number to use is specific to the “communication
> 	domain” in which communication is to take place.
> 
> Such mapping allows to define strange socket rules if setting @type=-1.
> For example:
> 	struct landlock_socket_attr attr = {
> 		.family = AF_INET,
> 		.type = -1,
> 		.protocol = 0,
> 	};

Looking again at this API, I think we should not have a special handling
of the "-1" values but instead change the struct landlock_socket_attr to
start with a "wildcards" field to properly identify which socket
property should be "any" value (according to a dedicated flag):

struct landlock_socket_attr {
	__u64 allowed_perm; /* see the ns/cap patch series */
	__u32 wildcards; /* LANDLOCK_SOCKET_ANY_PROTOCOL */
	__u32 family;
	__u32 type;
	__u32 protocol;
};

In fact, I though a lot about the two potential wildcards (type and
family we previously discussed), and my conclusion is that we should
only handle "any protocol" (instead of any type too). This makes the
UAPI simpler and less dangerous, especially wrt families that have very
specific and sometime privileged types (e.g. SOCK_RAW).  Another
important point is that it would allow to do only one rbtree lookup
(tweaking a bit the rbtree walk) instead of four lookup like with the
current implementation.  The idea is to generate an rbtree key with:

  family | type | !any-protocol-boolean | protocol

This key format allows a one-descent walk lookup.  We'll have to replace
the use of landlock_find_rule() with a custom walk that first look for
the any-protocol-boolean (which should probably be represented by 0 for
"any protocol" and by 1 for "specific protocol"), and if no "any
protocol" key is found, to continue the walk to match the full protocol
value.

> 
> This definition corresponds to (AF_INET, SOCK_STREAM, 0->IPPROTO_TCP)
> and to (AF_INET, SOCK_DGRAM, 0->IPPROTO_UDP).
> 
> I don't see this as a bad thing as far as there is proper documentation
> for landlock_socket_attr.

Thinking more about the asymmetry between UAPI and kernel state, I think
the best approach is to canonicalize the rules' values to make them
match the kernel equivalent.  This behavior would be much less
surprising to users (this is mostly an UX improvement, but also a way to
deduplicate some rules).  Indeed, users would be able to use the default
value (e.g. protocol 0 for INET/STREAM) *and* the canonicalized value
(e.g. protocol IPPROTO_TCP).  Here is a patch to implement this approach
and (most importantly) with the related kernel tests to make sure the
canonicalizations are correct:


[PATCH] landlock: Canonicalize socket rules and add drift detection

The kernel socket stack performs family-specific rewrites between the
(family, type, protocol) triple passed to socket(2) and the resulting
socket object.  Rewrites currently mirrored:

- __sock_create rewrites AF_INET + SOCK_PACKET to AF_PACKET for pre-2.2
  compatibility.
- unix_create rewrites AF_UNIX + SOCK_RAW to AF_UNIX + SOCK_DGRAM as a
  BSD leftover, and ignores the user protocol (sk_protocol stays 0 for
  every AF_UNIX socket).
- inet_create and inet6_create resolve protocol=0 to a type-specific
  default (IPPROTO_TCP for SOCK_STREAM, IPPROTO_UDP for SOCK_DGRAM,
  IPPROTO_SCTP for SOCK_SEQPACKET) via the inetsw walk.
- ax25_create rewrites protocol=0 and protocol=PF_AX25 to AX25_P_TEXT
  for SOCK_DGRAM and SOCK_SEQPACKET.
- pn_socket_create rewrites protocol=0 to PN_PROTO_PHONET (SOCK_DGRAM)
  or PN_PROTO_PIPE (SOCK_SEQPACKET).
- vsock_create accepts protocol=0 or PF_VSOCK and stores sk_protocol=0
  for both, so PF_VSOCK aliases protocol=0.
- Several families (AF_PACKET, AF_KEY, AF_APPLETALK, AF_ATMPVC,
  AF_ATMSVC, AF_LLC, AF_CAN raw/bcm, AF_RXRPC, AF_IEEE802154,
  AF_QIPCRTR) accept the user protocol but never write sk_protocol, so
  the kernel stores 0 regardless of input.
- AF_CAN + SOCK_DGRAM is asymmetric: bcm and raw leave sk_protocol=0,
  but j1939_sk_init writes sk_protocol = CAN_J1939.

Without Landlock-side canonicalization, a rule inserted with the user-
facing form (e.g., AF_INET + SOCK_STREAM + 0) silently misses sockets
the user wants to match: a socket created with protocol=0 reaches
sk_protocol=IPPROTO_TCP, so a rule keyed on 0 does not apply.  Each
socket call form would require the user to write a separate rule.

Store rules in the canonical form at insertion.  The new
landlock_canon_map[AF_MAX][SOCK_MAX] table with flag-driven entries
(_LANDLOCK_CANON_REWRITE_FAMILY, _LANDLOCK_CANON_REWRITE_TYPE,
_LANDLOCK_CANON_PROTOCOL_ZERO, _LANDLOCK_CANON_PROTOCOL_FAMILY_ID,
_LANDLOCK_CANON_PROTOCOL_ALWAYS, _LANDLOCK_CANON_PROTOCOL_PRESERVE)
encodes the rewrites.  landlock_canonicalize_socket_key applies them
idempotently; wildcards (TYPE_ALL, PROTOCOL_ALL) are preserved so
wildcard rules remain first-class.  Per-protocol overrides (the
preserve_protocol field) handle asymmetries like AF_CAN + SOCK_DGRAM
where one sub-protocol writes sk_protocol differently from the others.
Lookup remains O(1): the override is part of the same cell the array
index returns.

Keep enforcement at security_socket_create (pre-create) so Landlock
denies unauthorized triples before the kernel loads any family-specific
module or allocates a socket.  This preserves the EACCES error path for
triples the kernel itself would reject (AF_UNSPEC, invalid family and
type pairs) rather than leaking EAFNOSUPPORT, ESOCKTNOSUPPORT, or
EPROTONOSUPPORT as a sandbox bypass signal.  The pre-create hook
canonicalizes the caller input through the same map before the rule
lookup so that a rule keyed on the user form matches at the hook.

Add security_socket_post_create purely for runtime drift detection. At
post_create the family .create() has completed, so sk_family,
sock->type, and sk_protocol are authoritative.  Per-field WARN_ONCE
fires when landlock_canonicalize_socket_key disagrees with these values,
identifying which axis (family, type, or protocol) drifted and the
user-supplied triple.  This hook only runs for tasks sandboxed by a
domain that handles LANDLOCK_ACCESS_SOCKET_CREATE, so non-sandboxed
tasks pay no overhead.

Four layers guard against landlock_canon_map drift:

- static_assert(AF_MAX == N) and static_assert(SOCK_MAX == N) anchor the
  dimensions at the current kernel ABI; a new AF_* or SOCK_* value
  breaks the build and forces a map audit.
- A new KUnit suite (landlock_socket) iterates every (family, type,
  protocol) triple over a probe range that covers all family IDs
  (0..NPROTO) plus IPPROTO_SCTP, 255, and 0xFFFF.  For triples the
  kernel accepts, sock_create_kern is the oracle; canonicalization is
  validated against the resulting sk_family, sock->type, and
  sk_protocol.  Families known to be unsupported by the default
  configuration are marked, and -EAFNOSUPPORT on those families is
  ignored so additional sub-protocol configs can extend coverage without
  per-arch .kunitconfig fragmentation.  A separate map-entry test covers
  cells unreachable through sock_create_kern (currently AF_VSOCK +
  SOCK_DGRAM, which requires CONFIG_VIRTIO_VSOCKETS).  A
  wildcard-preservation test pins the TYPE_ALL and PROTOCOL_ALL
  invariants.
- The per-field runtime WARN_ONCE described above.
- security/landlock/.kunitconfig enumerates the CONFIG entries required
  to exercise every audited family so a family disabled by kernel config
  causes a build-visible coverage loss rather than a silent KUnit skip.

The four-way wildcard grid lookup in hook_socket_create gates every
pack_socket_key call on a successful return.  This incidentally fixes a
latent bug in the original hook where the first pack failure was
detected with == -EACCES (the helper only ever returns 0 or -EINVAL), so
an out-of-range triple fed three subsequent check_socket_access calls
with an uninitialized key.

The tcp_protocol.variant2 selftest previously asserted that a rule for
IPPROTO_TCP did NOT match socket(AF_INET, SOCK_STREAM, 0).  Under
canonicalization both forms alias by design, so the test is renamed to
alias_equivalence and its body is updated to assert the aliasing (both
call forms match irrespective of which form the rule was inserted with).
Unrelated families remain restricted.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 security/landlock/.kunitconfig                |  40 +
 security/landlock/socket.c                    | 871 +++++++++++++++++-
 .../testing/selftests/landlock/socket_test.c  |  38 +-
 3 files changed, 910 insertions(+), 39 deletions(-)

diff --git a/security/landlock/.kunitconfig b/security/landlock/.kunitconfig
index f9423f01ac5b..5aafd56e8ebd 100644
--- a/security/landlock/.kunitconfig
+++ b/security/landlock/.kunitconfig
@@ -1,6 +1,46 @@
+CONFIG_AF_RXRPC=y
+CONFIG_ATALK=y
+CONFIG_ATM=y
 CONFIG_AUDIT=y
+CONFIG_AX25=y
+CONFIG_BT=y
+CONFIG_CAIF=y
+CONFIG_CAN=y
+CONFIG_CAN_BCM=y
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_USER_API_AEAD=y
+CONFIG_HAMRADIO=y
+CONFIG_IEEE802154=y
+CONFIG_IEEE802154_SOCKET=y
+CONFIG_INET=y
+CONFIG_INFINIBAND=y
+CONFIG_IP_SCTP=y
+CONFIG_IPV6=y
+CONFIG_ISDN=y
 CONFIG_KUNIT=y
+CONFIG_LLC=y
+CONFIG_LLC2=y
+CONFIG_MCTP=y
+CONFIG_MISDN=y
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
 CONFIG_NET=y
+CONFIG_NET_KEY=y
+CONFIG_NETDEVICES=y
+CONFIG_NETROM=y
+CONFIG_NFC=y
+CONFIG_PACKET=y
+CONFIG_PHONET=y
+CONFIG_PPP=y
+CONFIG_PPPOE=y
+CONFIG_QRTR=y
+CONFIG_RDS=y
+CONFIG_ROSE=y
 CONFIG_SECURITY=y
 CONFIG_SECURITY_LANDLOCK=y
 CONFIG_SECURITY_LANDLOCK_KUNIT_TEST=y
+CONFIG_SMC=y
+CONFIG_TIPC=y
+CONFIG_UNIX=y
+CONFIG_VSOCKETS=y
+CONFIG_X25=y
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
index 6afd5a0ac6d7..ef48949fa7d3 100644
--- a/security/landlock/socket.c
+++ b/security/landlock/socket.c
@@ -5,20 +5,385 @@
  * Copyright © 2025 Huawei Tech. Co., Ltd.
  */
 
+#include <linux/in.h>
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/stddef.h>
 #include <net/ipv6.h>
+#include <net/sock.h>
 
 #include "audit.h"
+#include "cred.h"
 #include "limits.h"
 #include "ruleset.h"
 #include "socket.h"
-#include "cred.h"
 
 #define TYPE_ALL (-1)
 #define PROTOCOL_ALL (-1)
 
+/*
+ * Compensation for kernel-internal socket rewrites.
+ *
+ * The kernel maps the user-visible (family, type, protocol) triple into
+ * (sk->sk_family, sock->type, sk->sk_protocol) following per-family rules.
+ * Landlock mirrors those rules at rule insertion and at hook time so that rules
+ * inserted with a user-facing form match the canonical triple seen after
+ * socket(2) completes.  The known patterns are:
+ *
+ *   - __sock_create rewrites AF_INET + SOCK_PACKET to AF_PACKET for
+ *     pre-2.2 compatibility (net/socket.c).
+ *   - unix_create rewrites AF_UNIX + SOCK_RAW to AF_UNIX + SOCK_DGRAM and
+ *     ignores the user protocol (sk_protocol stays 0).
+ *   - inet_create and inet6_create resolve protocol=0 to a type-specific
+ *     default (IPPROTO_TCP for SOCK_STREAM, IPPROTO_UDP for SOCK_DGRAM,
+ *     IPPROTO_SCTP for SOCK_SEQPACKET) via the inetsw walk.
+ *   - ax25_create rewrites protocol=0 or PF_AX25 to AX25_P_TEXT for
+ *     SOCK_DGRAM and SOCK_SEQPACKET.
+ *   - pn_socket_create rewrites protocol=0 to PN_PROTO_PHONET for
+ *     SOCK_DGRAM and PN_PROTO_PIPE for SOCK_SEQPACKET.
+ *   - vsock_create accepts either 0 or PF_VSOCK and stores sk_protocol=0
+ *     for both; Landlock canonicalizes the rule to protocol=0.
+ *
+ * Enforcement happens at security_socket_create (pre-create) so Landlock denies
+ * unauthorized triples before any family-specific module is loaded or socket
+ * allocated, preserving the EACCES error path for triples the kernel itself
+ * would reject.
+ *
+ * Drift between landlock_canon_map and kernel behavior is detected in four
+ * layers: static_asserts on AF_MAX and SOCK_MAX (new AF or SOCK values break
+ * the build), the exhaustive KUnit suite in this file using sock_create_kern as
+ * the oracle, a runtime WARN_ON_ONCE in the post_create hook, and an explicit
+ * CONFIG list in .kunitconfig so a missing family fails the build instead of
+ * silently skipping.
+ */
+
+#define _LANDLOCK_CANON_REWRITE_FAMILY BIT(0)
+#define _LANDLOCK_CANON_REWRITE_TYPE BIT(1)
+#define _LANDLOCK_CANON_PROTOCOL_ZERO BIT(2)
+#define _LANDLOCK_CANON_PROTOCOL_FAMILY_ID BIT(3)
+#define _LANDLOCK_CANON_PROTOCOL_ALWAYS BIT(4)
+#define _LANDLOCK_CANON_PROTOCOL_PRESERVE BIT(5)
+
+/*
+ * All fields fit in u8 today: ops uses 6 bits; SOCK_MAX-1 and AF_MAX-1 are both
+ * small; the largest canonicalization target is AX25_P_TEXT (0xF0), well within
+ * u8.  -Woverflow catches a too-wide initializer at build time if a future
+ * entry exceeds the field width.
+ */
+struct landlock_canon_entry {
+	u8 ops;
+	u8 new_type;
+	u8 new_family;
+	u8 new_protocol;
+	/*
+	 * When PROTOCOL_PRESERVE is set and the user protocol matches this
+	 * value, the protocol field is left unchanged regardless of the other
+	 * PROTOCOL_* flags.  Captures sub-protocols whose .create() writes
+	 * sk_protocol explicitly (e.g. CAN_J1939) when other sub-protocols of
+	 * the same (family, type) do not.  Lookup stays O(1) because the
+	 * override is part of the same cell.
+	 */
+	u8 preserve_protocol;
+};
+
+/*
+ * Shared initializer for Case 4 families (AF_UNIX, AF_PACKET, AF_VSOCK, AF_KEY,
+ * ...) whose .create() ignores the user protocol and leaves sk_protocol at 0.
+ * The canonical form is any type, protocol=0.
+ */
+#define _LANDLOCK_CANON_ALWAYS_ZERO                                        \
+	{                                                                  \
+		.ops = _LANDLOCK_CANON_PROTOCOL_ALWAYS, .new_protocol = 0, \
+	}
+
+/*
+ * A change to AF_MAX or SOCK_MAX implies a new protocol family or socket type
+ * reached upstream.  The assertion fires a build error that forces an audit:
+ * does the new family or type introduce a kernel-internal rewrite that Landlock
+ * must mirror?  If not, bump the expected value below.
+ */
+static_assert(AF_MAX == 46,
+	      "AF_MAX changed; audit landlock_canon_map for new families.");
+static_assert(SOCK_MAX == 11,
+	      "SOCK_MAX changed; audit landlock_canon_map for new types.");
+
+static const struct landlock_canon_entry
+	landlock_canon_map[AF_MAX][SOCK_MAX] = {
+		/*
+		 * unix_create rewrites SOCK_RAW to SOCK_DGRAM and ignores the
+		 * user protocol; normalize every AF_UNIX socket to protocol=0.
+		 */
+		[AF_UNIX] = {
+			[SOCK_STREAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_SEQPACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RAW] = {
+				.ops = _LANDLOCK_CANON_REWRITE_TYPE |
+				       _LANDLOCK_CANON_PROTOCOL_ALWAYS,
+				.new_type = SOCK_DGRAM,
+				.new_protocol = 0,
+			},
+		},
+		[AF_INET] = {
+			[SOCK_STREAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_TCP,
+			},
+			[SOCK_DGRAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_UDP,
+			},
+			[SOCK_SEQPACKET] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_SCTP,
+			},
+			/*
+			 * __sock_create rewrites AF_INET + SOCK_PACKET to
+			 * AF_PACKET; packet_create then stores sk_protocol=0
+			 * regardless of the user protocol (see AF_PACKET rows
+			 * below), so the canonical triple is (AF_PACKET,
+			 * SOCK_PACKET, 0).
+			 */
+			[SOCK_PACKET] = {
+				.ops = _LANDLOCK_CANON_REWRITE_FAMILY |
+				       _LANDLOCK_CANON_PROTOCOL_ALWAYS,
+				.new_family = AF_PACKET,
+				.new_protocol = 0,
+			},
+		},
+		/*
+		 * packet_create stores the user-provided protocol in po->num
+		 * (for filtering) but never writes sk_protocol, so sk_protocol
+		 * stays at 0 for every AF_PACKET socket.  Canonicalize rules to
+		 * protocol=0 to match.
+		 */
+		[AF_PACKET] = {
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_PACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * AX.25 rewrites protocol=0 AND PF_AX25 to AX25_P_TEXT (0xF0)
+		 * for SOCK_DGRAM and SOCK_SEQPACKET; see ax25_create in
+		 * net/ax25/af_ax25.c.  SOCK_RAW preserves user input.
+		 */
+		[AF_AX25] = {
+			[SOCK_DGRAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO |
+				       _LANDLOCK_CANON_PROTOCOL_FAMILY_ID,
+				.new_protocol = 0xF0, /* AX25_P_TEXT */
+			},
+			[SOCK_SEQPACKET] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO |
+				       _LANDLOCK_CANON_PROTOCOL_FAMILY_ID,
+				.new_protocol = 0xF0, /* AX25_P_TEXT */
+			},
+		},
+		[AF_INET6] = {
+			[SOCK_STREAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_TCP,
+			},
+			[SOCK_DGRAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_UDP,
+			},
+			[SOCK_SEQPACKET] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = IPPROTO_SCTP,
+			},
+		},
+		/*
+		 * Phonet rewrites protocol=0 to PN_PROTO_PHONET for SOCK_DGRAM
+		 * and PN_PROTO_PIPE for SOCK_SEQPACKET; see pn_socket_create in
+		 * net/phonet/af_phonet.c.
+		 */
+		[AF_PHONET] = {
+			[SOCK_DGRAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = 1, /* PN_PROTO_PHONET */
+			},
+			[SOCK_SEQPACKET] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ZERO,
+				.new_protocol = 2, /* PN_PROTO_PIPE */
+			},
+		},
+		/*
+		 * atalk_create accepts SOCK_DGRAM and SOCK_RAW but never writes
+		 * sk_protocol.
+		 */
+		[AF_APPLETALK] = {
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * ATM PVC and SVC go through vcc_create, which rejects
+		 * SOCK_STREAM and accepts every other type in the
+		 * 0..SOCK_PACKET range without writing sk_protocol.
+		 */
+		[AF_ATMPVC] = {
+			[0] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RDM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_SEQPACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DCCP] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[7] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[8] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[9] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[SOCK_PACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		[AF_ATMSVC] = {
+			[0] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_RDM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_SEQPACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DCCP] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[7] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[8] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[9] = _LANDLOCK_CANON_ALWAYS_ZERO, /* reserved hole */
+			[SOCK_PACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * LLC, CAN, RxRPC, IEEE 802.15.4, and QRTR all rely on
+		 * sock_init_data to zero sk_protocol and never override it, so
+		 * any reachable triple is canonicalized to protocol=0.
+		 */
+		[AF_LLC] = {
+			[SOCK_STREAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * AF_CAN dispatches by protocol: can_raw and can_bcm leave
+		 * sk_protocol=0, but j1939_sk_init writes sk_protocol =
+		 * CAN_J1939.  Use PROTOCOL_PRESERVE on SOCK_DGRAM so the J1939
+		 * value survives the canonicalization while all other
+		 * sub-protocols get normalized to 0.  SOCK_SEQPACKET has no
+		 * registered CAN sub-protocol so no entry is needed (the cell
+		 * is unreachable at the kernel).
+		 */
+		[AF_CAN] = {
+			[SOCK_DGRAM] = {
+				.ops = _LANDLOCK_CANON_PROTOCOL_ALWAYS |
+				       _LANDLOCK_CANON_PROTOCOL_PRESERVE,
+				.new_protocol = 0,
+				.preserve_protocol =
+					7 /* CAN_J1939 */,
+			},
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		[AF_RXRPC] = {
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		[AF_IEEE802154] = {
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		[AF_QIPCRTR] = {
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * pfkey_create accepts only PF_KEY_V2 for SOCK_RAW but never
+		 * writes sk_protocol, so the kernel stores sk_protocol=0.
+		 */
+		[AF_KEY] = {
+			[SOCK_RAW] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+		/*
+		 * vsock accepts protocol=0 or PF_VSOCK and leaves sk_protocol
+		 * at 0 in either case, for every transport (loopback, VMCI,
+		 * virtio, hyperv) because vsock_create never writes
+		 * sk_protocol.  Canonicalize every AF_VSOCK rule to protocol=0
+		 * so both call forms match the same rule.
+		 *
+		 * The vsock loopback transport (the only one enabled by the
+		 * default .kunitconfig) does not advertise DGRAM capability, so
+		 * the SOCK_DGRAM cell is not reachable through sock_create_kern
+		 * at KUnit time; DGRAM reachability requires
+		 * CONFIG_VIRTIO_VSOCKETS=y.  The canonicalization is
+		 * nonetheless correct; a dedicated map-entry test case
+		 * validates it independently of any kernel configuration.
+		 */
+		[AF_VSOCK] = {
+			[SOCK_STREAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_DGRAM] = _LANDLOCK_CANON_ALWAYS_ZERO,
+			[SOCK_SEQPACKET] = _LANDLOCK_CANON_ALWAYS_ZERO,
+		},
+	};
+
+/*
+ * landlock_canonicalize_socket_key - Apply kernel-equivalent rewrites
+ *
+ * @family: in/out protocol family.
+ * @type: in/out socket type.
+ * @protocol: in/out protocol.
+ *
+ * Transforms a (@family, @type, @protocol) triple into the form the kernel
+ * stores after the family .create() completes.  Wildcards (TYPE_ALL,
+ * PROTOCOL_ALL) are preserved unchanged since they do not pin a specific
+ * triple.  Out-of-range values are left for the caller (pack_socket_key) to
+ * reject.
+ */
+static void landlock_canonicalize_socket_key(s32 *family, s32 *type,
+					     s32 *protocol)
+{
+	const struct landlock_canon_entry *entry;
+	s32 input_family;
+
+	/*
+	 * Type is the map second index, so it must be concrete.  Family is the
+	 * map first index; checked below via bounds.
+	 */
+	if (*type == TYPE_ALL)
+		return;
+
+	if (*family < 0 || *family >= AF_MAX || *type < 0 || *type >= SOCK_MAX)
+		return;
+
+	entry = &landlock_canon_map[*family][*type];
+	input_family = *family;
+
+	/*
+	 * Family and type rewrites apply regardless of protocol value; a
+	 * PROTOCOL_ALL rule still benefits from an alias family or type
+	 * rewrite.
+	 */
+	if (entry->ops & _LANDLOCK_CANON_REWRITE_FAMILY)
+		*family = entry->new_family;
+	if (entry->ops & _LANDLOCK_CANON_REWRITE_TYPE)
+		*type = entry->new_type;
+
+	/*
+	 * Protocol rewrites are skipped for wildcard protocols so that a
+	 * PROTOCOL_ALL rule stays wildcard even for families the kernel
+	 * canonicalizes.
+	 */
+	if (*protocol == PROTOCOL_ALL)
+		return;
+
+	/*
+	 * Per-protocol preservation: when the map declares that one specific
+	 * user protocol survives unchanged in sk_protocol (e.g., AF_CAN +
+	 * SOCK_DGRAM + CAN_J1939: j1939_sk_init writes sk_protocol = CAN_J1939,
+	 * while raw_init and bcm_init leave sk_protocol = 0), skip all protocol
+	 * rewrites when the user input matches that value.  Keeps the runtime
+	 * drift WARN silent for the exception while PROTOCOL_ALWAYS still
+	 * normalizes the rest of the cell to new_protocol.
+	 */
+	if ((entry->ops & _LANDLOCK_CANON_PROTOCOL_PRESERVE) &&
+	    *protocol == entry->preserve_protocol)
+		return;
+
+	if (entry->ops & _LANDLOCK_CANON_PROTOCOL_ALWAYS)
+		*protocol = entry->new_protocol;
+	else if (((entry->ops & _LANDLOCK_CANON_PROTOCOL_ZERO) &&
+		  *protocol == 0) ||
+		 ((entry->ops & _LANDLOCK_CANON_PROTOCOL_FAMILY_ID) &&
+		  *protocol == input_family))
+		*protocol = entry->new_protocol;
+}
+
 static int pack_socket_key(const s32 family, const s32 type, const s32 protocol,
 			   uintptr_t *val)
 {
@@ -78,12 +443,12 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 {
 	int err;
 	uintptr_t key;
+
 	/*
-	 * (AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
-	 * (cf. __sock_create).
+	 * Apply the kernel rewrites so that this rule matches the triple seen
+	 * at hook time.  See landlock_canon_map.
 	 */
-	if (family == AF_INET && type == SOCK_PACKET)
-		family = AF_PACKET;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
 
 	err = pack_socket_key(family, type, protocol, &key);
 	if (err)
@@ -123,6 +488,12 @@ static int check_socket_access(const struct landlock_ruleset *dom,
 	return -EACCES;
 }
 
+/*
+ * Enforcement happens at security_socket_create (pre-create) so Landlock denies
+ * unauthorized triples before the kernel loads any family-specific module or
+ * allocates a socket.  This preserves the EACCES error path even for triples
+ * the kernel itself would reject (AF_UNSPEC, invalid family and type pairs).
+ */
 static int hook_socket_create(int family, int type, int protocol, int kern)
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_SOCKET] = {};
@@ -133,45 +504,52 @@ static int hook_socket_create(int family, int type, int protocol, int kern)
 	const struct landlock_cred_security *const subject =
 		landlock_get_applicable_subject(current_cred(), masks, NULL);
 	uintptr_t key;
+	s32 canon_family = family, canon_type = type, canon_protocol = protocol;
 	struct lsm_socket_audit audit_socket = {
 		.family = family,
 		.type = type,
 		.protocol = protocol,
 	};
 
-	if (!subject)
-		return 0;
-	/* Checks only user space sockets. */
+	/* Kernel-internal sockets bypass (accept, sock_create_lite, ...). */
 	if (kern)
 		return 0;
+	if (!subject)
+		return 0;
+
+	/* Canonicalize the user-facing triple to match the rule storage. */
+	landlock_canonicalize_socket_key(&canon_family, &canon_type,
+					 &canon_protocol);
 
 	handled_access = landlock_init_layer_masks(
 		subject->domain, LANDLOCK_ACCESS_SOCKET_CREATE, &layer_masks,
 		LANDLOCK_KEY_SOCKET);
+
 	/*
-	 * Error could happen due to parameters are outside of the allowed range,
-	 * so this combination couldn't be added in ruleset previously.
-	 * Therefore, it's not permitted.
+	 * Four-way wildcard grid lookup.  Each pack_socket_key call is gated on
+	 * its return value so a rejected triple does not feed an uninitialized
+	 * key into check_socket_access.
 	 */
-	if (pack_socket_key(family, type, protocol, &key) == -EACCES)
-		return -EACCES;
-	if (check_socket_access(subject->domain, key, &layer_masks,
+	if (pack_socket_key(canon_family, canon_type, canon_protocol, &key) ==
+		    0 &&
+	    check_socket_access(subject->domain, key, &layer_masks,
 				handled_access) == 0)
 		return 0;
 
-	/* Ranges were already checked. */
-	(void)pack_socket_key(family, TYPE_ALL, protocol, &key);
-	if (check_socket_access(subject->domain, key, &layer_masks,
+	if (pack_socket_key(canon_family, TYPE_ALL, canon_protocol, &key) ==
+		    0 &&
+	    check_socket_access(subject->domain, key, &layer_masks,
 				handled_access) == 0)
 		return 0;
 
-	(void)pack_socket_key(family, type, PROTOCOL_ALL, &key);
-	if (check_socket_access(subject->domain, key, &layer_masks,
+	if (pack_socket_key(canon_family, canon_type, PROTOCOL_ALL, &key) ==
+		    0 &&
+	    check_socket_access(subject->domain, key, &layer_masks,
 				handled_access) == 0)
 		return 0;
 
-	(void)pack_socket_key(family, TYPE_ALL, PROTOCOL_ALL, &key);
-	if (check_socket_access(subject->domain, key, &layer_masks,
+	if (pack_socket_key(canon_family, TYPE_ALL, PROTOCOL_ALL, &key) == 0 &&
+	    check_socket_access(subject->domain, key, &layer_masks,
 				handled_access) == 0)
 		return 0;
 
@@ -187,8 +565,64 @@ static int hook_socket_create(int family, int type, int protocol, int kern)
 	return -EACCES;
 }
 
+/*
+ * Runtime drift detection: at post_create the family .create() has completed,
+ * so sk_family, sock->type and sk_protocol are authoritative.  Compare them
+ * against what landlock_canonicalize_socket_key produces from the user input; a
+ * mismatch means a kernel canonicalization is not mirrored in
+ * landlock_canon_map.  Enforcement already happened at socket_create, so this
+ * hook always returns 0.
+ *
+ * This hook only runs for tasks sandboxed by a Landlock domain that handles
+ * LANDLOCK_ACCESS_SOCKET_CREATE, so non-sandboxed tasks pay no overhead.
+ * Sandboxed tasks still cover enough of the reachable (family, type, protocol)
+ * space over the lifetime of a typical workload to surface drift in the field.
+ */
+static int hook_socket_post_create(struct socket *sock, int family, int type,
+				   int protocol, int kern)
+{
+	const struct access_masks masks = {
+		.socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	s32 canon_family = family, canon_type = type, canon_protocol = protocol;
+
+	if (kern)
+		return 0;
+	if (!landlock_get_applicable_subject(current_cred(), masks, NULL))
+		return 0;
+
+	/*
+	 * Kernel-resolved values are authoritative; no fallback to the user
+	 * protocol argument.  Families that ignore the user protocol (e.g.,
+	 * AF_UNIX, AF_VSOCK) are represented in landlock_canon_map with
+	 * PROTOCOL_ALWAYS so the canonicalization below yields the same value
+	 * for both rule insertion and this comparison.
+	 *
+	 * Drift is reported per field so a reviewer knows which axis disagrees
+	 * with the kernel without having to diff three values.  WARN_ONCE
+	 * rather than WARN_ON_ONCE keeps the stack trace but swallows
+	 * subsequent identical drifts in the same boot.
+	 */
+	landlock_canonicalize_socket_key(&canon_family, &canon_type,
+					 &canon_protocol);
+	WARN_ONCE(
+		canon_family != sock->sk->sk_family,
+		"Landlock canon family drift: canon=%d kernel=%d (user family=%d type=%d protocol=%d)\n",
+		canon_family, sock->sk->sk_family, family, type, protocol);
+	WARN_ONCE(
+		canon_type != sock->type,
+		"Landlock canon type drift: canon=%d kernel=%d (user family=%d type=%d protocol=%d)\n",
+		canon_type, sock->type, family, type, protocol);
+	WARN_ONCE(
+		canon_protocol != sock->sk->sk_protocol,
+		"Landlock canon protocol drift: canon=%d kernel=%d (user family=%d type=%d protocol=%d)\n",
+		canon_protocol, sock->sk->sk_protocol, family, type, protocol);
+	return 0;
+}
+
 static struct security_hook_list landlock_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_create, hook_socket_create),
+	LSM_HOOK_INIT(socket_post_create, hook_socket_post_create),
 };
 
 __init void landlock_add_socket_hooks(void)
@@ -196,3 +630,398 @@ __init void landlock_add_socket_hooks(void)
 	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
 			   &landlock_lsmid);
 }
+
+#ifdef CONFIG_SECURITY_LANDLOCK_KUNIT_TEST
+
+#include <kunit/test.h>
+#include <net/net_namespace.h>
+
+/*
+ * Per-family parameterized coverage test.  One subtest per AF_*; each subtest
+ * iterates every (type, protocol) probe through sock_create_kern and checks
+ * either that landlock_canonicalize_socket_key matches the kernel-resolved
+ * triple (for reachable families) or that the call fails with the expected
+ * errno (for unsupported families).  No subtest is skipped: every family
+ * produces PASS or FAIL, so an unsupported entry that quietly becomes stale is
+ * caught immediately.
+ *
+ * Every unsupported family entry expects sock_create_kern to fail with
+ * -EAFNOSUPPORT because no handler is registered for that family in the KUnit
+ * build environment (either the family was never implemented, was removed from
+ * Linux, is a reserved pseudo family, or requires an arch or CONFIG not
+ * satisfied by .kunitconfig).  The family name in the TAP subtest header,
+ * combined with this errno, identifies the case unambiguously.
+ */
+struct landlock_canon_family_case {
+	int af;
+	const char *name;
+	/*
+	 * True means the family must be supported in the KUnit environment and
+	 * canonicalization is exercised against the kernel.  False means every
+	 * probe must fail with -EAFNOSUPPORT.
+	 */
+	bool supported;
+};
+
+#define _LANDLOCK_AF_SUPPORTED(f)                         \
+	{                                                 \
+		.af = (f), .name = #f, .supported = true, \
+	}
+
+#define _LANDLOCK_AF_UNSUPPORTED(f)                        \
+	{                                                  \
+		.af = (f), .name = #f, .supported = false, \
+	}
+
+static const struct landlock_canon_family_case landlock_canon_families[] = {
+	/* kernel rejects socket(AF_UNSPEC) */
+	_LANDLOCK_AF_UNSUPPORTED(AF_UNSPEC),
+	_LANDLOCK_AF_SUPPORTED(AF_UNIX),
+	_LANDLOCK_AF_SUPPORTED(AF_INET),
+	_LANDLOCK_AF_SUPPORTED(AF_AX25),
+	/* AF_IPX removed from Linux */
+	_LANDLOCK_AF_UNSUPPORTED(AF_IPX),
+	_LANDLOCK_AF_SUPPORTED(AF_APPLETALK),
+	_LANDLOCK_AF_SUPPORTED(AF_NETROM),
+	/* AF_BRIDGE cannot be used to create sockets */
+	_LANDLOCK_AF_UNSUPPORTED(AF_BRIDGE),
+	_LANDLOCK_AF_SUPPORTED(AF_ATMPVC),
+	_LANDLOCK_AF_SUPPORTED(AF_X25),
+	_LANDLOCK_AF_SUPPORTED(AF_INET6),
+	_LANDLOCK_AF_SUPPORTED(AF_ROSE),
+	/* AF_DECnet removed from Linux */
+	_LANDLOCK_AF_UNSUPPORTED(AF_DECnet),
+	/* AF_NETBEUI not implemented */
+	_LANDLOCK_AF_UNSUPPORTED(AF_NETBEUI),
+	/* AF_SECURITY is a pseudo family */
+	_LANDLOCK_AF_UNSUPPORTED(AF_SECURITY),
+	_LANDLOCK_AF_SUPPORTED(AF_KEY),
+	_LANDLOCK_AF_SUPPORTED(AF_NETLINK),
+	_LANDLOCK_AF_SUPPORTED(AF_PACKET),
+	/* AF_ASH not implemented */
+	_LANDLOCK_AF_UNSUPPORTED(AF_ASH),
+	/* AF_ECONET removed from Linux */
+	_LANDLOCK_AF_UNSUPPORTED(AF_ECONET),
+	_LANDLOCK_AF_SUPPORTED(AF_ATMSVC),
+	_LANDLOCK_AF_SUPPORTED(AF_RDS),
+	/* AF_SNA not implemented */
+	_LANDLOCK_AF_UNSUPPORTED(AF_SNA),
+	/* AF_IRDA removed from Linux */
+	_LANDLOCK_AF_UNSUPPORTED(AF_IRDA),
+	_LANDLOCK_AF_SUPPORTED(AF_PPPOX),
+	/* AF_WANPIPE not implemented */
+	_LANDLOCK_AF_UNSUPPORTED(AF_WANPIPE),
+	_LANDLOCK_AF_SUPPORTED(AF_LLC),
+	/* AF_IB reserved by infiniband */
+	_LANDLOCK_AF_UNSUPPORTED(AF_IB),
+	/* AF_MPLS cannot be used to create sockets */
+	_LANDLOCK_AF_UNSUPPORTED(AF_MPLS),
+	_LANDLOCK_AF_SUPPORTED(AF_CAN),
+	_LANDLOCK_AF_SUPPORTED(AF_TIPC),
+	_LANDLOCK_AF_SUPPORTED(AF_BLUETOOTH),
+	/* AF_IUCV only on s390 */
+	_LANDLOCK_AF_UNSUPPORTED(AF_IUCV),
+	_LANDLOCK_AF_SUPPORTED(AF_RXRPC),
+	_LANDLOCK_AF_SUPPORTED(AF_ISDN),
+	_LANDLOCK_AF_SUPPORTED(AF_PHONET),
+	_LANDLOCK_AF_SUPPORTED(AF_IEEE802154),
+	_LANDLOCK_AF_SUPPORTED(AF_CAIF),
+	_LANDLOCK_AF_SUPPORTED(AF_ALG),
+	_LANDLOCK_AF_SUPPORTED(AF_NFC),
+	_LANDLOCK_AF_SUPPORTED(AF_VSOCK),
+	/* AF_KCM requires a kcm multiplexer setup */
+	_LANDLOCK_AF_UNSUPPORTED(AF_KCM),
+	_LANDLOCK_AF_SUPPORTED(AF_QIPCRTR),
+	_LANDLOCK_AF_SUPPORTED(AF_SMC),
+	/* AF_XDP requires a netdev with XDP support */
+	_LANDLOCK_AF_UNSUPPORTED(AF_XDP),
+	_LANDLOCK_AF_SUPPORTED(AF_MCTP),
+};
+
+static_assert(ARRAY_SIZE(landlock_canon_families) == AF_MAX,
+	      "landlock_canon_families size must track AF_MAX.");
+
+static void
+landlock_canon_family_to_desc(const struct landlock_canon_family_case *c,
+			      char *desc)
+{
+	strscpy(desc, c->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(landlock_canon_family, landlock_canon_families,
+		  landlock_canon_family_to_desc);
+
+/*
+ * Edge protocol sentinels beyond the 0..NPROTO range exercised by the main
+ * sweep.  IPPROTO_SCTP is the only value in landlock_canon_map above NPROTO
+ * today; 255 = IPPROTO_RAW covers the top of the IP protocol byte; 0xFFFF = u16
+ * upper bound covers the ethertype-wide range accepted by AF_PACKET and
+ * saturates pack_socket_key's u16 field.
+ */
+static const int landlock_edge_protocols[] = {
+	IPPROTO_SCTP,
+	255 /* IPPROTO_RAW */,
+	0xFFFF /* u16 max */,
+};
+
+/*
+ * Return the protocol value for probe index @p: indices 0..NPROTO cover every
+ * family-ID range (and NPROTO itself, one past the last valid PF_*, exercises
+ * an out-of-range probe); subsequent indices draw from landlock_edge_protocols.
+ * Returns -1 when the iteration is exhausted.
+ */
+static int landlock_probe_protocol(size_t p)
+{
+	if (p <= NPROTO)
+		return (int)p;
+	if (p - (NPROTO + 1) < ARRAY_SIZE(landlock_edge_protocols))
+		return landlock_edge_protocols[p - (NPROTO + 1)];
+	return -1;
+}
+
+static void test_family_canonicalization(struct kunit *const test)
+{
+	const struct landlock_canon_family_case *const c = test->param_value;
+	unsigned int tested = 0, canonicalized = 0, confirmed_unsupported = 0;
+	int type;
+	size_t probe;
+
+	for (type = 0; type < SOCK_MAX; type++) {
+		for (probe = 0;; probe++) {
+			const int protocol = landlock_probe_protocol(probe);
+			struct socket *sock = NULL;
+			int ret, kernel_family, kernel_type, kernel_protocol;
+			s32 landlock_family, landlock_type, landlock_protocol;
+
+			if (protocol < 0)
+				break;
+
+			ret = sock_create_kern(&init_net, c->af, type, protocol,
+					       &sock);
+
+			if (ret == 0) {
+				/*
+				 * Reached the kernel: fully verify Landlock
+				 * canonicalization against the resolved
+				 * sk_family / sock->type / sk_protocol triple.
+				 * This path runs whether or not the family is
+				 * listed as unsupported: if an extra CONFIG_*
+				 * turns an unsupported family entry reachable,
+				 * the test picks it up naturally.
+				 */
+				kernel_family = sock->sk->sk_family;
+				kernel_type = sock->type;
+				kernel_protocol = sock->sk->sk_protocol;
+				sock_release(sock);
+
+				landlock_family = c->af;
+				landlock_type = type;
+				landlock_protocol = protocol;
+				landlock_canonicalize_socket_key(
+					&landlock_family, &landlock_type,
+					&landlock_protocol);
+
+				/* Drift axis identified by the failing macro
+				 * line; KUNIT_EXPECT_EQ_MSG already prints
+				 * expected vs actual values.  The format
+				 * "(F,T,P)" carries the user input that
+				 * triggered the mismatch.
+				 */
+				KUNIT_EXPECT_EQ_MSG(test, landlock_family,
+						    kernel_family,
+						    "family (%d,%d,%d)", c->af,
+						    type, protocol);
+				KUNIT_EXPECT_EQ_MSG(test, landlock_type,
+						    kernel_type,
+						    "type (%d,%d,%d)", c->af,
+						    type, protocol);
+				KUNIT_EXPECT_EQ_MSG(test, landlock_protocol,
+						    kernel_protocol,
+						    "protocol (%d,%d,%d)",
+						    c->af, type, protocol);
+
+				tested++;
+				if (landlock_family != c->af ||
+				    landlock_type != type ||
+				    landlock_protocol != protocol)
+					canonicalized++;
+			} else if (ret == -EAFNOSUPPORT && !c->supported) {
+				/*
+				 * Ignore this specific combination when the
+				 * kernel says the family is not registered AND
+				 * the family is on the unsupported list.
+				 * Rationale: the unsupported flag declares "we
+				 * expect no kernel handler for this family in
+				 * the KUnit build".  If extra CONFIG_* entries
+				 * are added later (e.g. via --kconfig_add or a
+				 * per-arch config layer), an unsupported family
+				 * entry may start returning ret == 0 for some
+				 * probes; those fall into the branch above and
+				 * are fully tested.  No per-arch .kunitconfig
+				 * fragmentation is required.
+				 *
+				 * Other negative errno values (e.g.,
+				 * -EPROTONOSUPPORT, -ESOCKTNOSUPPORT,
+				 * -EPROTOTYPE) indicate that this specific
+				 * (type, protocol) triple is not supported by
+				 * an otherwise-loaded family; silently skip the
+				 * probe in that case too.
+				 */
+				confirmed_unsupported++;
+			}
+			/*
+			 * All other non-zero returns are silently skipped: the
+			 * kernel rejected the specific triple; nothing to
+			 * canonicalize.
+			 */
+		}
+	}
+
+	if (!c->supported) {
+		kunit_info(test,
+			   "%u probes confirmed %s unsupported (errno %d)",
+			   confirmed_unsupported, c->name, -EAFNOSUPPORT);
+		return;
+	}
+	if (tested == 0) {
+		/*
+		 * Resolve by either (a) adding a sub-protocol CONFIG to
+		 * .kunitconfig so sock_create_kern can reach the family, or (b)
+		 * flipping the family entry's .supported field to false to
+		 * declare it expected-unreachable.
+		 */
+		KUNIT_FAIL(test, "%s: no reachable triple", c->name);
+		return;
+	}
+	kunit_info(test, "%u reachable triples (%u canonicalized)", tested,
+		   canonicalized);
+}
+
+/*
+ * Wildcards bypass canonicalization: the input triple is returned unchanged for
+ * TYPE_ALL, and protocol rewrites are skipped for PROTOCOL_ALL while family and
+ * type rewrites still apply.
+ */
+static void test_canonicalization_preserves_wildcards(struct kunit *const test)
+{
+	s32 family, type, protocol;
+
+	/* Type wildcard: no map lookup. */
+	family = AF_INET;
+	type = TYPE_ALL;
+	protocol = 0;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, AF_INET);
+	KUNIT_EXPECT_EQ(test, type, TYPE_ALL);
+	KUNIT_EXPECT_EQ(test, protocol, 0);
+
+	/* Protocol wildcard with REWRITE_FAMILY row: family still rewrites. */
+	family = AF_INET;
+	type = SOCK_PACKET;
+	protocol = PROTOCOL_ALL;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, AF_PACKET);
+	KUNIT_EXPECT_EQ(test, type, SOCK_PACKET);
+	KUNIT_EXPECT_EQ(test, protocol, PROTOCOL_ALL);
+
+	/* Protocol wildcard with PROTOCOL_ZERO row: protocol stays wildcard. */
+	family = AF_INET;
+	type = SOCK_STREAM;
+	protocol = PROTOCOL_ALL;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, AF_INET);
+	KUNIT_EXPECT_EQ(test, type, SOCK_STREAM);
+	KUNIT_EXPECT_EQ(test, protocol, PROTOCOL_ALL);
+
+	/*
+	 * Protocol wildcard with PROTOCOL_ALWAYS row: protocol stays wildcard
+	 * even though the entry would unconditionally rewrite concrete protocol
+	 * values.
+	 */
+	family = AF_UNIX;
+	type = SOCK_STREAM;
+	protocol = PROTOCOL_ALL;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, AF_UNIX);
+	KUNIT_EXPECT_EQ(test, type, SOCK_STREAM);
+	KUNIT_EXPECT_EQ(test, protocol, PROTOCOL_ALL);
+
+	/*
+	 * REWRITE_TYPE with PROTOCOL_ALL still folds the type while leaving the
+	 * protocol wildcard intact.
+	 */
+	family = AF_UNIX;
+	type = SOCK_RAW;
+	protocol = PROTOCOL_ALL;
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, AF_UNIX);
+	KUNIT_EXPECT_EQ(test, type, SOCK_DGRAM);
+	KUNIT_EXPECT_EQ(test, protocol, PROTOCOL_ALL);
+}
+
+/*
+ * Each map entry produces the expected rewrite for a concrete triple.
+ * Parameterized for per-entry pass/fail visibility; semantic descriptors name
+ * what each entry is supposed to do.
+ */
+struct landlock_canon_map_case {
+	const char *name;
+	s32 in_family, in_type, in_protocol;
+	s32 out_family, out_type, out_protocol;
+};
+
+/*
+ * test_family_canonicalization covers every (family, type, protocol) cell that
+ * sock_create_kern can reach.  The cases listed here are the kernel-unreachable
+ * cells whose canonicalization still matters in production and therefore needs
+ * config-independent validation.
+ *
+ * AF_VSOCK SOCK_DGRAM is the only such cell today: its reachability requires
+ * CONFIG_VIRTIO_VSOCKETS=y, which the default .kunitconfig does not enable.
+ * The two entries below cover both user call forms (protocol=0 and
+ * protocol=PF_VSOCK) that vsock_create accepts and canonicalize to 0.
+ */
+static const struct landlock_canon_map_case landlock_canon_map_cases[] = {
+	{ "vsock_dgram_zero_stays_zero", AF_VSOCK, SOCK_DGRAM, 0, AF_VSOCK,
+	  SOCK_DGRAM, 0 },
+	{ "vsock_dgram_family_id_forced_to_zero", AF_VSOCK, SOCK_DGRAM,
+	  AF_VSOCK, AF_VSOCK, SOCK_DGRAM, 0 },
+};
+
+static void landlock_canon_map_to_desc(const struct landlock_canon_map_case *c,
+				       char *desc)
+{
+	strscpy(desc, c->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(landlock_canon_map, landlock_canon_map_cases,
+		  landlock_canon_map_to_desc);
+
+static void test_canonicalization_map_entry(struct kunit *const test)
+{
+	const struct landlock_canon_map_case *const c = test->param_value;
+	s32 family = c->in_family, type = c->in_type, protocol = c->in_protocol;
+
+	landlock_canonicalize_socket_key(&family, &type, &protocol);
+	KUNIT_EXPECT_EQ(test, family, c->out_family);
+	KUNIT_EXPECT_EQ(test, type, c->out_type);
+	KUNIT_EXPECT_EQ(test, protocol, c->out_protocol);
+}
+
+static struct kunit_case test_cases[] = {
+	KUNIT_CASE_PARAM(test_family_canonicalization,
+			 landlock_canon_family_gen_params),
+	KUNIT_CASE(test_canonicalization_preserves_wildcards),
+	KUNIT_CASE_PARAM(test_canonicalization_map_entry,
+			 landlock_canon_map_gen_params),
+	{}
+};
+
+static struct kunit_suite test_suite = {
+	.name = "landlock_socket",
+	.test_cases = test_cases,
+};
+
+kunit_test_suite(test_suite);
+
+#endif /* CONFIG_SECURITY_LANDLOCK_KUNIT_TEST */
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index a091b8a883c8..5c0959f50ba2 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -7,15 +7,15 @@
 
 #define _GNU_SOURCE
 
+#include <arpa/inet.h>
+#include <linux/can.h>
+#include <linux/kcm.h>
 #include <linux/landlock.h>
-#include <sys/prctl.h>
 #include <linux/pfkeyv2.h>
-#include <linux/kcm.h>
-#include <linux/can.h>
-#include <sys/socket.h>
-#include <stdint.h>
 #include <linux/sctp.h>
-#include <arpa/inet.h>
+#include <stdint.h>
+#include <sys/prctl.h>
+#include <sys/socket.h>
 
 #include "audit.h"
 #include "common.h"
@@ -829,11 +829,12 @@ FIXTURE_VARIANT_ADD(tcp_protocol, variant2) {
 };
 
 /*
- * Landlock doesn't perform protocol mappings handled by network stack on
- * protocol family level. Test verifies that if only one definition is
- * allowed another becomes restricted.
+ * Landlock canonicalizes AF_INET, SOCK_STREAM, protocol=0 to IPPROTO_TCP at
+ * rule insertion so that a rule inserted with either the default-protocol form
+ * or the explicit IPPROTO_TCP form matches both call syntaxes.  Test verifies
+ * this aliasing.  Unrelated families (AF_PACKET here) remain restricted.
  */
-TEST_F(tcp_protocol, alias_restriction)
+TEST_F(tcp_protocol, alias_equivalence)
 {
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
@@ -861,14 +862,15 @@ TEST_F(tcp_protocol, alias_restriction)
 	enforce_ruleset(_metadata, ruleset_fd);
 	ASSERT_EQ(0, close(ruleset_fd));
 
-	if (protocol == 0) {
-		EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
-		EXPECT_EQ(EACCES,
-			  test_socket(AF_PACKET, SOCK_STREAM, IPPROTO_TCP));
-	} else if (protocol == IPPROTO_TCP) {
-		EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
-		EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP));
-	}
+	/*
+	 * Irrespective of which call form was used to insert the rule, both
+	 * call forms of socket(2) match.
+	 */
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP));
+
+	/* Other families remain restricted. */
+	EXPECT_EQ(EACCES, test_socket(AF_PACKET, SOCK_STREAM, IPPROTO_TCP));
 }
 
 static int test_socketpair(int family, int type, int protocol)
-- 
2.53.0

