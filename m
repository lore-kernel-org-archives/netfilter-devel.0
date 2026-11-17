Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.186
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916436;
	b=omMrEWUYR2Y5gUrinFh+L5foCV9TTsT/Dm43aeuCeu9oprBEJoOklC6yZhJCYy47NxiQ
	 uWYxvy3nIHNEzNzP5m+nIdBZ+Cu+DRqK7KXoNZcEO92TEmGFeGKuRp6/idU9gqxfE4jGs
	 58Wa+S79y63U0mUCB6gWmOKfc7vNMnoWQBwD+PuMcCDBMkHggbSfPb5FcU1XF85Fb6wEM
	 5Pl08qY3DjysId2cFHfofnE9fmiAtR3wZUqz8k1ysSfvkptqj7c57dQgheWYTIeSOOHhA
	 pzVC13ZmLkTJzlA3f6ZVXeN/KXCxcDIJOYAsmYTRz39ku7ebgx7GwdG88qS2a+2yXDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916436;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Info-Out:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-JNJ;
	bh=1mziqc7iCo3GycX+OIidCj8rWEHHQUb8Q9gKlOt9Y7A=;
	b=mXaae8HIj0EPojR0TbY9WV5c/I/She139P6muUlUrf+vrh1kDtzPQO0LgEGRxkkVTMCS
	 grNibMzfXse7aff1mCtqzSk4vVyBzu5PhMwkYBG/OaraA2NHz7lJBUT8y/djFG8GWtv+R
	 SJdrLPSdrKTMOyOR/FCVFwnPtA0fN3hK6HmyUSC/FJbO6jbKbHrWQDppvQQ9QZaOIPqIe
	 eR8IPLvXzrD3VyDSoTflH3uqBk/F6ujZs7g0z/KHrpcSlKa267WlUhtEPt1RHx3Apdar+
	 AkJQ+7/nUuvCMHVf81eSkaZBcxTJZRTFKpGkc3F14uBy8F9RTfg3yHiDw+SNyuIyzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=iIZ5uQDk;
	arc=none smtp.remote-ip=57.103.64.186
Received: from outbound.pv.icloud.com (pv-2002b-snip4-5.eps.apple.com [57.103.64.186])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E4606A33E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B14E4606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=iIZ5uQDk
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id 716CC1800154;
	Tue, 17 Nov 2026 11:53:51 +0000 (UTC)
X-ICL-RepId: 01a1e95b-3618-7ef0-9fd5-8f088efaaaa9
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916435; x=1826452435; bh=1mziqc7iCo3GycX+OIidCj8rWEHHQUb8Q9gKlOt9Y7A=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=iIZ5uQDkJt2upTptYptd1IRWEsFO0JCXSheQrzhXCVrvpBThideX3ch2bACvdIHhvLVB/YKOV5SzgqLrb+pLHNpALopZqMNo35tLCDrn71xdzGrtphxCsoETZJuBYio4DyMw0BkmC8dptazKHt9eK7hQQt8YWqhMFK1Gjnq6nnigTSgLgu51oFmllvCo/OyUuZl5dRbJph9woKpKw5ZoimsckdzwI04NAPcJVBuNcG/KYoJNbeh1WAq7InWiSPHiL3i5LMs00ZbOPYuzGntBFrFQVXVVJRV7t1dWV09u/boQbXflmcgrR/wW4Fb+a/hW2I8LsAiAnckvlSAU4M0NXg==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id C3A0C180020F;
	Tue, 17 Nov 2026 11:53:46 +0000 (UTC)
From: Vladimir Vdovin <deliran@verdict.gg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	linux-hardening@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Vladimir Vdovin <deliran@verdict.gg>
Subject: [PATCH nf-next v1 2/5] netfilter: nf_conncount: check last_gc before taking list_lock in gc_list
Date: Tue, 17 Nov 2026 14:53:05 +0300
Message-ID: <20261117115308.95134-3-deliran@verdict.gg>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261117115308.95134-1-deliran@verdict.gg>
References: <20261117115308.95134-1-deliran@verdict.gg>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfXytRjcHo7NObN
 tIX/HnUIUu4bNf9CbqNjLbaNwZamVCmpyV2d2Dica/V1niSBk+Ey4u0yrJQKp+y2t7XLBDYmUWJ
 yL5Cu45iORtBBWGVz2zCWxJIatUJG7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfXyKylkw1SG2qi
 1jWJxbuWzUJOjvBv0MYpk/gtdFADoftxSXepvyfsiQztz2gcdABWINCgVnwqzupeY/RUUUGLmoy
 rvbJutmnk93yaE8t7/8uWda0yyfeWX8Excs+5eNeuvr1f07LJ8Rgy/wdJuZZYmymrXg5lOktD27
 +u/w9WxREIO0ic0EXym3O8hQ8NAhiucu57ZQBNq31TNOnNMaPG0nd52tKPm5EtzanhAQj7lQVey
 YqJ0AOrjV+6sYS00ITXl/uOyDsq0DIpqpK3E/ypJosTqoIbYmEKzBVL2c6qJ31q9k2rNPDtgfVs
 faonCpBfpd2tVd04IB0K6DHFe7WzlyE4NcuVjL020uG/YUskL0FO5HiquZRD2M=
X-Authority-Info-Out: v=2.4 cv=CtMq4X4D c=1 sm=1 tr=0 ts=6afc4051
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Lz8lNifEoAKVmCoaIBl5:22 a=zaE7u2tvhngv6054aE9a:22 a=fToKmBgkPectip-2dAkA:9
X-Proofpoint-ORIG-GUID: uhL8h6THw53LEpvX-W2BxRDsTORi6KqC
X-Proofpoint-GUID: uhL8h6THw53LEpvX-W2BxRDsTORi6KqC
X-JNJ: AAAAAAABcM0dWPpN9O6S6SJnrOu62RmtpkBYygQC8UKav6WZDbCEid1GDx9kXKHM9M5vVK
 GEP0fWwuV8rCjDFahqalPj1NOssu1h5jTbqZ8DxNVwyhhk6mvP5Lrl8dygyfcloAZC4lus
 qDP/tsobOxG8m4KlqCePJNVEwPTnNGs5y10bDGJjDyj+44xb1Fyuqyq3t9qMOsIZjUkeLq
 A2y12wgZ9LN9Ts6RGGNVC+JOl694JmLaz8xPobul5U5HMlVSZryY1J7njxuExULj9Vhp1w
 B2u6AxWtyLxEq0+MzjmN6CjeOsgn9047sxQnnp6k1pAiDf2Wl89hcn5/PCE74sqlMLzkO9
 juC2BnSqWtrl6Pqb0d37JSCY8+AX3AhUl5NfXizWVdG749BZ1d/T2CU6t5JMc8l79+zJEV
 vX5fQaLMfnP07fmahmqVNNHY7iMURMVXSnpNZGeYjFYWLo7OmuVZ1Wjm2OQDeVjW1cdf/O
 2SJHCU7qNj7x9wUj5ia+UqRDcWqKuIUFZ3KXwDQtQAJD3oNDisCTHpg2FsBAYaXbz+YE+r
 9K7Pe2FWy+LoZJtbpZLl2r+Jy8WkCL8gUtQ3o9Ci3io3u/+JUy84opRcJ0CG90JMUbUoNk
 VgUtqFWQa/+GOd7uTcikEDmaMOeQh18JxY6jwPugX1cXMaAeurI6gHHwXWYtuFbHwMX8wP
 iXX2uw5pW1vV/YOPlRr4Xaq+D1gDkbvEsXwEXt7Y2XOCIYFon7WA3zatID3zQN/g7o57HO
 MyGUGaYPD1UdAMAEetLgf9kDhOHtUEtIfgeHPxLUw/YcVSj+XetF3ULUzywLAfDsrelBnj
 GV6bTqXbUo7KWcmtKSbTcMrboDKFcJDlLp/ktVedTisqkdONELNBGXvBytxNY3qJCbRSKg
 V2mIZmpTRVfOPyTnOkRE9caIx8eJsgWeZSvm5EqgmRUW/xjdRPWxnA/IHA5CgNzlQFf+59
 gMpn5bU6PWQLEK4V

nf_conncount_gc_list() takes list_lock first and only then finds out,
in __nf_conncount_gc_list(), that gc already ran during this jiffy and
there is nothing to do. The trylock still writes to the lock, so every
caller contends on it even though at most one of them per jiffy does
any work.

This matters on the count-only path of nf_conncount_count_skb(), where
the lookup itself is lockless: when many cpus query the same list at
once, the gc attempt is the only thing they serialize on.

Read last_gc before the trylock and leave early. The check under the
lock stays, as it is the one that decides when two cpus race for the
same jiffy.

Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
---
 net/netfilter/nf_conncount.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 84290e363245..be9e395e25b6 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -382,6 +382,10 @@ bool nf_conncount_gc_list(struct net *net,
 {
 	bool ret;
 
+	/* don't bother if we just did GC */
+	if ((u32)jiffies == READ_ONCE(list->last_gc))
+		return false;
+
 	/* don't bother if other cpu is already doing GC */
 	if (!spin_trylock_bh(&list->list_lock))
 		return false;
-- 
2.56.0

