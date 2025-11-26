Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9767346A18;
	Wed, 26 Nov 2025 20:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190602; cv=none; b=f1hWqYT6j3Dgw34hBrrF2TuCjpBDQi7wfEfdENrHgWoXzE1LdATQldFQcv+BbgetmYxHGffN2lnUMp47qUaAjqxC+vBn92q8E+8abEOJZrPSTx1JvDwDOTlZy6KCX/KDp6cXeLoMT8pu3roS6Kji3bg5yYX7/CSsau4OXXeClBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190602; c=relaxed/simple;
	bh=94RYMQfe22woxwUFAcBhnWu3PfAgirtf6jv8lH1RaIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ7AexotswMmF4k11wGU12FMi1YoFD695H32Ci90q2whGxT163xL5tElpuJ7P6lOWCbi7gBE2vizMiQtVvt1/WAGGIoxaekxzQ6er/vFfsHeK79jnKix3eHcQSHrWOxNjbQyOSGc98YrqWjAf5JfOp9WZLRyjVWJ41jMPuNxlFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=siZ5DhhX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="siZ5DhhX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A45486026F;
	Wed, 26 Nov 2025 21:56:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190599;
	bh=nrb0JN8x9pDF+NZ6bI4PKtfcMNpKT2s+QNXLek3xg3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siZ5DhhXQ53TNNcgp8O0tbzw9XYvcoBG5Fk7hFUSdlCCqoXLV4kMgfO2aFHl0hS07
	 7TY1cpGdBeSN0UZezYC+QvneGsEE2dMCz7nF0mmQ9+0ES9qIHhkqLZGhmwF/mLoW0S
	 ifd3S7t56klyuahLd4oHikcMJWyxjuOjAge4OM1AmLXeSV5Gu0gSkmWGf8Hoj/JAln
	 Olw9UDEx726KOqixqrCPQSiixT9QdFKek3wpS5GzgzpaU7X/CWBUW0A0F/WiOgkVcN
	 5yDS101LQqUyF53xsqiY5Uhy4V73Q1Rp8zDdr4z9uuxDB2/KELtranDvoyUDh/J1O8
	 QegeCJoOaBGSw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 15/16] netfilter: ip6t_srh: fix UAPI kernel-doc comments format
Date: Wed, 26 Nov 2025 20:56:10 +0000
Message-ID: <20251126205611.1284486-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

Fix the kernel-doc format for struct members to be "@member" instead of
"@ member" to avoid kernel-doc warnings.

Warning: ip6t_srh.h:60 struct member 'next_hdr' not described in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'hdr_len' not described in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'segs_left' not described
 in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'last_entry' not described
 in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'tag' not described in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'mt_flags' not described in 'ip6t_srh'
Warning: ip6t_srh.h:60 struct member 'mt_invflags' not described
 in 'ip6t_srh'
Warning: ip6t_srh.h:93 struct member 'next_hdr' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'hdr_len' not described in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'segs_left' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'last_entry' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'tag' not described in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'psid_addr' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'nsid_addr' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'lsid_addr' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'psid_msk' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'nsid_msk' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'lsid_msk' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'mt_flags' not described
 in 'ip6t_srh1'
Warning: ip6t_srh.h:93 struct member 'mt_invflags' not described
 in 'ip6t_srh1'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h | 40 ++++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
index 54ed83360dac..80c66c8ece82 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
@@ -41,13 +41,13 @@
 
 /**
  *      struct ip6t_srh - SRH match options
- *      @ next_hdr: Next header field of SRH
- *      @ hdr_len: Extension header length field of SRH
- *      @ segs_left: Segments left field of SRH
- *      @ last_entry: Last entry field of SRH
- *      @ tag: Tag field of SRH
- *      @ mt_flags: match options
- *      @ mt_invflags: Invert the sense of match options
+ *      @next_hdr: Next header field of SRH
+ *      @hdr_len: Extension header length field of SRH
+ *      @segs_left: Segments left field of SRH
+ *      @last_entry: Last entry field of SRH
+ *      @tag: Tag field of SRH
+ *      @mt_flags: match options
+ *      @mt_invflags: Invert the sense of match options
  */
 
 struct ip6t_srh {
@@ -62,19 +62,19 @@ struct ip6t_srh {
 
 /**
  *      struct ip6t_srh1 - SRH match options (revision 1)
- *      @ next_hdr: Next header field of SRH
- *      @ hdr_len: Extension header length field of SRH
- *      @ segs_left: Segments left field of SRH
- *      @ last_entry: Last entry field of SRH
- *      @ tag: Tag field of SRH
- *      @ psid_addr: Address of previous SID in SRH SID list
- *      @ nsid_addr: Address of NEXT SID in SRH SID list
- *      @ lsid_addr: Address of LAST SID in SRH SID list
- *      @ psid_msk: Mask of previous SID in SRH SID list
- *      @ nsid_msk: Mask of next SID in SRH SID list
- *      @ lsid_msk: MAsk of last SID in SRH SID list
- *      @ mt_flags: match options
- *      @ mt_invflags: Invert the sense of match options
+ *      @next_hdr: Next header field of SRH
+ *      @hdr_len: Extension header length field of SRH
+ *      @segs_left: Segments left field of SRH
+ *      @last_entry: Last entry field of SRH
+ *      @tag: Tag field of SRH
+ *      @psid_addr: Address of previous SID in SRH SID list
+ *      @nsid_addr: Address of NEXT SID in SRH SID list
+ *      @lsid_addr: Address of LAST SID in SRH SID list
+ *      @psid_msk: Mask of previous SID in SRH SID list
+ *      @nsid_msk: Mask of next SID in SRH SID list
+ *      @lsid_msk: MAsk of last SID in SRH SID list
+ *      @mt_flags: match options
+ *      @mt_invflags: Invert the sense of match options
  */
 
 struct ip6t_srh1 {
-- 
2.47.3

