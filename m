Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C916C6BC;
	Thu, 18 Apr 2024 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454247; cv=none; b=YgQhgEBIhMDJLW/WsiStwnonuuq5D7UW1E7KrhTrpN5lIWomLuNA9qqpenPCIPZ3XMDYQ+wNsVlvGb+/9fhj+DGhO7D5zXFd5vZQ6bxH0EREQpYW6nJkf2bVdyEXT0p8Ostvp9HphEjHeMfFeIeG8VNld/M/9gxeoJcjZ3xHHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454247; c=relaxed/simple;
	bh=oYmUvty/M2wWYG1xRWp4+UNkVL0RpjAmjgB26Ukv4q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVywSrDFI6o+/xBrABpwNYYQqSbX3fe1HMmceZuPr/c7ZJzgeaw4bgX6Mo6C4F39dGzdx9sc8VZIdTVL12DStd+6hvy6dDcNweSgwr0ScgHfHjawK2meQf8NSe31cEKazRPR0pDfu2K3d/nGnsYCEs/8M+JlOpO3sBkL7vc7nqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTik-0000Bh-0U; Thu, 18 Apr 2024 17:30:42 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 12/12] selftests: netfilter: update makefiles and kernel config
Date: Thu, 18 Apr 2024 17:27:40 +0200
Message-ID: <20240418152744.15105-13-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
References: <20240418152744.15105-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports the Makefile missed a few updates to make kselftest-install
work for the netfilter tests and points out that config file lacks many
dependencies such as VETH support.

The settings file (timeout 8m) is added for nft_concat_range.sh script
which can take several minutes to complete.

Fixes: 3f189349e52a ("selftests: netfilter: move to net subdir")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/all/20240412175413.04e5e616@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
  - more config updates
  - test with vng as per https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
  - set 8m default timeout, default 45s is too short

 .../testing/selftests/net/netfilter/Makefile  |  5 ++
 tools/testing/selftests/net/netfilter/config  | 52 ++++++++++++++++++-
 .../testing/selftests/net/netfilter/settings  |  1 +
 3 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/netfilter/settings

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index dd9a75a33d28..68e4780edfdc 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -42,3 +42,8 @@ $(OUTPUT)/nf_queue: LDLIBS += $(MNL_LDLIBS)
 
 $(OUTPUT)/conntrack_dump_flush: CFLAGS += $(MNL_CFLAGS)
 $(OUTPUT)/conntrack_dump_flush: LDLIBS += $(MNL_LDLIBS)
+
+TEST_FILES := lib.sh
+
+TEST_INCLUDES := \
+	../lib.sh
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 9df6a9f11384..60b86c7f3ea1 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -1,37 +1,87 @@
 CONFIG_AUDIT=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_BRIDGE=m
 CONFIG_BRIDGE_EBT_BROUTE=m
+CONFIG_BRIDGE_EBT_IP=m
 CONFIG_BRIDGE_EBT_REDIRECT=m
+CONFIG_BRIDGE_EBT_T_FILTER=m
 CONFIG_BRIDGE_NETFILTER=m
+CONFIG_BRIDGE_NF_EBTABLES=m
+CONFIG_CGROUP_BPF=y
+CONFIG_DUMMY=m
+CONFIG_INET_ESP=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP6_NF_MATCH_RPFILTER=m
+CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP6_NF_IPTABLES=m
+CONFIG_IP_NF_FILTER=m
+CONFIG_IP6_NF_FILTER=m
+CONFIG_IP_NF_RAW=m
+CONFIG_IP6_NF_RAW=m
 CONFIG_IP_SCTP=m
 CONFIG_IP_VS=m
 CONFIG_IP_VS_PROTO_TCP=y
+CONFIG_IP_VS_RR=m
+CONFIG_IPV6=y
+CONFIG_IPV6_MULTIPLE_TABLES=y
+CONFIG_MACVLAN=m
+CONFIG_NAMESPACES=y
 CONFIG_NET_CLS_U32=m
+CONFIG_NET_L3_MASTER_DEV=y
+CONFIG_NET_NS=y
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_HTB=m
 CONFIG_NET_IPIP=m
 CONFIG_NET_VRF=y
+CONFIG_NETFILTER=y
+CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NETFILTER_NETLINK=m
+CONFIG_NETFILTER_NETLINK_QUEUE=m
 CONFIG_NETFILTER_SYNPROXY=m
+CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XT_NAT=m
+CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
+CONFIG_NETFILTER_XT_MATCH_STATE=m
+CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
 CONFIG_NF_CONNTRACK=m
-CONFIG_NF_CONNTRACK_EVENTS=m
+CONFIG_NF_CONNTRACK_EVENTS=y
+CONFIG_NF_CONNTRACK_FTP=m
+CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_CONNTRACK_ZONES=y
 CONFIG_NF_CT_NETLINK=m
 CONFIG_NF_CT_PROTO_SCTP=y
+CONFIG_NF_FLOW_TABLE=m
+CONFIG_NF_LOG_IPV4=m
+CONFIG_NF_LOG_IPV6=m
+CONFIG_NF_NAT=m
+CONFIG_NF_NAT_REDIRECT=y
+CONFIG_NF_NAT_MASQUERADE=y
 CONFIG_NF_TABLES=m
+CONFIG_NF_TABLES_BRIDGE=m
 CONFIG_NF_TABLES_INET=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NF_TABLES_IPV6=y
+CONFIG_NF_TABLES_NETDEV=y
+CONFIG_NF_FLOW_TABLE_INET=m
+CONFIG_NFT_BRIDGE_META=m
+CONFIG_NFT_COMPAT=m
 CONFIG_NFT_CT=m
 CONFIG_NFT_FIB=m
 CONFIG_NFT_FIB_INET=m
 CONFIG_NFT_FIB_IPV4=m
 CONFIG_NFT_FIB_IPV6=m
+CONFIG_NFT_FLOW_OFFLOAD=m
+CONFIG_NFT_LIMIT=m
+CONFIG_NFT_LOG=m
 CONFIG_NFT_MASQ=m
 CONFIG_NFT_NAT=m
+CONFIG_NFT_NUMGEN=m
 CONFIG_NFT_QUEUE=m
+CONFIG_NFT_QUOTA=m
 CONFIG_NFT_REDIR=m
 CONFIG_NFT_SYNPROXY=m
+CONFIG_VETH=m
+CONFIG_VLAN_8021Q=m
+CONFIG_XFRM_USER=m
+CONFIG_XFRM_STATISTICS=y
diff --git a/tools/testing/selftests/net/netfilter/settings b/tools/testing/selftests/net/netfilter/settings
new file mode 100644
index 000000000000..288bd9704773
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/settings
@@ -0,0 +1 @@
+timeout=500
-- 
2.43.2

