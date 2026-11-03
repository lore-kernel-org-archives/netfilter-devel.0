Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724868;
	b=XqUCrxHWsVf+kFs7KnElXpNsPbrAI308rnpFt7Vg+8i67wkG//BMnvw8wmZyRqRzbi3Z
	 4o25NdzCV0T50bJJt0qAC+K4GpQokIg6strsTH63K1ytv0UViNZoZtMkH0ahIue1rCEN5
	 elFPsQCAxeirvjXi2uHFGAlDDWEruwKYaSdON7nEljyQ8yQi8JNMav4K5GaGoET7HFUVp
	 2QQO/+qJxmot84Izg17Xxl4273lPRlnsCE7NMSU18gdDN2lBm9fvlvaDFo+MR7qm0l9r2
	 foirj0aG2ozy8vf9B/2sZDSdD+bAzKciUmLX8g4OKAOWjOqi08zy3XP4f9CCbVoVOUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mca1WBmTRuBVPkCPXuqqTeUuiPIqAE1gGlgH4qiGb6o=;
	b=hzEBqZ/yYyT31eL5K0OoL7Y34ccVta2bTmmtvyCossDWpyzA5EJcvFktOtLgb3NEBjba
	 N3O7VoESU3LvMfl6Yb7dyOjoGxU9yIXnD76hfwN4XA73NhKpPvi00UPevLnFx1uQSIFSl
	 qsfQkvDpYxHJWC7SHfV26s0d0XpAhVsrVvP9mqcNlNlgr6Itsp1Bag8eDGwzUvKNou8h8
	 lEtoqil9LfXZrSvTvHql/q1WkR9ZX1pg0QlCRJD2AF+lnkXwq5S8/WhDBkd+LUmh6/8cB
	 Bww3fWelYmF5XYtvvfGFPt4TXaCLySErF9vgQKTB0pJbmUn2GGZGaM1zsH4EQhMRz8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQk70WNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58BE606D830;
	Tue,  3 Nov 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQk70WNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B041C1F00A17;
	Tue,  3 Nov 2026 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724867;
	bh=mca1WBmTRuBVPkCPXuqqTeUuiPIqAE1gGlgH4qiGb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQk70WNd9+IhuavwuTuN0IzfVvgkKjVnGGwps0px+xa2uNgdvzTTjnlDwsVXkaERu
	 EfeW5ZLFgjnJH+nLtVoYiep2aw87QMHow0+QbOWvsWDye3i+znvLbxgM1ZcR3sMi5L
	 QSFj4SyfdxRinwJh7ns7UAe7g2hr5Gc2J8r+MLBEGfLwk3mWBQtAqqpbWzD+MpkXHZ
	 ERgLVt6lFrpp1REgtIYt/PLgUpjenhESstnouC/NLCZ9Y1aAEVnEwg1KcB9ujzyU1l
	 4G601oZmZqeGoT13BrvpsCxNm7T3d8v6mEy9F6TcuD/GGjbGydYQgBJsmVgF00N9KO
	 33unVj5OwzlYA==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Sasha Levin <sashal@kernel.org>,
	Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next] selftests: netfilter: nf_queue: drop the no-op loop initializer
Date: Tue,  3 Nov 2026 11:54:18 -0500
Message-ID: <20261103165419.687806-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103165419.687806-1-sashal@kernel.org>
References: <20261103165419.687806-1-sashal@kernel.org>
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

The out-of-order verdict loop starts with "for (ooo_count; ...", and
clang warns about the unused expression:

  nf_queue.c:354:10: warning: expression result unused [-Wunused-value]

Leave the initializer empty.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
KernelCI's clang builds show this warning.

 tools/testing/selftests/net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index cca6c3cfa9e46..bc0b2f601a0a4 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -351,7 +351,7 @@ static int mainloop(void)
 		if (opts.out_of_order) {
 			ooo_ids[ooo_count] = id;
 			if (ooo_count >= 15) {
-				for (ooo_count; ooo_count >= 0; ooo_count--) {
+				for (; ooo_count >= 0; ooo_count--) {
 					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
 								opts.queue_num, opts.verdict);
 					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-- 
2.53.0

