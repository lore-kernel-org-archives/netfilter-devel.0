Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40D04ABBC6
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002654; cv=none; b=ZQ4VxC/I3+dp2J0zhymjIJRjTfFMSWA2+zqtEf7tY8Hucy9mi+N8PWqS2c9DEjH/vaqOMY4QHYBzFJU92AxnjZzCz+cnkB0qQ9UijwiIgFFjfi28vPrKMobwOjCqXBw63RjbSidTyNRbq4qojCHANPFMYX/8pV6PykN+YLLO4AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002654; c=relaxed/simple;
	bh=O84UlgIt22qVXOTeLEKlJ+J21Nne9exAai0M6IVznd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZbvopg3qi11QdxH41Phd9Xwwai+eVIPSoTaKeu9qkHupHqovQHDakZ/ihoyxPwlA43ZkphbLPPuu5QWvSbkM3m0oEaLIyzfpv9MePzLkquSFGwUFNfGvHp7EuQHASelC4D5X4Mg2QQXDHflUOk7dBuRBcc34ojxolSN7QfA6Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-49b963f51f6so13081625e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 07:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790002648; x=1790607448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D5yxLi0HeeDyCNaoa/cXH7lPCvNUM8Mh94Wvp96R2LI=;
        b=VXOOFaYXiolvm+RmwtFT/a3ThNV7gbqxIX8hlHjqBUh2myzaGxNjm+MpTHdo/+yUK8
         GrqLXsVtIss2N1FSSbJI0C/aiuTLM8CMkShw9jiFQFTtuwpq4XewqPknuvKXIpSBhmmz
         AmG5fYy5AyWZ5tZ4BwQH0EgPekn0SOC63pjuxAGTX5U2oSqHQSOonuzJU4VBq3RgKhFi
         0vxmAmF+CRG+pPWNQA1LAqCDTUSIW1/dXYvYn9UUugPEbserKn5ggkT5vpFfM2yRdc1l
         Sfv/f1gD7tirGqY+/r7M3rzGqKE6uBr8zdPUnm12iWs5e4cFknnVbUpFHjvHP0RoyU4+
         SrWw==
X-Forwarded-Encrypted: i=1; AKwUvByX7s93W7+4O/yro2iAa9N5HzBI8pv4H7IIu/zJrbvCrbi6zOycAlxfj8ervukEincWhvoMNAySuoP9elE9lrY=@vger.kernel.org
X-Gm-Message-State: AFuF++mQCJcrK1etPmzxzHiiKYU+ARqt2ftvkUV59Cy/sqCrIFQjmj4M
	QGlwARcDrKakmIOvSWO+x4Kl/W6D8Kk2bG4lUJdkzTH/DpEEukQCX1N4
X-Gm-Gg: AYBFou1jjUPbnhkwVIE3dW02nBVCPxzVCRlXirjXEVNEzPaTv99awKr5TkUz1EgI+0r
	n4HtoPttdRsjHYrjR5hHQgo+tSNMSogmyNlX9u5pYmplbM1vtT59EeIzg44QuxzVi+ul0ALTbCF
	TkZ76LCjIIR+z/+VJjsiEOra9XC568kpwIU5NPXzCP60XTUom1xRs6xY7QT1S/8lpeVfwl6zKI5
	KlIFQCiFm2ArU5oix/3mbkhUYcIAw/iuLoKymOp31V0Z+PI3LxGZVPZghx27XgdZxHw7ThKYCyj
	0CmV287IdPrP8/jFSfLSc9xU39luQX6tXdj7E5EnqJNrRjBu0afCrTd/7/+ksRMmfLWkk0XgAnK
	drfomEgM3ZwC+piLfcqx+AGQmX96i4kwefmf2y3rVAUE7pQORef1sN0TpmZlXRd8j3MZZh0tZLH
	IDaK30mFaJ1MgJj8qgyXNtQ/HXiTzLtyBa0ctqZpqqBEipJDVdvtJSOSXGDpQrwup8KRAWjSRER
	aRifw21RAJ5NziZtM649ea+U4DqhFyUdBWaOlNafqdfd/+LIh72p4g=
X-Received: by 2002:a05:600c:34c3:b0:49c:fa21:e74a with SMTP id 5b1f17b1804b1-49fc5757f73mr156995365e9.32.1790002647731;
        Mon, 21 Sep 2026 07:57:27 -0700 (PDT)
Received: from im-t490s.redhat.corp (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd0eabfcsm243153905e9.3.2026.09.21.07.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:57:27 -0700 (PDT)
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
Subject: [PATCH net 6/6] net/sched: act_ct: fix helper UAF due to extensions realloc
Date: Mon, 21 Sep 2026 16:55:48 +0200
Message-ID: <20260921145655.3167436-7-i.maximets@ovn.org>
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

While calling the helpers, a raw pointer to the extensions area is
wired into expectations list:

  -> nf_ct_helper()
   -> helper->help()
    -> nf_ct_expect_related_report()
     -> nf_ct_expect_insert()
      -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)

In case the connection is not confirmed yet, more extensions can be
added afterwards with *_ext_add() calls reallocating the extension
space and leaving the now invalid pointer in the expectations list
that is later accessed while removing the expectation.

Make sure that helpers are called at the end after all the other
extensions are already added.

Note that the helper rejection now leaves the mark and labels set,
but that's not different from how the NAT was handled before or how
the mark and the labels were handled on confirmation failure.  And
there are no atomicity guarantees provided by the API anyway.

Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 net/sched/act_ct.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f62051ec9d57d..411e3dd92d072 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1102,19 +1102,25 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 
-	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
-		err = nf_ct_helper(skb, ct, ctinfo, family);
-		if (err != NF_ACCEPT)
-			goto nf_error;
-	}
-
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
 
 		if (!nf_ct_is_confirmed(ct))
 			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
+	}
 
+	/* Run helpers for the connection if nf_conntrack_in() was executed
+	 * or if we're about to commit.  This has to be done after all the
+	 * extensions are already added.
+	 */
+	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
+		err = nf_ct_helper(skb, ct, ctinfo, family);
+		if (err != NF_ACCEPT)
+			goto nf_error;
+	}
+
+	if (commit) {
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-- 
2.55.0

