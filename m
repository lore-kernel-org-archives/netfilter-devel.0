Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC6E3D954D
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002647; cv=none; b=J6dIZf7SBkBNM7SM7i6pYA8iyVC7XgUMbPtPRMSHCH9al2+t4/cbuB+eT5Lj6YbWcIxHnw752n8Drn1VBeKT3gKtr2BiIEa54V4pRYd4DvlJKmoZ2ZufkdmpIJsBWy9yoKMME1KuslF9e3uPwjrjRbIkiVZQhCm6K45wOKY9FFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002647; c=relaxed/simple;
	bh=GewYnmEL4DmNXoNcMZj/SIhw9+Nkv+8Qj+/vw7RBrBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIRxEDa1iI+Gm5qD7Y6zZKubQFfRIxIHhj2l+T6VQzdnhU5lDQ35/0721yI38ounxRNi5Bxq/xezwESVep3EDPKTCTUEjFvhb7KP9Tj6WH2FqqSw/XKo32RX/yy75FLuXxzmps5td+wawgRZtzkhlnKCTjndGX8tztwXZj5Or2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49e8361492fso12426785e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 07:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790002634; x=1790607434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pQTMqBWHnIAoQBjOra2YMizNpxK4ySQgVrZe7YnTaiY=;
        b=gbUXFs2+cnZCaldWXIG7q3wcB9t0rhKnpVWED+m7QNhAsuQPnoEefzXWixNRLnS624
         Kj2+6vkv0J/vHa1WBdgbfNcqfc9fokzqmKgrrlGuHlkfJA2qOMjN8QuOoBI6qP6xYEIo
         boPFXpEPB9Y3Nf8ppzN89qshMTWYPYIFSsJEdLhRmhgo3QZhGVdczPNlv8K7a7+znRZW
         vg024kOySwR2mNmZKh1DX8A9YEgBDGa7hZJaGOOAUvroNJLVzcrDatmOwt696OVh0jK0
         nO4Ou7XJkZb0cGYQfKj2eCMmnRsq1HEm0bAkPbqD+coUNzXBCqsKz910a7iILlW8xS1a
         0XaA==
X-Forwarded-Encrypted: i=1; AKwUvByPZKsbJfPFgUJ2MTfvyvF4tpGlxMCZ7qufrBRXuycGUHqOmThF7kjlLQZbjj7eRgZl7BLUf8kThN0i9bjYie4=@vger.kernel.org
X-Gm-Message-State: AFuF++mefzSD2OA/Ro4aQovXcS2Toj/jdiY+CcgJygwgTx2xoD7agW5y
	S6qRbQ/eQUvPtFx6xuupY9ey4ebviZkUePJ/YjduztvyX22m8uXx1SIh
X-Gm-Gg: AYBFou3n8lsdUSIdfI4w3l45Nm/5g5wcrDiP1QXOzAH8AyC9Og+dYJzF2F3Y0nAmuqq
	UG6AHwV9uTFOIqa+9dItv3quQL+c0Fxol7cl16J8OX40mCIxPr/lYdVMkYgQNyhW/qB3AXb/MFz
	QoSArMdLKy9wkayoQgswo8HWVrieAY7uvmUmcN2HuNnpFUHpis/LJjsZRfxs+ikkgyK57hsveDK
	QIpMLTfz472G0NqXPq0R9HIZfvr9pZkeiMcQ9CbaeWeYKYV/EdKHZrdBdZ/nYc/2TZK3sQCs1Uo
	9I1vB7vgJMj9u6sbwe3JVpeOX5agTv0Y2tkgRI3NCisRjir2fNZJCZa2J8YwhmSddXpIibzJoeH
	3cZcdKZxDYnuCdmjnXfgZ1IiHc9q0qxwQwh5uC8QeHdwiJ5dV/URP2KR3NUnA9YmU4zEypxlbs/
	sAWprBGo2MmpauaitXADjl38IVnRgt2Yic0jNmOGiYcMMnD+iiz/D3ZHWRQaS9DdQUYKqNaA5qe
	w8/q4r0jT1psbjANZeCODmwdY8GLiIH1Kw1yuDM9P/N8+4sjolv
X-Received: by 2002:a05:600c:4e86:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49fc566e6efmr144949645e9.4.1790002634076;
        Mon, 21 Sep 2026 07:57:14 -0700 (PDT)
Received: from im-t490s.redhat.corp (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd0eabfcsm243153905e9.3.2026.09.21.07.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:57:13 -0700 (PDT)
From: Ilya Maximets <i.maximets@ovn.org>
To: netdev@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org,
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH net 1/6] net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry
Date: Mon, 21 Sep 2026 16:55:43 +0200
Message-ID: <20260921145655.3167436-2-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921145655.3167436-1-i.maximets@ovn.org>
References: <20260921145655.3167436-1-i.maximets@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a case where skb with an unconfirmed ct entry gets cloned, we may
end up committing both but with different sets of extensions.

The series of events:

 1. The first clone wants to commit and runs the helpers wiring up
    the extension pointer into the expectation list.
 2. Then it looses the confirmation keeping the entry unconfirmed.
 3. Second clone now wants to commit labels and adds the new extension
    for that breaking the pointer in the expectation list causing
    UAF on the destruction path later.

While this is possible to trigger, there should be no practical
network pipeline where committing both clones without modifications
into the same zone is needed.  So, let's just reset the entry in case
for some reason we got an skb with a shared one during commit.  This
doesn't affect any known use cases, but avoids any potential problems
with sharing and modification of the unconfirmed ct entry.

The fixes tag points to the introduction of helpers, since that's the
main UAF trigger for the sharing.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 include/net/netfilter/nf_conntrack.h |  5 +++++
 net/openvswitch/conntrack.c          | 12 ++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e65..c39425e54d87d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -185,6 +185,11 @@ static inline void nf_ct_put(struct nf_conn *ct)
 		nf_ct_destroy(&ct->ct_general);
 }
 
+static inline bool nf_ct_shared(const struct nf_conn *ct)
+{
+	return refcount_read(&ct->ct_general.use) > 1;
+}
+
 /* load module; enable/disable conntrack in this namespace */
 int nf_ct_netns_get(struct net *net, u8 nfproto);
 void nf_ct_netns_put(struct net *net, u8 nfproto);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0f433688e17b9..a733029c28dd0 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -734,6 +734,18 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
+	/* If the ct entry is not confirmed and shared with some other skb,
+	 * e.g., a cloned one, we can't just modify it with the commit as we
+	 * must not modify the extension set.  Reset.
+	 */
+	if (cached && info->commit) {
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
+			nf_reset_ct(skb);
+			cached = false;
+		}
+	}
+
 	if (!cached) {
 		struct nf_hook_state state = {
 			.hook = NF_INET_PRE_ROUTING,
-- 
2.55.0

