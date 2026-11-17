Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916445;
	b=5Y6+BBfn5WRaKUhl1t+R6rM5untbhyo37o42ksc2LaRTG17Do+redphJF1vyE5lQGrX/
	 pesmSbAPUyL7VI1q77xilIFj7HNmrAfWDIwE9xeixi+slhZnA/McmAI/kypZiCG6kXSHB
	 n0yb34Zg4iRlhvmNJfa/xz+Dm0obJ1sjAQkCofzfzfI1sphmzq1H/n0gOZTBGYaMqV8mw
	 53lGBd1qVtxz73pTwq6WfBV3o+mxuH1tgwGtVsRk+1OCsi6TeweUna3P/tDFv+xunbe1s
	 uadS9iLvC5LbGzdVcaqYNMHB7hu88LQ4W+U8RYSb1GDFg3xcvY+7OSNlHO+dLsczIqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916445;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Info-Out:X-JNJ;
	bh=FfaegcM4A57BNyCt6xFHx30B4jeGSW9JyHGcmPfnxrQ=;
	b=d9nscS3JM8CA2Idex1tw5ZDt3MtyCoSqYgeF4h+f3gaYsUzgs/fBdT1HS5ilts6fmgPf
	 CTKUTjoNi+/T02V7F3eWSUMH7BPn1R1pstpBoHJ2T5nSJ3L3ls1bFSPhQIWXPt/P8qwlv
	 D/ni44WrvMDsq0ja3S482ULy0bE5/iV5ZgXC8bzDj2+KZwmxq2kc4273+Arfskh7brRd0
	 sE3I36iXxcebrm0qN/bDBAUZnXaiiQUmSIYz7D3BCtZa7IUdtJ5jWgDEcXgR+iNfffFH0
	 fUtRY1sB3H7uLDFj4hCkOnXeoB62L5rXkc7fjZF4qo/qbCuP4K6GU3TDKxybUDPTDog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=nvxkrOpf;
	arc=none smtp.remote-ip=57.103.64.70
Received: from outbound.pv.icloud.com (pv-2001a-snip4-7.eps.apple.com [57.103.64.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A080E606A8A0
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:54:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A080E606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=nvxkrOpf
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id 5D2E01800590;
	Tue, 17 Nov 2026 11:54:00 +0000 (UTC)
X-ICL-RepId: 01a1e95b-58eb-79b4-bc29-3a631571c354
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916444; x=1826452444; bh=FfaegcM4A57BNyCt6xFHx30B4jeGSW9JyHGcmPfnxrQ=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=nvxkrOpfdUyekpUfBYIzSQ8RuDRRXWiZAtJ8VxzvfVjyHM4wIvcxbaROfXubZSsoFSDGcFhX1mRk81sUZxQKa+88RTY2FLhBqf9ehY4SryB7MrGklYvybJFsLHAYygKa8Pa3OwsHi5WZTZRbCyj6+36w+JJguz5tni2guNoVkdIjcZfuCiZTq57xIUI7bd2lTERd9XNnVYtwZH6OsiUoFfSH/C6Qco1savVYwPK4UkToBdTp2z/YbrUHXUEOXFeEd2iZRJXtpy3KWTshjwnNCgYkV6cXfp+fq3oGwY6n6ghOCwLJ1iUnI4HP/Iqe6ibB0ve0qIy2cbjTld1yfOWpkQ==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id AD6C2180020F;
	Tue, 17 Nov 2026 11:53:55 +0000 (UTC)
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
Subject: [PATCH nf-next v1 4/5] openvswitch: conntrack: do not record connections above the zone limit
Date: Tue, 17 Nov 2026 14:53:07 +0300
Message-ID: <20261117115308.95134-5-deliran@verdict.gg>
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
X-Proofpoint-GUID: gPGlgoP6yisFV7EkyvXZSTS99B0aG4_r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfXxxQQuCgtzCLi
 cViC6UHdfAJv/SfkAcCPyROaa1+/zFdpiL+aIv5bxD5U6yL9C19XIXbZGdoQL3dWSKwQ16aYW1i
 R/1whHiiWd310/MC3p98P+hzc3Fb+MNhG/XwBlW2aCHaHC3x6U4JZVi5B1ENDLVjtBsjRRXnh8I
 Dm90Jp+TUlUp+JGxIhgZOVkhVDjhIA4+cBzY6KxYRAulgf3qd2JUIzvP8bKWOvUNHjZ+AlgWnAG
 zdUdbPN2mn6DhmrNFzicXMM/oHviODvtkKkGXoNwoW4o8xmP/PHQVKkHMuiwoWIshRydN02QQji
 8iX8s8QIMrlptepAhKS0CvjW9TDcVXLmxdHJoaDSdoQkVqWVirG1elj/zM2tDU=
X-Proofpoint-ORIG-GUID: gPGlgoP6yisFV7EkyvXZSTS99B0aG4_r
X-Authority-Info-Out: v=2.4 cv=ZMDaWH7b c=1 sm=1 tr=0 ts=6afc4059
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=V9PnWA5gqNY3N47hGgUA:9
X-JNJ: AAAAAAABtHZCfKoXD+vXwrUqDiN4CysCExAL7oe3ijLCb67KmOEACo/yHa5ev614U6Pnq1
 AdLbAaFLjfBWWWws91R0qvGqZOieVlOy+D7fLKq0Yq9XKSyBzTi2VBjfa1qUJuBY7q2CSq
 BQ1UOdViuulUVS3bbBPrwz4xi84o60kfPecStld+nmR5iwANESJs8/RFcduVZB6aFLrl2N
 RF7tL0v72PTw/lVIiit79qVKqPMaUJnkvp4OrGACBpYXLTMUmT5Ofxk1LC1gZSLM5+iaHt
 N1yYlv8Ptn5d+IZs4cGFVaXmvzbqddmwhISz43oJ3jIZMQhgd2LApnWRopj8xEH1fVzsY6
 dTwD7dfeZ0H8L+lD5Mjb9l5XXVLYFEk6PIqY9TFiBcx0TsjGQSQxHXbKAVZp6vE6e1A9Ib
 f6VPxoKwwZvtSFF+qWk+1yTZICuPUv44iGHn0bZEbh8DoOArLYSKSd3SfcL2609DlmNcUo
 utMdvh+shdAGkb4K1DqR0HLQxkqnRJXzffcmCIgp37qwvOj4CxafvxMtDCNptJrqg25TAa
 h4iyjGKIwSUhUOVLXBO0KFSx9+CE7FOFikUcHmpAn3Yu5HPrMf1Ktv1vu6VkvLbFFyPVrj
 9tgbuyaRvCKZss33/1MNR9gaYckt+AuvF5I2TYUMsIe9XYenCvaN5dAzHJD9mQJ9mS/32W
 WA8+pTITUhPAVhGgJDz5IZp0fO9ChyF9A/+wGIBmJuekTz5hLlyAj0/lyHNl73jUdCvioZ
 RMY5iA3yIiu6pWcI1Q+cTj9MeJ7EYU1jBQgs0duEhB/ekGgCwO69p68UZwmDwIaHheMJv1
 2w/j3oiWPxhDgrlP1OC7GyHATCXXHyXnGdfM6AbcBpCToubTML70WgTSC5SqO5spWltrFf
 ujcUyBlRr0VLYGeVFSj1eQih8MUwsueYMutYCSHqd6+nQpSWhgoHY2FUot0AEltvQFTWCh
 6qzRp/CmtgjDRiy+abHzFjZ8

ovs_ct_check_limit() records every new connection in nf_conncount and
only then rejects it when the zone is above its limit. Recording means
taking the zone's list_lock and walking the list for gc, so above the
limit every rx cpu serializes on that lock for every packet, to add an
entry that is rejected right after and that gc has to evict later.

Look the count up first. nf_conncount_count_skb() without an skb does
a lockless rbtree lookup, runs gc on the list if it has not been done
during this jiffy, and returns the count without recording anything.
When the zone has no room for another connection, reject on that
count and never touch list_lock. Below the limit the connection is
recorded as before, at the cost of one extra lockless lookup.

Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
---
 net/openvswitch/conntrack.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index d3326edcabf7..e78a62cec051 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -955,6 +955,17 @@ static int ovs_ct_check_limit(struct net *net,
 	if (per_zone_limit == OVS_CT_LIMIT_UNLIMITED)
 		return 0;
 
+	/* Nothing is recorded while the zone has no room for another
+	 * connection: a lookup without an skb is lockless and only runs gc
+	 * on the list, so the count keeps following the real number of
+	 * connections while new ones are being rejected.
+	 */
+	connections = nf_conncount_count_skb(net, NULL, info->family,
+					     ct_limit_info->data,
+					     &conncount_key);
+	if (connections >= per_zone_limit)
+		return -ENOMEM;
+
 	connections = nf_conncount_count_skb(net, skb, info->family,
 					     ct_limit_info->data,
 					     &conncount_key);
-- 
2.56.0

