Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4910C224B0E;
	Sat,  1 Nov 2025 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762024853; cv=none; b=hIJguFe3RFA7afggKQrF2x1N7rX2QK9z2Szt5B81mEbnQHK2q2g1rgN7xykkZkFsp2CNpn/tbv98nUqxi97DG1b2x/Gi/F/MM+CqgPe1rELyjsyYdPSGTh8oRHobJ7IOHMDOYN90YnktpdBM3JOM47OfF8ynZpi/ol/jJYq7/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762024853; c=relaxed/simple;
	bh=h/7ztJhsHHwM7UUklubihOZTlg4nSub+i35nPpb7WHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLn4mYzyHEt04mtBDmB3FKhcpJ7Ku8NGr6h5lG8K1ytDm1WGBxSzy8hmqs5wfUJCIm9FmsP45lJjejz/SBfje49CMTCNvAMcjlw8eGQXmP6ZGNb8JfZ4CB2UG/mWhDEe/Vqn/xBDpfu5qiwm2viZh1uk6jHmZ5VAlxMwYT17vfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3blte1rY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3blte1rY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=cGBa5E1G4e07EFAi0qmqvH28awe0hfD/7FyaOtTujCk=; b=3blte1rYKWzPVofy4Dxpix+A5I
	vLHjviNY1IP7t5L+74CrwCX6610bDBKEBOQYdKG65dqeDbae/D2q93hi3AtHz1796jhNanvze5nmy
	mEdfk9PH0Y3OMIcv+NW3Xjd7/Ra3JPhsNaa0vC7t+8cHifPbV0trUNLI2N8A7OIO66UB1GkIKr2Eb
	QZDUUKkdPDwGM0fvbAowzah38zM1WPr3BK4nl+e9t6nQfK/tmdA9WOmzwUDu+0n19D2jpOLapr9Rf
	O0p1QPasbXUZPm9SIwbPACb8qm3EM6TCcGUDltYmE0F3y2LZxRhj8difeSMTR02kNh+2mRmoKgBHC
	qRRiWIyg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFH9f-000000082dD-1hMe;
	Sat, 01 Nov 2025 19:20:51 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH net-next] netfilter: ip6t_srh: fix UAPI kernel-doc comments format
Date: Sat,  1 Nov 2025 12:20:50 -0700
Message-ID: <20251101192050.2007178-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
---
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h |   40 ++++++++---------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- linux-next-20251031.orig/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
+++ linux-next-20251031/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
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
