Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=104.143.10.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794090046;
	b=uSbVNTvOxSjVsNCMayQNDZLAlOXS8vL8Qf02yg3DjOzaC8ucA5K/tDxOaMWvYe9gJF0Y
	 9LGEg5KVwO8rwWfb6oAmQQd8rnTpdKv70McmhzmlDblt7oYhu2nVUgPB5tiHadUMXFx4Y
	 /MU2Q0lk2BY8fg/HFt/+GVeGaACpgPiJRAqgSKuDHzjlkAp/cFj/3BZt7MQveTvom60px
	 m/EEubYNmBiGUkAEzilT5S9XKGthGEm+uPDO7amfcZ93WnN3ybxsKPL+zXaAqUk0EOi+V
	 8Te3DIaJYeAU7d9oRuhW8VpxL1+bYTc7nSe86mAEe5pIyoi4KrKGot96anAYRyYh2Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794090046;
	h=DMARC-Filter:From:To:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=c3AYCl4GhJ6x0FuItWBgadcsXDCw8a/shkUdEGXbd6U=;
	b=mMVym/20jKt3uSk5l0moZHA52wr7HD5eoVpd8EYH1+x2rnub9KKmo+IH/nj4tI7QqgJa
	 AwteXgsXo9RLcFAvWQuMHhqw6soCE4ArGni7d4pJXO0xqGJcZENraOuS6FjsK16qQLXQk
	 +W75jq/+Kk5tCC0hQt9CE5Y6FfZB5ZE4306Eh7SsNQv+vHiMpflT4w+7jGijElCaayVfo
	 upmFj0DC05fa77efp60xMuFKE5z365YyAx2ZyUjaDRGunQb5e73E2Sje6f+3kOHKaboF4
	 VuqfUl4Rs7XJwCarX8iWh7uCjuGQ6NCpz6pzvZ3ks4NtedsF4DBQrolUnOxXoyprfRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=volth.com;
	spf=fail smtp.mailfrom=volth.com;
	arc=none smtp.remote-ip=104.143.10.26
Received: from [127.0.1.1] (unknown [104.143.10.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67798606A326
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2026 22:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67798606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=volth.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=volth.com
From: volth.rick1 <volth.rick1@volth.com>
To: netfilter-devel@vger.kernel.org
Subject: xtables-addons 3.31: ASN IPv6 matches fail on little-endian hosts
 (16-bit vs 32-bit byte swapping)
Date: Sat, 07 Nov 2026 22:20:43 +0000
Message-ID: <179409004340.24186.9860569313407121540@volth.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hello,

The ASN match in xtables-addons 3.31 has an IPv6 byte-order mismatch between
libxt_asn and xt_asn. A correctly loaded IPv6 rule does not match packets
whose addresses are present in its database.

Reproduced in x86_64 QEMU VMs, Linux 5.15.225, with both iptables-legacy
1.8.4 and 1.8.13. IPv4 ASN matching works, and the equivalent IPv6 GeoIP
match also works. The issue is present in upstream commit
17d1e934408f2802204b0fb03f96522dc32f5c96 (v3.31 and the current master
checked on 2026-11-07).

No MaxMind download is needed to reproduce it. In a clean test VM, as root,
with the xt_asn module and userspace plugin installed:

    mkdir -p /usr/share/xt_asn
    perl -MSocket=3DAF_INET6,inet_pton -e '$a =3D inet_pton(AF_INET6, "::1");=
 print $a, $a' > /usr/share/xt_asn/64512.iv6
    ip6tables -N asn-repro
    ip6tables -A asn-repro -m asn --dst-asn 64512 -j RETURN
    ip6tables -I OUTPUT -d ::1 -j asn-repro
    ping -6 -c 1 ::1
    ip6tables -nvxL asn-repro

The database contains a single inclusive range, ::1 through ::1, as two
16-byte network-order addresses. The ping succeeds, but the ASN rule's
packet counter stays zero. It should count the loopback ICMPv6 packets.

Cleanup:

    ip6tables -D OUTPUT -d ::1 -j asn-repro
    ip6tables -F asn-repro
    ip6tables -X asn-repro
    rm /usr/share/xt_asn/64512.iv6

Cause:

* asn/xt_asn_build, writeASN(), writes IPv6 ranges using inet_pton, i.e. netw=
ork
  byte order. The synthetic database above uses exactly that encoding.
* extensions/libxt_asn.c, asn_swap_in6(), swaps eight 16-bit words on
  little-endian hosts.
* extensions/xt_asn.c, xt_asn_mt6(), converts the packet's IPv6 address
  using ntohl on four 32-bit words. ipv6_cmp() then compares those
  32-bit words with the database's words.

For ::1, the plugin therefore supplies a final 32-bit word with numeric
value 0x00010000, while the kernel compares it with 0x00000001.

libxt_geoip.c does not have this mismatch: geoip_swap_in6() swaps four
32-bit words. The analogous change in ASN's userspace conversion makes
the reproducer pass. We also verified IPv4/IPv6 positive and negative
matches and iptables-save/restore in both VM configurations afterwards.

This report intentionally contains no patch.
