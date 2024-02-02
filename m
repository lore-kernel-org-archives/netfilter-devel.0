Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4997547A48
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881999; cv=none; b=fvrdWuYCAI1Oeww7zVmzVkq/G3Am3wrkSrCf6pZI18z4SFnTT1Ifg39tZSVSbEFoNU+NWXKbN7IeLwn2addJaSbzpa/XsxkkFanmPGCGSmWVLqX/f11rMxSe1JhMIdgjIyluLjzMYCs9d8nt9OXi5y6ur+66ZOvmnA/hTeL+Qyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881999; c=relaxed/simple;
	bh=xMkA9Fk3uLo45mfdcaMPwWEGVwehog8WM6sYz1glbjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzd4OhdG3NTXl40IRAw2sGS9Qpsvr62lVGpAc1diaEU32EZAeNdccA16szYS5+LTChIRxOyLGKU9dD96vClu5RXgod1uphM/HI5TA/4Gxw9dRlhsNfKAYT8a1aJq0nv/p6yg7PciV9dC6jVpASz/P5ezXuPCVN8YLCdbaivRIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NJI6dY1r; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NJI6dY1r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XIq+VJN6/9H7oa2cLLLMZzIEs+eXyGLkpkNtcQ7swDA=; b=NJI6dY1rK2qvL+k4DTLv09aUwx
	COWWuonr+MT6zd4M1Y4ih3EODe3HZq+i1lAM/S0GUmT/cEqyo+etZZ6wtcvm7Xm4i/PztbfaWFXTZ
	6GTlNYfSwZs3FbYuUlm0VkCX6tgcnoIETDFRH3lq+xyBQy5QUNGoFSdm3r0taKnHVm3tlmcCZUfOu
	lmIJr4u5q+P/diyeOq1ND60dUQEyJTzmPIZULPl7OqdyUWhGpoXGpxNNp+FEKRNGXWrzkl8J9A7Nh
	eTq/sZjy9GeQal1eb4XcFVdr3SukCOXVdMOGL0WAG2RNQrK/t58oq3Mb6bD0cNTVCbfPlF0BtwJBT
	cyYIi9RA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyg-000000003BZ-2OSM;
	Fri, 02 Feb 2024 14:53:10 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 01/12] extensions: *.t/*.txlate: Test range corner-cases
Date: Fri,  2 Feb 2024 14:52:56 +0100
Message-ID: <20240202135307.25331-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For every extension option accepting a range, test open and half-open as
well as single element and invalid (negative) ranges.

The added tests merely reflect the status quo, not the expected outcome.
Following patches will fix results and the already existing test cases
highlight the fixes' effects.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.t         | 12 +++++++++
 extensions/libebt_ip6.t        | 12 +++++++++
 extensions/libebt_stp.t        | 45 ++++++++++++++++++++++++++++++++++
 extensions/libip6t_ah.t        |  6 +++++
 extensions/libip6t_ah.txlate   |  6 +++++
 extensions/libip6t_frag.t      |  6 +++++
 extensions/libip6t_frag.txlate |  6 +++++
 extensions/libip6t_mh.t        |  6 +++++
 extensions/libip6t_mh.txlate   |  9 +++++++
 extensions/libip6t_rt.t        |  6 +++++
 extensions/libip6t_rt.txlate   |  9 +++++++
 extensions/libipt_ah.t         |  6 +++++
 extensions/libipt_ah.txlate    |  6 +++++
 extensions/libxt_NFQUEUE.t     |  7 ++++++
 extensions/libxt_connbytes.t   |  6 +++++
 extensions/libxt_conntrack.t   | 26 ++++++++++++++++++++
 extensions/libxt_dccp.t        | 10 ++++++++
 extensions/libxt_esp.t         |  7 ++++++
 extensions/libxt_esp.txlate    | 12 +++++++++
 extensions/libxt_ipcomp.t      |  7 ++++++
 extensions/libxt_length.t      |  3 +++
 extensions/libxt_tcp.t         | 12 +++++++++
 extensions/libxt_tcp.txlate    |  6 +++++
 extensions/libxt_tcpmss.t      |  4 +++
 extensions/libxt_udp.t         | 12 +++++++++
 extensions/libxt_udp.txlate    |  6 +++++
 26 files changed, 253 insertions(+)

diff --git a/extensions/libebt_ip.t b/extensions/libebt_ip.t
index cfe4f54db5f66..a9b5b8b5ea244 100644
--- a/extensions/libebt_ip.t
+++ b/extensions/libebt_ip.t
@@ -6,6 +6,18 @@
 -p IPv4 ! --ip-tos 0xFF;=;OK
 -p IPv4 --ip-proto tcp --ip-dport 22;=;OK
 -p IPv4 --ip-proto udp --ip-sport 1024:65535;=;OK
+-p IPv4 --ip-proto udp --ip-sport :;-p IPv4 --ip-proto udp --ip-sport 0:65535;OK
+-p IPv4 --ip-proto udp --ip-sport :4;-p IPv4 --ip-proto udp --ip-sport 0:4;OK
+-p IPv4 --ip-proto udp --ip-sport 4:;-p IPv4 --ip-proto udp --ip-sport 4:65535;OK
+-p IPv4 --ip-proto udp --ip-sport 3:4;=;OK
+-p IPv4 --ip-proto udp --ip-sport 4:4;-p IPv4 --ip-proto udp --ip-sport 4;OK
+-p IPv4 --ip-proto udp --ip-sport 4:3;;FAIL
+-p IPv4 --ip-proto udp --ip-dport :;-p IPv4 --ip-proto udp --ip-dport 0:65535;OK
+-p IPv4 --ip-proto udp --ip-dport :4;-p IPv4 --ip-proto udp --ip-dport 0:4;OK
+-p IPv4 --ip-proto udp --ip-dport 4:;-p IPv4 --ip-proto udp --ip-dport 4:65535;OK
+-p IPv4 --ip-proto udp --ip-dport 3:4;=;OK
+-p IPv4 --ip-proto udp --ip-dport 4:4;-p IPv4 --ip-proto udp --ip-dport 4;OK
+-p IPv4 --ip-proto udp --ip-dport 4:3;;FAIL
 -p IPv4 --ip-proto 253;=;OK
 -p IPv4 ! --ip-proto 253;=;OK
 -p IPv4 --ip-proto icmp --ip-icmp-type echo-request;=;OK
diff --git a/extensions/libebt_ip6.t b/extensions/libebt_ip6.t
index 58e3c73c99409..cb1be9e355bac 100644
--- a/extensions/libebt_ip6.t
+++ b/extensions/libebt_ip6.t
@@ -10,6 +10,18 @@
 -p IPv6 --ip6-proto tcp ! --ip6-dport 22;=;OK
 -p IPv6 --ip6-proto tcp ! --ip6-sport 22 --ip6-dport 22;=;OK
 -p IPv6 --ip6-proto udp --ip6-sport 1024:65535;=;OK
+-p IPv6 --ip6-proto udp --ip6-sport :;-p IPv6 --ip6-proto udp --ip6-sport 0:65535;OK
+-p IPv6 --ip6-proto udp --ip6-sport :4;-p IPv6 --ip6-proto udp --ip6-sport 0:4;OK
+-p IPv6 --ip6-proto udp --ip6-sport 4:;-p IPv6 --ip6-proto udp --ip6-sport 4:65535;OK
+-p IPv6 --ip6-proto udp --ip6-sport 3:4;=;OK
+-p IPv6 --ip6-proto udp --ip6-sport 4:4;-p IPv6 --ip6-proto udp --ip6-sport 4;OK
+-p IPv6 --ip6-proto udp --ip6-sport 4:3;;FAIL
+-p IPv6 --ip6-proto udp --ip6-dport :;-p IPv6 --ip6-proto udp --ip6-dport 0:65535;OK
+-p IPv6 --ip6-proto udp --ip6-dport :4;-p IPv6 --ip6-proto udp --ip6-dport 0:4;OK
+-p IPv6 --ip6-proto udp --ip6-dport 4:;-p IPv6 --ip6-proto udp --ip6-dport 4:65535;OK
+-p IPv6 --ip6-proto udp --ip6-dport 3:4;=;OK
+-p IPv6 --ip6-proto udp --ip6-dport 4:4;-p IPv6 --ip6-proto udp --ip6-dport 4;OK
+-p IPv6 --ip6-proto udp --ip6-dport 4:3;;FAIL
 -p IPv6 --ip6-proto 253;=;OK
 -p IPv6 ! --ip6-proto 253;=;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type echo-request -j CONTINUE;=;OK
diff --git a/extensions/libebt_stp.t b/extensions/libebt_stp.t
index 06df607379f2a..f72051ac27f57 100644
--- a/extensions/libebt_stp.t
+++ b/extensions/libebt_stp.t
@@ -27,3 +27,48 @@
 ! --stp-hello-time 1;=;OK
 --stp-forward-delay 1;=;OK
 ! --stp-forward-delay 1;=;OK
+--stp-root-prio :2;--stp-root-prio 0:2;OK
+--stp-root-prio 2:;--stp-root-prio 2:65535;OK
+--stp-root-prio 1:2;=;OK
+--stp-root-prio 1:1;--stp-root-prio 1;OK
+--stp-root-prio 2:1;;FAIL
+--stp-root-cost :2;--stp-root-cost 0:2;OK
+--stp-root-cost 2:;--stp-root-cost 2:4294967295;OK
+--stp-root-cost 1:2;=;OK
+--stp-root-cost 1:1;--stp-root-cost 1;OK
+--stp-root-cost 2:1;;FAIL
+--stp-sender-prio :2;--stp-sender-prio 0:2;OK
+--stp-sender-prio 2:;--stp-sender-prio 2:65535;OK
+--stp-sender-prio 1:2;=;OK
+--stp-sender-prio 1:1;--stp-sender-prio 1;OK
+--stp-sender-prio 2:1;;FAIL
+--stp-port :;--stp-port 0:65535;OK
+--stp-port :2;--stp-port 0:2;OK
+--stp-port 2:;--stp-port 2:65535;OK
+--stp-port 1:2;=;OK
+--stp-port 1:1;--stp-port 1;OK
+--stp-port 2:1;;FAIL
+--stp-msg-age :;--stp-msg-age 0:65535;OK
+--stp-msg-age :2;--stp-msg-age 0:2;OK
+--stp-msg-age 2:;--stp-msg-age 2:65535;OK
+--stp-msg-age 1:2;=;OK
+--stp-msg-age 1:1;--stp-msg-age 1;OK
+--stp-msg-age 2:1;;FAIL
+--stp-max-age :;--stp-max-age 0:65535;OK
+--stp-max-age :2;--stp-max-age 0:2;OK
+--stp-max-age 2:;--stp-max-age 2:65535;OK
+--stp-max-age 1:2;=;OK
+--stp-max-age 1:1;--stp-max-age 1;OK
+--stp-max-age 2:1;;FAIL
+--stp-hello-time :;--stp-hello-time 0:65535;OK
+--stp-hello-time :2;--stp-hello-time 0:2;OK
+--stp-hello-time 2:;--stp-hello-time 2:65535;OK
+--stp-hello-time 1:2;=;OK
+--stp-hello-time 1:1;--stp-hello-time 1;OK
+--stp-hello-time 2:1;;FAIL
+--stp-forward-delay :;--stp-forward-delay 0:65535;OK
+--stp-forward-delay :2;--stp-forward-delay 0:2;OK
+--stp-forward-delay 2:;--stp-forward-delay 2:65535;OK
+--stp-forward-delay 1:2;=;OK
+--stp-forward-delay 1:1;--stp-forward-delay 1;OK
+--stp-forward-delay 2:1;;FAIL
diff --git a/extensions/libip6t_ah.t b/extensions/libip6t_ah.t
index c1898d44cf193..77c5383c91a6d 100644
--- a/extensions/libip6t_ah.t
+++ b/extensions/libip6t_ah.t
@@ -13,3 +13,9 @@
 -m ah --ahspi 0:invalid;;FAIL
 -m ah --ahspi;;FAIL
 -m ah;=;OK
+-m ah --ahspi :;-m ah;OK
+-m ah ! --ahspi :;-m ah;OK
+-m ah --ahspi :3;-m ah --ahspi 0:3;OK
+-m ah --ahspi 3:;-m ah --ahspi 3:4294967295;OK
+-m ah --ahspi 3:3;-m ah --ahspi 3;OK
+-m ah --ahspi 4:3;=;OK
diff --git a/extensions/libip6t_ah.txlate b/extensions/libip6t_ah.txlate
index cc33ac2718c0c..fc7248abba001 100644
--- a/extensions/libip6t_ah.txlate
+++ b/extensions/libip6t_ah.txlate
@@ -15,3 +15,9 @@ nft 'add rule ip6 filter INPUT ah spi 500 ah hdrlength != 120 counter drop'
 
 ip6tables-translate -A INPUT -m ah --ahspi 500 --ahlen 120 --ahres -j ACCEPT
 nft 'add rule ip6 filter INPUT ah spi 500 ah hdrlength 120 ah reserved 1 counter accept'
+
+ip6tables-translate -A INPUT -m ah --ahspi 0:4294967295
+nft 'add rule ip6 filter INPUT meta l4proto ah counter'
+
+ip6tables-translate -A INPUT -m ah ! --ahspi 0:4294967295
+nft 'add rule ip6 filter INPUT meta l4proto ah counter'
diff --git a/extensions/libip6t_frag.t b/extensions/libip6t_frag.t
index 299fa03f8845b..a89076708ea03 100644
--- a/extensions/libip6t_frag.t
+++ b/extensions/libip6t_frag.t
@@ -1,5 +1,11 @@
 :INPUT,FORWARD,OUTPUT
+-m frag --fragid :;-m frag;OK
+-m frag ! --fragid :;-m frag;OK
+-m frag --fragid :42;-m frag --fragid 0:42;OK
+-m frag --fragid 42:;-m frag --fragid 42:4294967295;OK
 -m frag --fragid 1:42;=;OK
+-m frag --fragid 3:3;-m frag --fragid 3;OK
+-m frag --fragid 4:3;=;OK
 -m frag --fraglen 42;=;OK
 -m frag --fragres;=;OK
 -m frag --fragfirst;=;OK
diff --git a/extensions/libip6t_frag.txlate b/extensions/libip6t_frag.txlate
index 33fc0631dc792..2b6585afbc826 100644
--- a/extensions/libip6t_frag.txlate
+++ b/extensions/libip6t_frag.txlate
@@ -15,3 +15,9 @@ nft 'add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fraglast -j ACCEPT
 nft 'add rule ip6 filter INPUT frag more-fragments 0 counter accept'
+
+ip6tables-translate -t filter -A INPUT -m frag --fragid 0:4294967295
+nft 'add rule ip6 filter INPUT counter'
+
+ip6tables-translate -t filter -A INPUT -m frag ! --fragid 0:4294967295
+nft 'add rule ip6 filter INPUT counter'
diff --git a/extensions/libip6t_mh.t b/extensions/libip6t_mh.t
index 6b76d13d0a00f..151eabe631f58 100644
--- a/extensions/libip6t_mh.t
+++ b/extensions/libip6t_mh.t
@@ -4,3 +4,9 @@
 -p mobility-header -m mh --mh-type 1;=;OK
 -p mobility-header -m mh ! --mh-type 4;=;OK
 -p mobility-header -m mh --mh-type 4:123;=;OK
+-p mobility-header -m mh --mh-type :;-p mobility-header -m mh;OK
+-p mobility-header -m mh ! --mh-type :;-p mobility-header -m mh;OK
+-p mobility-header -m mh --mh-type :3;-p mobility-header -m mh --mh-type 0:3;OK
+-p mobility-header -m mh --mh-type 3:;-p mobility-header -m mh --mh-type 3:255;OK
+-p mobility-header -m mh --mh-type 3:3;-p mobility-header -m mh --mh-type 3;OK
+-p mobility-header -m mh --mh-type 4:3;;FAIL
diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
index 4dfaf46a2b8d7..825c956905c22 100644
--- a/extensions/libip6t_mh.txlate
+++ b/extensions/libip6t_mh.txlate
@@ -3,3 +3,12 @@ nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter ac
 
 ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
 nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept'
+
+ip6tables-translate -A INPUT -p mh --mh-type 0:255 -j ACCEPT
+nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
+
+ip6tables-translate -A INPUT -m mh --mh-type 0:255 -j ACCEPT
+nft 'add rule ip6 filter INPUT counter accept'
+
+ip6tables-translate -A INPUT -p mh ! --mh-type 0:255 -j ACCEPT
+nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
index 3c7b2d981324a..2699e800d528e 100644
--- a/extensions/libip6t_rt.t
+++ b/extensions/libip6t_rt.t
@@ -3,3 +3,9 @@
 -m rt --rt-type 0 ! --rt-segsleft 1:23 ! --rt-len 42 --rt-0-res;=;OK
 -m rt ! --rt-type 1 ! --rt-segsleft 12:23 ! --rt-len 42;=;OK
 -m rt;=;OK
+-m rt --rt-segsleft :;-m rt;OK
+-m rt ! --rt-segsleft :;-m rt;OK
+-m rt --rt-segsleft :3;-m rt --rt-segsleft 0:3;OK
+-m rt --rt-segsleft 3:;-m rt --rt-segsleft 3:4294967295;OK
+-m rt --rt-segsleft 3:3;-m rt --rt-segsleft 3;OK
+-m rt --rt-segsleft 4:3;=;OK
diff --git a/extensions/libip6t_rt.txlate b/extensions/libip6t_rt.txlate
index 3578bcba0157e..67d88d07732cc 100644
--- a/extensions/libip6t_rt.txlate
+++ b/extensions/libip6t_rt.txlate
@@ -12,3 +12,12 @@ nft 'add rule ip6 filter INPUT rt type 0 rt hdrlength 22 counter drop'
 
 ip6tables-translate -A INPUT -m rt --rt-type 0 --rt-len 22 ! --rt-segsleft 26 -j ACCEPT
 nft 'add rule ip6 filter INPUT rt type 0 rt seg-left != 26 rt hdrlength 22 counter accept'
+
+ip6tables-translate -A INPUT -m rt --rt-segsleft 13:42 -j ACCEPT
+nft 'add rule ip6 filter INPUT rt seg-left 13-42 counter accept'
+
+ip6tables-translate -A INPUT -m rt --rt-segsleft 0:4294967295 -j ACCEPT
+nft 'add rule ip6 filter INPUT counter accept'
+
+ip6tables-translate -A INPUT -m rt ! --rt-segsleft 0:4294967295 -j ACCEPT
+nft 'add rule ip6 filter INPUT counter accept'
diff --git a/extensions/libipt_ah.t b/extensions/libipt_ah.t
index cd853865638e8..a2aa338fef9c5 100644
--- a/extensions/libipt_ah.t
+++ b/extensions/libipt_ah.t
@@ -11,3 +11,9 @@
 -m ah --ahspi;;FAIL
 -m ah;;FAIL
 -p ah -m ah;=;OK
+-p ah -m ah --ahspi :;-p ah -m ah;OK
+-p ah -m ah ! --ahspi :;-p ah -m ah;OK
+-p ah -m ah --ahspi :3;-p ah -m ah --ahspi 0:3;OK
+-p ah -m ah --ahspi 3:;-p ah -m ah --ahspi 3:4294967295;OK
+-p ah -m ah --ahspi 3:3;-p ah -m ah --ahspi 3;OK
+-p ah -m ah --ahspi 4:3;=;OK
diff --git a/extensions/libipt_ah.txlate b/extensions/libipt_ah.txlate
index 897c82b5f95c6..e35ac17ab6c64 100644
--- a/extensions/libipt_ah.txlate
+++ b/extensions/libipt_ah.txlate
@@ -6,3 +6,9 @@ nft 'add rule ip filter INPUT ah spi 500-600 counter drop'
 
 iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
 nft 'add rule ip filter INPUT ah spi != 50 counter drop'
+
+iptables-translate -A INPUT -p 51 -m ah --ahspi 0:4294967295 -j DROP
+nft 'add rule ip filter INPUT counter drop'
+
+iptables-translate -A INPUT -p 51 -m ah ! --ahspi 0:4294967295 -j DROP
+nft 'add rule ip filter INPUT counter drop'
diff --git a/extensions/libxt_NFQUEUE.t b/extensions/libxt_NFQUEUE.t
index 8fb2b760a13bc..1adb8e4023099 100644
--- a/extensions/libxt_NFQUEUE.t
+++ b/extensions/libxt_NFQUEUE.t
@@ -8,6 +8,13 @@
 -j NFQUEUE --queue-balance 0:65535;;FAIL
 -j NFQUEUE --queue-balance 0:65536;;FAIL
 -j NFQUEUE --queue-balance -1:65535;;FAIL
+-j NFQUEUE --queue-balance 4;;FAIL
+-j NFQUEUE --queue-balance :;;FAIL
+-j NFQUEUE --queue-balance :4;-j NFQUEUE --queue-balance 0:4;OK
+-j NFQUEUE --queue-balance 4:;-j NFQUEUE --queue-balance 4:65535;OK
+-j NFQUEUE --queue-balance 3:4;=;OK
+-j NFQUEUE --queue-balance 4:4;;FAIL
+-j NFQUEUE --queue-balance 4:3;;FAIL
 -j NFQUEUE --queue-num 10 --queue-bypass;=;OK
 -j NFQUEUE --queue-balance 0:6 --queue-cpu-fanout --queue-bypass;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
 -j NFQUEUE --queue-bypass --queue-balance 0:6 --queue-cpu-fanout;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
diff --git a/extensions/libxt_connbytes.t b/extensions/libxt_connbytes.t
index 6b24e266c1a04..60209c697dc91 100644
--- a/extensions/libxt_connbytes.t
+++ b/extensions/libxt_connbytes.t
@@ -10,6 +10,12 @@
 -m connbytes --connbytes 0:1000 --connbytes-mode avgpkt --connbytes-dir both;=;OK
 -m connbytes --connbytes -1:0 --connbytes-mode packets --connbytes-dir original;;FAIL
 -m connbytes --connbytes 0:-1 --connbytes-mode packets --connbytes-dir original;;FAIL
+-m connbytes --connbytes : --connbytes-mode packets --connbytes-dir original;-m connbytes --connbytes 0 --connbytes-mode packets --connbytes-dir original;OK
+-m connbytes --connbytes :1000 --connbytes-mode packets --connbytes-dir original;-m connbytes --connbytes 0:1000 --connbytes-mode packets --connbytes-dir original;OK
+-m connbytes --connbytes 1000 --connbytes-mode packets --connbytes-dir original;=;OK
+-m connbytes --connbytes 1000: --connbytes-mode packets --connbytes-dir original;-m connbytes --connbytes 1000 --connbytes-mode packets --connbytes-dir original;OK
+-m connbytes --connbytes 1000:1000 --connbytes-mode packets --connbytes-dir original;=;OK
+-m connbytes --connbytes 1000:0 --connbytes-mode packets --connbytes-dir original;;FAIL
 # ERROR: cannot find: iptables -I INPUT -m connbytes --connbytes 0:18446744073709551615 --connbytes-mode avgpkt --connbytes-dir both
 # -m connbytes --connbytes 0:18446744073709551615 --connbytes-mode avgpkt --connbytes-dir both;=;OK
 -m connbytes --connbytes 0:18446744073709551616 --connbytes-mode avgpkt --connbytes-dir both;;FAIL
diff --git a/extensions/libxt_conntrack.t b/extensions/libxt_conntrack.t
index 2b3c5de9cd3ab..399d70abbe707 100644
--- a/extensions/libxt_conntrack.t
+++ b/extensions/libxt_conntrack.t
@@ -17,6 +17,8 @@
 -m conntrack --ctexpire 0:4294967295;=;OK
 -m conntrack --ctexpire 42949672956;;FAIL
 -m conntrack --ctexpire -1;;FAIL
+-m conntrack --ctexpire 3:3;-m conntrack --ctexpire 3;OK
+-m conntrack --ctexpire 4:3;=;OK
 -m conntrack --ctdir ORIGINAL;=;OK
 -m conntrack --ctdir REPLY;=;OK
 -m conntrack --ctstatus NONE;=;OK
@@ -27,3 +29,27 @@
 -m conntrack;;FAIL
 -m conntrack --ctproto 0;;FAIL
 -m conntrack ! --ctproto 0;;FAIL
+-m conntrack --ctorigsrcport :;-m conntrack --ctorigsrcport 0:65535;OK
+-m conntrack --ctorigsrcport :4;-m conntrack --ctorigsrcport 0:4;OK
+-m conntrack --ctorigsrcport 4:;-m conntrack --ctorigsrcport 4:65535;OK
+-m conntrack --ctorigsrcport 3:4;=;OK
+-m conntrack --ctorigsrcport 4:4;-m conntrack --ctorigsrcport 4;OK
+-m conntrack --ctorigsrcport 4:3;=;OK
+-m conntrack --ctreplsrcport :;-m conntrack --ctreplsrcport 0:65535;OK
+-m conntrack --ctreplsrcport :4;-m conntrack --ctreplsrcport 0:4;OK
+-m conntrack --ctreplsrcport 4:;-m conntrack --ctreplsrcport 4:65535;OK
+-m conntrack --ctreplsrcport 3:4;=;OK
+-m conntrack --ctreplsrcport 4:4;-m conntrack --ctreplsrcport 4;OK
+-m conntrack --ctreplsrcport 4:3;=;OK
+-m conntrack --ctorigdstport :;-m conntrack --ctorigdstport 0:65535;OK
+-m conntrack --ctorigdstport :4;-m conntrack --ctorigdstport 0:4;OK
+-m conntrack --ctorigdstport 4:;-m conntrack --ctorigdstport 4:65535;OK
+-m conntrack --ctorigdstport 3:4;=;OK
+-m conntrack --ctorigdstport 4:4;-m conntrack --ctorigdstport 4;OK
+-m conntrack --ctorigdstport 4:3;=;OK
+-m conntrack --ctrepldstport :;-m conntrack --ctrepldstport 0:65535;OK
+-m conntrack --ctrepldstport :4;-m conntrack --ctrepldstport 0:4;OK
+-m conntrack --ctrepldstport 4:;-m conntrack --ctrepldstport 4:65535;OK
+-m conntrack --ctrepldstport 3:4;=;OK
+-m conntrack --ctrepldstport 4:4;-m conntrack --ctrepldstport 4;OK
+-m conntrack --ctrepldstport 4:3;=;OK
diff --git a/extensions/libxt_dccp.t b/extensions/libxt_dccp.t
index f60b480fb6fc7..535891a556394 100644
--- a/extensions/libxt_dccp.t
+++ b/extensions/libxt_dccp.t
@@ -6,6 +6,16 @@
 -p dccp -m dccp --sport 1:1023;=;OK
 -p dccp -m dccp --sport 1024:65535;=;OK
 -p dccp -m dccp --sport 1024:;-p dccp -m dccp --sport 1024:65535;OK
+-p dccp -m dccp --sport :;-p dccp -m dccp --sport 0:65535;OK
+-p dccp -m dccp --sport :4;-p dccp -m dccp --sport 0:4;OK
+-p dccp -m dccp --sport 4:;-p dccp -m dccp --sport 4:65535;OK
+-p dccp -m dccp --sport 4:4;-p dccp -m dccp --sport 4;OK
+-p dccp -m dccp --sport 4:3;=;OK
+-p dccp -m dccp --dport :;-p dccp -m dccp --dport 0:65535;OK
+-p dccp -m dccp --dport :4;-p dccp -m dccp --dport 0:4;OK
+-p dccp -m dccp --dport 4:;-p dccp -m dccp --dport 4:65535;OK
+-p dccp -m dccp --dport 4:4;-p dccp -m dccp --dport 4;OK
+-p dccp -m dccp --dport 4:3;=;OK
 -p dccp -m dccp ! --sport 1;=;OK
 -p dccp -m dccp ! --sport 65535;=;OK
 -p dccp -m dccp ! --dport 1;=;OK
diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
index 92c5779f860f1..a8bc5287dd089 100644
--- a/extensions/libxt_esp.t
+++ b/extensions/libxt_esp.t
@@ -4,5 +4,12 @@
 -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
 -p esp -m esp ! --espspi 0:4294967294;=;OK
 -p esp -m esp --espspi -1;;FAIL
+-p esp -m esp --espspi :;-p esp -m esp;OK
+-p esp -m esp ! --espspi :;-p esp -m esp;OK
+-p esp -m esp --espspi :4;-p esp -m esp --espspi 0:4;OK
+-p esp -m esp --espspi 4:;-p esp -m esp --espspi 4:4294967295;OK
+-p esp -m esp --espspi 3:4;=;OK
+-p esp -m esp --espspi 4:4;-p esp -m esp --espspi 4;OK
+-p esp -m esp --espspi 4:3;=;OK
 -p esp -m esp;=;OK
 -m esp;;FAIL
diff --git a/extensions/libxt_esp.txlate b/extensions/libxt_esp.txlate
index f6aba52f52235..3b1d5718057b1 100644
--- a/extensions/libxt_esp.txlate
+++ b/extensions/libxt_esp.txlate
@@ -9,3 +9,15 @@ nft 'add rule ip filter INPUT esp spi 500 counter drop'
 
 iptables-translate -A INPUT -p 50 -m esp --espspi 500:600 -j DROP
 nft 'add rule ip filter INPUT esp spi 500-600 counter drop'
+
+iptables-translate -A INPUT -p 50 -m esp --espspi 0:4294967295 -j DROP
+nft 'add rule ip filter INPUT counter drop'
+
+iptables-translate -A INPUT -p 50 -m esp ! --espspi 0:4294967295 -j DROP
+nft 'add rule ip filter INPUT counter drop'
+
+ip6tables-translate -A INPUT -p 50 -m esp --espspi 0:4294967295 -j DROP
+nft 'add rule ip6 filter INPUT counter drop'
+
+ip6tables-translate -A INPUT -p 50 -m esp ! --espspi 0:4294967295 -j DROP
+nft 'add rule ip6 filter INPUT counter drop'
diff --git a/extensions/libxt_ipcomp.t b/extensions/libxt_ipcomp.t
index 8546ba9ce416f..f62144ae8fec8 100644
--- a/extensions/libxt_ipcomp.t
+++ b/extensions/libxt_ipcomp.t
@@ -1,3 +1,10 @@
 :INPUT,OUTPUT
 -p ipcomp -m ipcomp --ipcompspi 18 -j DROP;=;OK
 -p ipcomp -m ipcomp ! --ipcompspi 18 -j ACCEPT;=;OK
+-p ipcomp -m ipcomp --ipcompspi :;-p ipcomp -m ipcomp;OK
+-p ipcomp -m ipcomp ! --ipcompspi :;-p ipcomp -m ipcomp;OK
+-p ipcomp -m ipcomp --ipcompspi :4;-p ipcomp -m ipcomp --ipcompspi 0:4;OK
+-p ipcomp -m ipcomp --ipcompspi 4:;-p ipcomp -m ipcomp --ipcompspi 4:4294967295;OK
+-p ipcomp -m ipcomp --ipcompspi 3:4;=;OK
+-p ipcomp -m ipcomp --ipcompspi 4:4;-p ipcomp -m ipcomp --ipcompspi 4;OK
+-p ipcomp -m ipcomp --ipcompspi 4:3;=;OK
diff --git a/extensions/libxt_length.t b/extensions/libxt_length.t
index 8b70fc317485c..3905d2d05feec 100644
--- a/extensions/libxt_length.t
+++ b/extensions/libxt_length.t
@@ -3,8 +3,11 @@
 -m length --length :2;-m length --length 0:2;OK
 -m length --length 0:3;=;OK
 -m length --length 4:;-m length --length 4:65535;OK
+-m length --length :;-m length --length 0:65535;OK
 -m length --length 0:65535;=;OK
 -m length ! --length 0:65535;=;OK
 -m length --length 0:65536;;FAIL
 -m length --length -1:65535;;FAIL
+-m length --length 4:4;-m length --length 4;OK
+-m length --length 4:3;=;OK
 -m length;;FAIL
diff --git a/extensions/libxt_tcp.t b/extensions/libxt_tcp.t
index 7a3bbd08952f0..baa41615b11a6 100644
--- a/extensions/libxt_tcp.t
+++ b/extensions/libxt_tcp.t
@@ -6,6 +6,18 @@
 -p tcp -m tcp --sport 1:1023;=;OK
 -p tcp -m tcp --sport 1024:65535;=;OK
 -p tcp -m tcp --sport 1024:;-p tcp -m tcp --sport 1024:65535;OK
+-p tcp -m tcp --sport :;-p tcp -m tcp;OK
+-p tcp -m tcp ! --sport :;-p tcp -m tcp;OK;LEGACY;-p tcp
+-p tcp -m tcp --sport :4;-p tcp -m tcp --sport 0:4;OK
+-p tcp -m tcp --sport 4:;-p tcp -m tcp --sport 4:65535;OK
+-p tcp -m tcp --sport 4:4;-p tcp -m tcp --sport 4;OK
+-p tcp -m tcp --sport 4:3;;FAIL
+-p tcp -m tcp --dport :;-p tcp -m tcp;OK
+-p tcp -m tcp ! --dport :;-p tcp -m tcp;OK;LEGACY;-p tcp
+-p tcp -m tcp --dport :4;-p tcp -m tcp --dport 0:4;OK
+-p tcp -m tcp --dport 4:;-p tcp -m tcp --dport 4:65535;OK
+-p tcp -m tcp --dport 4:4;-p tcp -m tcp --dport 4;OK
+-p tcp -m tcp --dport 4:3;;FAIL
 -p tcp -m tcp ! --sport 1;=;OK
 -p tcp -m tcp ! --sport 65535;=;OK
 -p tcp -m tcp ! --dport 1;=;OK
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
index 9802ddfe0039e..a7e921bff2ca0 100644
--- a/extensions/libxt_tcp.txlate
+++ b/extensions/libxt_tcp.txlate
@@ -30,3 +30,9 @@ nft 'add rule ip filter INPUT tcp option 23 exists counter'
 
 iptables-translate -A INPUT -p tcp ! --tcp-option 23
 nft 'add rule ip filter INPUT tcp option 23 missing counter'
+
+iptables-translate -I OUTPUT -p tcp --sport 0:65535 -j ACCEPT
+nft 'insert rule ip filter OUTPUT counter accept'
+
+iptables-translate -I OUTPUT -p tcp ! --sport 0:65535 -j ACCEPT
+nft 'insert rule ip filter OUTPUT counter accept'
diff --git a/extensions/libxt_tcpmss.t b/extensions/libxt_tcpmss.t
index 2b415957ffd00..d0fb52fab33b7 100644
--- a/extensions/libxt_tcpmss.t
+++ b/extensions/libxt_tcpmss.t
@@ -1,6 +1,10 @@
 :INPUT,FORWARD,OUTPUT
 -m tcpmss --mss 42;;FAIL
 -p tcp -m tcpmss --mss 42;=;OK
+-p tcp -m tcpmss --mss :;-p tcp -m tcpmss --mss 0:65535;OK
+-p tcp -m tcpmss --mss :42;-p tcp -m tcpmss --mss 0:42;OK
+-p tcp -m tcpmss --mss 42:;-p tcp -m tcpmss --mss 42:65535;OK
+-p tcp -m tcpmss --mss 42:42;-p tcp -m tcpmss --mss 42;OK
 -p tcp -m tcpmss --mss 42:12345;=;OK
 -p tcp -m tcpmss --mss 42:65536;;FAIL
 -p tcp -m tcpmss --mss 65535:1000;;FAIL
diff --git a/extensions/libxt_udp.t b/extensions/libxt_udp.t
index f534770191a6e..d62dd5e3f830e 100644
--- a/extensions/libxt_udp.t
+++ b/extensions/libxt_udp.t
@@ -6,6 +6,18 @@
 -p udp -m udp --sport 1:1023;=;OK
 -p udp -m udp --sport 1024:65535;=;OK
 -p udp -m udp --sport 1024:;-p udp -m udp --sport 1024:65535;OK
+-p udp -m udp --sport :;-p udp -m udp;OK
+-p udp -m udp ! --sport :;-p udp -m udp;OK;LEGACY;-p udp
+-p udp -m udp --sport :4;-p udp -m udp --sport 0:4;OK
+-p udp -m udp --sport 4:;-p udp -m udp --sport 4:65535;OK
+-p udp -m udp --sport 4:4;-p udp -m udp --sport 4;OK
+-p udp -m udp --sport 4:3;=;OK
+-p udp -m udp --dport :;-p udp -m udp;OK
+-p udp -m udp ! --dport :;-p udp -m udp;OK;LEGACY;-p udp
+-p udp -m udp --dport :4;-p udp -m udp --dport 0:4;OK
+-p udp -m udp --dport 4:;-p udp -m udp --dport 4:65535;OK
+-p udp -m udp --dport 4:4;-p udp -m udp --dport 4;OK
+-p udp -m udp --dport 4:3;=;OK
 -p udp -m udp ! --sport 1;=;OK
 -p udp -m udp ! --sport 65535;=;OK
 -p udp -m udp ! --dport 1;=;OK
diff --git a/extensions/libxt_udp.txlate b/extensions/libxt_udp.txlate
index 28e7ca206b26b..3aed7cd15dbd7 100644
--- a/extensions/libxt_udp.txlate
+++ b/extensions/libxt_udp.txlate
@@ -9,3 +9,9 @@ nft 'insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accep
 
 iptables-translate -I OUTPUT -p udp --dport 1020:1023 --sport 53 -j ACCEPT
 nft 'insert rule ip filter OUTPUT udp sport 53 udp dport 1020-1023 counter accept'
+
+iptables-translate -I OUTPUT -p udp --sport 0:65535 -j ACCEPT
+nft 'insert rule ip filter OUTPUT counter accept'
+
+iptables-translate -I OUTPUT -p udp ! --sport 0:65535 -j ACCEPT
+nft 'insert rule ip filter OUTPUT counter accept'
-- 
2.43.0

