Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422191;
	b=yxhNFIJ1kBJ0FwiyFzExuaosTofD9KhhZmxNv8OdV+2oF387TH0URaCsljWr1uzcBVvC
	 E2/2g0gWAYketQ5qDirZDA4P1s2LBT8MJHbW9cJH+gX0hq9nInJzKBTHH+hjhdV07SBzo
	 tKqTlOsUbZ6ne79E3zlU5cG86IRWgjfTHhQ15XtuN20FpLYd9p/m9lawUcllUId7qPx/o
	 CXVLNWu12SnF15DBh0pBeR3tm7LRae495nPDgKo+B/rW6+1rRSJo4MPOG7lJdMgA3NW8P
	 8SmqbqkvZVsm4s21DZWHVuHdDqCsr4Dh2sdUFdCetJjOBZeAJ3w2uphogp4Jvvq5dzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422191;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=lV8QWm9Z+HIg2Nt43ShwKmzN3Kg/Clf/xBBfQiQHPFE=;
	b=hsPDeJXvh7TStFFg53TJ7pwOoNibbSNFR/5/XvzhOjEgUie2pouac7WAM/aUl/N15HP3
	 AyZ0aMet++Kk3zpTKDmbhOy4UMoA70/HfiWlsKyJtCXJrLUEsswBZxrDkdMB98USRnTI3
	 r9JsZ9kaFU+vdkw3eMKWRMRRqRvK5ksEnaNigzeP/lzfy8ut/FdG6pUfdEXDLIds5NuwP
	 cl1s14XyggdoE9wV1oeW0J5Iei3CK77vXF2idjGo7IVn8McqmE1S7UdKrh5910TCYI+nH
	 7Qh0Y1P/y5ADhmqV662hDKcOkjkfCx42KCTa/AbE51XhYyZFPWfg5mgC/HZ2uCa58Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kTac9Tr+;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED2607D36A;
	Mon, 19 Oct 2026 15:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BED2607D36A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kTac9Tr+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422189;
	bh=lV8QWm9Z+HIg2Nt43ShwKmzN3Kg/Clf/xBBfQiQHPFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTac9Tr+ZKpzFp2Ydj2EmcVUU/+DixAqxXGrKHiXZgsmMROBz6sdDyQnpyYRNIugy
	 LwG33zWe6UpfeuD973xRmeJSlcdKKbKeoU4yUefFg/v02bgh33bOE5SbSalTj1b0sR
	 R0ROZJ23GPMvF9XJaGOn1R9yZ1hY3iWEUeTR2rIRRA3sMWIS9gsetoTPUYEdgi0CIM
	 h3q7BK1y87ijxM34hAcsikNk60YpNxhMwTs8x8Y2kSoowugsI62DiGL6YbBAnjX/57
	 R31oXdTOFJG5a001IFUcigzXA2VICjdk+m7D146U3T25ER9SwW0S3i3xyI31F6gVXo
	 l9c6zkpy9GYRg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBE2E6005D;
	Mon, 19 Oct 2026 17:03:08 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/10] netfilter: xt_dccp: handle reserved options as single-byte
Date: Mon, 19 Oct 2026 17:02:47 +0200
Message-ID: <20261019150249.1879516-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
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

From: Sung Byeongchan <tjdqudcks0424@naver.com>

The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
Padding and Mandatory, these options occupy one byte.  dccp_find_option()
only treats values below 2 as single-byte and interprets the byte after a
reserved option as a TLV length.

This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
local production-hook fixture installed the same DROP rule for IPv4 and
IPv6.  In three fresh boots per kernel, a target-only packet was dropped
20/20 times, while adding reserved option 3 before the same target let
20/20 packets reach the protected receiver.  The fixed kernel dropped all
trigger packets in three fresh boots and preserved the normal controls.

Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
protocol definition.  Triggering requires
CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
option-based rule, and remote protocol-33 reachability.  The touched source
is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
applies and builds cleanly.

Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_dccp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 3db81e041af9..23a4e3e8df7d 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,7 +62,7 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2 || i == optlen - 1)
+		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
 			i++;
 		else
 			i += op[i + 1] ? : 1;
-- 
2.47.3

