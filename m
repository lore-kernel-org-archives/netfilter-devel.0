Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032843;
	b=mK/8NtV3VMf1VAEgwQjouhZyFkYTRo/ZANSCzT/w/At7aX3eE16j83uJBKxVgSnturTg
	 2Q/nTC20oH8dGX4GNoSbVRQ68ghB0wmNJ6HEBCWnpzwc0PCsbGaRbvY1nH/dyAz/V4OcV
	 +7k3Y0EAVO8XV1iwD+as+WdE/r0aBBvccolmuK+olkK80US7QEIdiSBk+GzE3WUTTTva3
	 +HYeIKxh/yiqDuAC9LicRBwWiqO3g154z7aWQaVC9++4A1Ojr2RJvd9Jtr8eenNybpAtt
	 XPweMfFEG0karluGkU5qsis4XhkriYBXLC3tSV8qAaDR628gi313MX4nhs/QgLOmeDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032843;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=vSBhZbeGE3VX6ynSB31DPcPBMZfKELXkzIaDElyU+Zc=;
	b=T8wXUFaA9/nVPKtr9JJvJu80n+pCeeqIbsVR59A/0RIF6YSs2jEW8UlW4ppsbDwJmEeX
	 zEpf2fTX7Zyc/IQVpDfHH8jvAQW56zsrRJP8SPgDvQ4VpNsmGTAGafEN34n/Fi0HeollQ
	 nDneORDMoTAfJjQusX5qrT0KPLVV7lHwIkcFypbjQ4Hxme2RLVLnPdxBty/nNMsQi/Y+P
	 NIMwg+LKBflqcPE6+OuAf2kUShaWY4uWlfJvQ2nQ9KMIaVPegzNvFxXCsDU8EAT4bpj5f
	 n7sy6i/V14uvOM9Jty5LP+wvhtdR5xdZRQf5PwwymtNolW5E8UnnAm8ZObzv5nyamVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="ERW5y/pZ";
	arc=none smtp.remote-ip=209.85.160.99
Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6F360A3814
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 20:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC6F360A3814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ERW5y/pZ
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-4a85c656c58so992118fac.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795032841; x=1795637641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vSBhZbeGE3VX6ynSB31DPcPBMZfKELXkzIaDElyU+Zc=;
        b=zY7ub4fjW70U8WAprW7rzB1qCowEFkf+Yo3NmcTl9eFpVsuAwACKVRRwOSdIbVcnls
         Tv2FtmEUlrvB8cXl0ZS6VPyo5JJxG2Rm8z6VrnuAp1QFPQeHDHUYsRd9q9JRo40+O9TO
         X8GGSgaAvV2k/XQwLJPdqrNlHB3XPDheB7UxOX8i8LRX0X7ieGmrWmMukK/Tigch55UB
         JjbjKEWuZRrpGXXz2nI2WC99DqM7YD/U6JBo1ykvIn4fCDZsst8mCnyS8UVrD/Am+HLB
         p9qtFrcnfLawdf1H/WyGmj3w5tEobYihUrVbu4mLm6VUTcOG54P9nOrFwiNJQYcBENPg
         vzVw==
X-Forwarded-Encrypted: i=1; AL+hErEBv1FVhDckv2+xKJ/ow2V3oniTXzcb9FEayLjQCW3fAvNFa9c/LXU8emrb8IGumGs4G973XYENtpHTgqT0oqQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8MIrBjo83XmPprAYea/CaWR+cKLAEArUTr5B5Iyw8BjuSHV21t
	E3fQBXNpDDZ8X6+vgUXcKYCDn96VLKUbX+0QBOZUrh3p1rDm7wX+/S8rltz6XOwGaDQ9rPa0039
	yP+hqJC31I4Owi+Ysw52U2W2C53AF7IThpg9vtv8pK3nNTg8ZAKmn4vgZbEUs8Ja+fXNoq4eN1W
	tNyNyTForTQ8AZ81BDxovBbl5yzWRk/v7xDVga1hmtgsmx0khs87MGNcxXE7irG2zUoe/Di666M
	y1hdUkSjr9GShNCzLv9qQveGtSl
X-Gm-Gg: AYBFou0EpVZCwS26yIxt/nxEaL+rt5srUCtj3Ium5f36QZpZa0LpA+pTOB6g5ernBhE
	0fy0x3D0VjBsPdtMmIWvX6zBl3b7FO1MsP+qQ9SargoHtWJTWTvAnMcHTuAz4XBLOOR/A/rpx9Q
	i7orgq1QqJlaZ1hdTrZuQNQjbzpcBDqOGCK+0bWFjZX6rLm2xynoieDxgQUIohYQTGraXtl8aRR
	Mh8NguUFQmsdq4KqTtkLshoh2zCMJvgg/AZJEAPKngU6GNFc6+1MsvSk3o/RAwO2eQvMYQD4Bi4
	ke4KUz91hc2UNdTNhYK2Yxr2saOdLHVoBu4HoWn2bS9hN+i+9v5CgDGzIcs4xJGZhhe96XBHWE5
	pN9cdV0w9jT/MD6BLC+bPkd6XxmaHpQFbTYo0uv65miXB68sk1ElaeUY4BD2PXSGvd4XhNci4jk
	1fFOxpZbrst5hQKIXxvWrIUzLFTsBPY6HLIUykgwrq
X-Received: by 2002:a05:6870:5586:b0:4a6:9418:da4e with SMTP id 586e51a60fabf-4b762ca496dmr3237031fac.60.1795032841426;
        Wed, 18 Nov 2026 12:14:01 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4b73fc59bf3sm39123fac.3.2026.11.18.12.14.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:14:01 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-55c644cea0bso28291561cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795032840; x=1795637640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vSBhZbeGE3VX6ynSB31DPcPBMZfKELXkzIaDElyU+Zc=;
        b=ERW5y/pZa02HZWFqIP4pk4md7RjaXJOTzIG4miGCEG3WevVGToLUFcHlIRjQuO5Z8g
         /pFHojz/MfA3TfWLBBZHXxEtknBK9OIFVr5wE0aMl0StQ3mQifDYv/YqR3BqGSt5xqam
         gWLLWQgLoQwtzU74USWJJOKhVv8KwtgMOb4E4=
X-Forwarded-Encrypted: i=1; AL+hErEMN+MgImqsbCjZbr8aI+on5RPclCkwRQmhahPKPc+LfNwWK3mJ/T0JDi+z/kmwrp0nyfJMALr0iSYkhw7S1NA=@vger.kernel.org
X-Received: by 2002:a05:622a:a0b:b0:55c:cff6:5683 with SMTP id d75a77b69052e-55d5a3087d5mr57399901cf.1.1795032840085;
        Wed, 18 Nov 2026 12:14:00 -0800 (PST)
X-Received: by 2002:a05:622a:a0b:b0:55c:cff6:5683 with SMTP id d75a77b69052e-55d5a3087d5mr57399301cf.1.1795032839284;
        Wed, 18 Nov 2026 12:13:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c2a5a2sm7675091cf.21.2026.11.18.12.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 12:13:58 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Toshiaki Makita <toshiaki.makita1@gmail.com>,
	linux-kernel@vger.kernel.org (open list),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH net 4/4] selftests: netfilter: check the GRE timeout after flowtable teardown
Date: Wed, 18 Nov 2026 12:12:50 -0800
Message-ID: <20261118201250.2075007-5-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add a test for "netfilter: flowtable: restore the GRE conntrack timeout on
teardown". A GRE tunnel between two namespaces goes through a router with a
flowtable offloading the GRE flow. The flowtable is removed, which tears
the flow down, and the timeout of the conntrack entry must be the GRE one,
not the day set when the flow was offloaded.

Without the fix, the entry has 86399 seconds left after teardown and the
test fails. With it, the entry has 179 seconds left, the GRE stream
timeout minus the time which went by.

Add the GRE tunnel and conntrack helper options to the config.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   3 +
 .../net/netfilter/nft_flowtable_gre.sh        | 137 ++++++++++++++++++
 3 files changed, 141 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 75d7d4495623..eefc520f3a0e 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -30,6 +30,7 @@ TEST_PROGS := \
 	nft_fib.sh \
 	nft_fib_nexthop.sh \
 	nft_flowtable.sh \
+	nft_flowtable_gre.sh \
 	nft_flowtable_hw_destroy.sh \
 	nft_interface_stress.sh \
 	nft_meta.sh \
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index bf7be95f7d25..5525f05d0eb6 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -55,6 +55,8 @@ CONFIG_NETFILTER_XT_MATCH_STATE=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_NAT=m
 CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
+CONFIG_NET_IPGRE=m
+CONFIG_NET_IPGRE_DEMUX=m
 CONFIG_NET_IPIP=m
 CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_NET_NS=y
@@ -66,6 +68,7 @@ CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CONNTRACK_EVENTS=y
 CONFIG_NF_CONNTRACK_FTP=m
 CONFIG_NF_CONNTRACK_MARK=y
+CONFIG_NF_CONNTRACK_PPTP=m
 CONFIG_NF_CONNTRACK_PROCFS=y
 CONFIG_NF_CONNTRACK_ZONES=y
 CONFIG_NF_CT_NETLINK=m
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh b/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh
new file mode 100755
index 000000000000..5efad6908b3f
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh
@@ -0,0 +1,137 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Check the conntrack timeout of a GRE flow once its flowtable entry is
+# removed. A GRE flow is offloaded with the timeout of its conntrack entry set
+# to a day, which is restored to the GRE timeout when the flow is torn down.
+#
+# ns1 (10.0.1.2) <-> nsr1 (10.0.1.1, 10.0.2.1) <-> ns2 (10.0.2.2)
+#
+# A GRE tunnel connects ns1 and ns2, and nsr1 offloads the tunnel's flow.
+
+source lib.sh
+
+ret=0
+
+checktool "nft --version" "run test without nft tool"
+checktool "conntrack --version" "run test without conntrack tool"
+
+setup_ns ns1 ns2 nsr1
+
+cleanup() {
+	cleanup_all_ns
+}
+
+trap cleanup EXIT
+
+ip link add veth0 netns "$nsr1" type veth peer name eth0 netns "$ns1"
+ip link add veth1 netns "$nsr1" type veth peer name eth0 netns "$ns2"
+
+ip -net "$nsr1" link set veth0 up
+ip -net "$nsr1" link set veth1 up
+ip -net "$nsr1" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsr1" addr add 10.0.2.1/24 dev veth1
+ip netns exec "$nsr1" sysctl -q net.ipv4.conf.all.forwarding=1
+
+ip -net "$ns1" link set eth0 up
+ip -net "$ns1" addr add 10.0.1.2/24 dev eth0
+ip -net "$ns1" route add 10.0.2.0/24 via 10.0.1.1
+
+ip -net "$ns2" link set eth0 up
+ip -net "$ns2" addr add 10.0.2.2/24 dev eth0
+ip -net "$ns2" route add 10.0.1.0/24 via 10.0.2.1
+
+if ! ip -net "$ns1" link add gre1 type gre local 10.0.1.2 remote 10.0.2.2 2>/dev/null; then
+	echo "SKIP: Could not create a GRE tunnel"
+	exit $ksft_skip
+fi
+ip -net "$ns2" link add gre1 type gre local 10.0.2.2 remote 10.0.1.2
+
+ip -net "$ns1" addr add 192.168.100.1/30 dev gre1
+ip -net "$ns1" link set gre1 up
+ip -net "$ns2" addr add 192.168.100.2/30 dev gre1
+ip -net "$ns2" link set gre1 up
+
+if ! ip netns exec "$nsr1" nft -f - <<EOF
+table inet filter {
+	flowtable ft {
+		hook ingress priority 0
+		devices = { veth0, veth1 }
+	}
+
+	chain forward {
+		type filter hook forward priority 0; policy accept
+		ip protocol gre ct state established flow add @ft
+	}
+}
+EOF
+then
+	echo "SKIP: Could not load the flowtable ruleset"
+	exit $ksft_skip
+fi
+
+# The timeout of an offloaded entry is not shown by the conntrack tool.
+gre_entry_offloaded()
+{
+	ip netns exec "$nsr1" conntrack -L -p gre 2>/dev/null | grep -q OFFLOAD
+}
+
+gre_entry_timeout()
+{
+	ip netns exec "$nsr1" conntrack -L -p gre 2>/dev/null | \
+		sed -n 's/^gre *47 \([0-9]*\) .*/\1/p' | head -n 1
+}
+
+gre_ping()
+{
+	ip netns exec "$ns1" ping -q -c 1 -W 1 192.168.100.2 > /dev/null
+}
+
+if ! gre_ping; then
+	echo "FAIL: no connectivity through the GRE tunnel"
+	exit 1
+fi
+
+# Keep sending, the flow needs a packet after the entry is established.
+offloaded=0
+for i in $(seq 1 10); do
+	gre_ping
+	if gre_entry_offloaded; then
+		offloaded=1
+		break
+	fi
+	sleep 0.5
+done
+
+if [ "$offloaded" -eq 0 ]; then
+	echo "SKIP: The GRE flow was not offloaded"
+	exit $ksft_skip
+fi
+
+# The entry has the timeout of an offloaded flow: remove the flowtable, which
+# tears down its flows. Nothing else refreshes the conntrack entry.
+if ! ip netns exec "$nsr1" nft delete table inet filter; then
+	echo "FAIL: could not remove the flowtable"
+	exit 1
+fi
+
+if gre_entry_offloaded; then
+	echo "FAIL: the GRE entry is still marked as offloaded"
+	ret=1
+fi
+
+timeout=$(gre_entry_timeout)
+max=$(ip netns exec "$nsr1" sysctl -n net.netfilter.nf_conntrack_gre_timeout_stream 2>/dev/null)
+[ -z "$max" ] && max=180
+
+if [ -z "$timeout" ]; then
+	echo "FAIL: no conntrack entry for the GRE flow"
+	ret=1
+elif [ "$timeout" -gt "$max" ]; then
+	echo "FAIL: the GRE entry timeout is $timeout seconds after teardown, expected at most $max"
+	ret=1
+else
+	echo "PASS: the GRE entry timeout was restored to $timeout seconds"
+fi
+
+exit $ret
-- 
2.53.0

