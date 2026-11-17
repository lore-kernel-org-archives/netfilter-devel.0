Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.63
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916449;
	b=424OpY50MXLaTwUU70RQJaqd+bOotrMhn3dWQ+sBaccgu8UTRNUKrp7o9CcUE6eUmiFb
	 guagv2ESuGVKSVbdYGHO15B/KeeDuwcYElXTO3XazQRXk+DmgTqZgT69LwjCdEHvcp8br
	 KDvd0J5FqUe7wSNnqZt+YiDdXMySvsSYtWlPWvJyykkB3amEFeAv/sqKk5+FWUy1ucnXy
	 amwS7uUYh671dG9WavSWpyDUrV1jkSb+xTzgB7TgjYND+eOlV5GP8au3rzl8Xb0oEpllV
	 xqa/OKsSzXe4BqjHdZYrmKxHH4rwXPUvzMx4YV8dTaxP6bsMS0bAX3jKJ4xPAjoLL3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916449;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Authority-Info-Out:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-JNJ;
	bh=P0xxoUs9j0P1CWGaxnGX6Bo+wyuRqKebG/yVs9MJHlY=;
	b=cj2fSElBiu2mAkajNkaaBATLb6ZNOlem7d3fdAlgHllt23iwANa5GQi3iNHLAEf0DjPr
	 6UJ1KMhIRZxvdH34fmLJ30qD/nvbDAFe/pboNo9Tlshw6AWV7ClYN5YZ4x5gQbotdhuJA
	 VxwPuKKWgkgulRdv2cTmQ7NL74ml/1d1VPiArj7NeTmq4eXfuQAtxaGAszgGT7NF9zVI5
	 icAMaK8mK6wYEDgP/DcObenubJ2AlI1IG9FlMtaF05SX4CSVI6VhjpK405V3x3pwtWy9d
	 cqDrYE6apbiWpSvoxy2P8ls3L2Tnb0CGnINXES7Y6dD3RDXrp0khKbRU66cuoxP1hog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=IO4c26DH;
	arc=none smtp.remote-ip=57.103.64.63
Received: from outbound.pv.icloud.com (pv-2001f-snip4-11.eps.apple.com [57.103.64.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862AD60A2605
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:54:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 862AD60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=IO4c26DH
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id BED0F18003BA;
	Tue, 17 Nov 2026 11:54:04 +0000 (UTC)
X-ICL-RepId: 01a1e95b-6a21-7453-8695-5d61e638757a
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916448; x=1826452448; bh=P0xxoUs9j0P1CWGaxnGX6Bo+wyuRqKebG/yVs9MJHlY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=IO4c26DHkOV23xyXp+/IXaiWu6OJcUi03SUgaqpWGwAh5kYv2hf9hR5qWH3kB41sFjnvS+FRpuFnqk6g30BkuLX80j0eDRYDA79ehNZNq8bMoUcx7HzPCPXXzs24pY/GwtP0XEzBPP264jro+6rc7Ww2V36D0411dCOThJ2PPFpzyYld4/zvnkIO7VMcD0KuwPYoJ/dEPcslfbYILwdgDxgyPnoLVnEDIwNf3NFn1rNbQgLL0eJSXiVcAcQUKSIMkSLg4ONMZ4OuYLwttqevRsIi2Ib8G7boXHV7YyYTaIikeajH/1zP1aUixtwUKZFoLrFY5wn1TA1z5ojPwmfwEA==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id 2C9A018000B8;
	Tue, 17 Nov 2026 11:54:00 +0000 (UTC)
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
Subject: [PATCH nf-next v1 5/5] openvswitch: conntrack: warn about a zone above its limit without a lock
Date: Tue, 17 Nov 2026 14:53:08 +0300
Message-ID: <20261117115308.95134-6-deliran@verdict.gg>
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
X-Authority-Info-Out: v=2.4 cv=JJQ2csKb c=1 sm=1 tr=0 ts=6afc405e
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=TH7meFVQux7_ahsOFuAA:9
X-Proofpoint-GUID: tlQ7z3Qdkz-utRS8JQ5irt5Uum3hKtv6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfX6GilhJKgNguZ
 igc44ZHids+OApCaZbfrORCvrayqTTvSLL1osoyuHv/XmJGTz/TdnkcmbV0ZAre1KmBpTnVz2PW
 wKvl07bw8fbnYFFPDbJOKClTj9s0ZTK/3mIeTaWNa1IhcKBwdXEhMYkoxlh7tv/D5PcOzwnT1uc
 c0gk6THnT67R/0mQ2/cI59Pj67CTzCR9kVbNTWjCmR0F1SAza/NhjgBkziQXe0WV77EvtnTDatk
 jTLPj1HoH/au2VZEhj1t3AiixUjyTkzQkzgzUTrxPYXVzPfei24Jh7hJmDhfmaA2Nbiqa/afSgg
 J9QOOMPvteomTO8h1XXnShsQxObGsqcCJFZwp9IQmthcPRPtUQgRpBELZr4fco=
X-Proofpoint-ORIG-GUID: tlQ7z3Qdkz-utRS8JQ5irt5Uum3hKtv6
X-JNJ: AAAAAAABChmYh3zpw/IMiSEunOG8IUvP3o7hQ1CNIIe0ZowKDuRcc5rsyM72gkg/lsKI/G
 9b+XzCieL1jVha5hyEl7Gjv5PJLPSXmKRXWOELkYGflu8IGY2uuRZCcSdgI4hy/1vXdv1+
 O2CffnQD91UygBXqQgHzdeGIG+bmOu/yoU1lE8Jf573gpj7T1OwF/GbmE6/3jK1En1PuXA
 xMk9zmPwtSTtwyCWsJKsGnpacADeomFtqgNEzZArY1tY+rj92boNR00kU5zgLjHu8xZ+b6
 ODL+871T3Y8QEzEQAXghbKXGmiZ62anKRYJFu4reE76mkDpVcTFssP0TDja4xeA1vR//ix
 POzYw/knuRrSt+B0wDiJ1dPj1oo8C0boQAlBCJqy1h3RxIy1D8aEm0rUeZYKwgdvmFGEmq
 LjUPmxLZASWaWtFUyAq3ZYKUwjX/ye3alHX0Nj5S9dlfGdKTWgVpXBRrrwVwEKZ+4EHGK9
 RV5VYyqd+znA49lsxSPhnwhXqmh4a0vjcCVgH0VcUQi1TdJBER/zjbszZC7C0RKNxkr4Nd
 2L+g59yUuRRwzrlRwCxs008On12IojI55MxfCUPfFi6S9aH4Kti1NfDSpZwr4pC7JaqEhP
 R9jch6W1KK59v6oiAJ76oWuxHveikOgGOk8RY90RruutGjJzjago941/dgU3T0SWG+At+V
 2o7faSd70JMURAzh6sowIbjQ+A3DSOyVwAzkUyeKwLlKd/pSsPROTEb+iKcXHVLvGlkGYt
 bsGOcqlJbppm9t7xQR/zP8/xKaIBBNcmgKZWyI7YXoCPTqaSH8dR6reXN34sKQwSSfnSyf
 XXD7WoM7AKas3CK0S2Yg0tVR0uPSbEPG/Fw/VrXroZ09v/VIvgd1WSlSEgj4r2GY7G4qDi
 Vd3NUnjUaKRghcoWj4v2BXMNfhW0FYejemJJ7/yQ==

ovs_ct_commit() warns through net_warn_ratelimited() for every new
connection a zone above its limit refuses. The rate limiting itself
costs: every call serializes on the shared ratelimit state, and with
a zone at its limit under flood that is every rx cpu for every packet.

Keep one timestamp per netns instead: a caller that finds it in the
future returns at once, the first one past it moves it a second ahead
and warns. Two cpus racing past it in the same jiffy may both warn,
which is harmless, and nothing is serialized.

Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
---
 net/openvswitch/conntrack.c | 20 +++++++++++++++++---
 net/openvswitch/datapath.h  |  1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e78a62cec051..ee90af14ac81 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -936,6 +936,21 @@ static u32 ct_limit_get(const struct ovs_ct_limit_info *info, u16 zone)
 	return info->default_limit;
 }
 
+/* At most one warning per second. net_warn_ratelimited() would do, but it
+ * serializes its callers on the ratelimit state, and when a zone is above
+ * its limit every rx cpu is a caller for every packet.
+ */
+static void ovs_ct_limit_warn(struct net *net, u16 zone)
+{
+	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+
+	if (time_before(jiffies, READ_ONCE(ovs_net->ct_limit_warn_next)))
+		return;
+
+	WRITE_ONCE(ovs_net->ct_limit_warn_next, jiffies + HZ);
+	pr_warn("openvswitch: zone: %u exceeds conntrack limit\n", zone);
+}
+
 static int ovs_ct_check_limit(struct net *net,
 			      const struct sk_buff *skb,
 			      const struct ovs_conntrack_info *info)
@@ -999,9 +1014,7 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 		if (!nf_ct_is_confirmed(ct)) {
 			err = ovs_ct_check_limit(net, skb, info);
 			if (err) {
-				net_warn_ratelimited("openvswitch: zone: %u "
-					"exceeds conntrack limit\n",
-					info->zone.id);
+				ovs_ct_limit_warn(net, info->zone.id);
 				return err;
 			}
 		}
@@ -1638,6 +1651,7 @@ static int ovs_ct_limit_init(struct net *net, struct ovs_net *ovs_net)
 		pr_err("openvswitch: failed to init nf_conncount %d\n", err);
 		return err;
 	}
+	ovs_net->ct_limit_warn_next = jiffies;
 	rcu_assign_pointer(ovs_net->ct_limit_info, info);
 	return 0;
 }
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 7a7afaeceee5..9c6a5b5a8939 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -177,6 +177,7 @@ struct ovs_net {
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	struct ovs_ct_limit_info __rcu *ct_limit_info;
 	struct ovs_ct_limit_info *ct_limit_exit_data;
+	unsigned long ct_limit_warn_next;
 #endif
 	bool xt_label;
 };
-- 
2.56.0

