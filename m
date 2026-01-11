Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49F334CFD8
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149611; cv=none; b=cmoXjsvONiqt3aKjPwjUh7Ccd9LNu7dc3hxQPnk8qvxZt/KLaKlqkk4l0f49JEqyxB7O8H5KI5FXwDzx2Rs+TgnAyRIHrt4Lt8ABhw2z4DkvlZhw+N5Wh0d0+ynhqd+HjC0yfYIR+u0vL2ogEbhPaL9ZL3gLMot0pXkB+5HqIbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149611; c=relaxed/simple;
	bh=6GbE6f4BtUXWP/Ufu0vmCOgOxmPt3viYw/LQuct9HBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q8IsdN9MFrKs15iwJacHeesAfy4+SE0p1/9qiF/cIspeWj7wVxHWwqF7l+GSih8YAW8PiDZO6Zo7z4Dn/qXUH+93+re0uWkZhr4v8W8jXhuuRFx5JBQ1T7ZVNRdPdvZlIS9kvFXt3wLTmZXsUS32hswsvGh4C/FlvuPgPCAYT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=OuybnFhx; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="OuybnFhx"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2d32b9777so851618885a.2
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149608; x=1768754408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x22oIWAL2IaU7yqhIG3e7EI/+fsh+jdKMlHxh57/vdc=;
        b=OuybnFhxalCpvGmIKkZH5T8KQe29HVTmodb+5RHRC/32nxwMaQWWr1xcL5dYIbnyf0
         T2Q/bsR6BI/lSC6skkdJZY68DlWqoqSldLCsniiBRhU10joQqAesiURT9xCk+3hJDzY5
         8T3+FPh5saqCxKF1CvRPHADS4woJeuqsMF+yrvwzTPMmqUOKvstt29iX0B9+/TcAz5F9
         OL8jjnyt3vcES8kcVim3CwgVONLyaoYj/7sKH1w6eJvVjeEXWI02TYk8J50xeOmi/omu
         PQ8K7BSZ9JU0PTy0PXGdoMe2PFscKvuRFdcuULnz6OJSC3hVDFC062wpWnJwodkGRczX
         5Hcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149608; x=1768754408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x22oIWAL2IaU7yqhIG3e7EI/+fsh+jdKMlHxh57/vdc=;
        b=WZbnba+TZwRjFhfoKlBmNvixit2PHmCmocYE0bIg60Pu+uWdBRuwFosMj+ar4hyT8K
         Ck30lp2TbQQIVOTQRsZKNX4RKOe+iBNXXa355zdWzhdKlg4Drz/8a/LHX2ccn1pwCgWK
         a5AVNT+pKPx6AB958CtYLEaIFFLwxxoAO+quB9Ls5aJMqSM317lD7ZyWXB7FJ0dGxoHB
         dLPR0QU9USDw6luHTt8JQUyIKdL1300GQEIIBZozR5FyadKoWWYU4dJ2tlhziINBu185
         mHTDtsjfKZD67UNg71pAkW7irhcIRlEGdJ80wqbX1WNUWINyMSB9cWvIMrkBUFST4xI6
         9UnA==
X-Forwarded-Encrypted: i=1; AJvYcCW84RZB+YQaAav8myTjAL/0JCpkkwYFRUG3MQ29y1x4yBzl3f26qvIOJh9R/3uHoYkqvdD7CLmUKDz+l3oWdbg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzwh74xj/ChWE1exGtBy1krj1rhb1wuzk5OxSO9oIuLIXoPLao
	2lkGqYss49MFCTPAOxETDGS2rpjT+GuEtVDwMOKDZb2mLF4Swl2+/4NTa7fW37ORrg==
X-Gm-Gg: AY/fxX5UEcllKZvu1rPX9rz2Wqqu9vCXXsSipCalZFl6ZBV7elXGzJOg1bYDRgs3cn8
	5ZajVf+hFysis4GGQ6buqajG//QBARZZZF68R2lp6rg9OE2pT40XUUV5HeWa0smjpEXPSuFfG2U
	pleFJV/dtG1XT4gTQIelNtG2s/n2dAidgXj+E8Qfe+u5WuIoyqIRtfPC/89dPECSLWK3ThDN9E6
	GHbh3hXRXaJ2puX6hN8NWeELLla9TgJWDiBsTuW0NFW7NwP+7huRXBNUNgP53k3wHnxrSPEzGxE
	JjK0Ch2Fn+vO5LDehla7vr3I2h+ARJX83vTHC2TTQxUtDPbValD8xiVXCvfCkOPeTsnQhNOmvhA
	NAQ1m/3Z368KyYkV+5mdQ6gtbkAWIYlFyiYYnarXwkPBn2IqngyevvjiRFGO6tYMtDTRs50v5ch
	8/ks+MoZK7k/8=
X-Google-Smtp-Source: AGHT+IE7x5Z+vaVdvZhh0LcIyHH8cD7B8nl71csdv7qH4MMTDSuHzNvPOmbATnKKsyn08YB4cQ/QWg==
X-Received: by 2002:a37:f502:0:b0:8b3:3d62:67f5 with SMTP id af79cd13be357-8c389379dcbmr1523764985a.11.1768149607620;
        Sun, 11 Jan 2026 08:40:07 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:06 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	zyc199902@zohomail.cn,
	lrGerlinde@mailfence.com,
	jschung2@proton.me,
	Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 2/6] net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
Date: Sun, 11 Jan 2026 11:39:43 -0500
Message-Id: <20260111163947.811248-3-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mirred redirects to ingress (from either ingress or egress) the loop
state from sched_mirred_dev array dev is lost because of 1) the packet
deferral into the backlog and 2) the fact the sched_mirred_dev array is
cleared. In such cases, if there was a loop we won't discover it.

Here's a simple test to reproduce:
ip a add dev port0 10.10.10.11/24

tc qdisc add dev port0 clsact
tc filter add dev port0 egress protocol ip \
   prio 10 matchall action mirred ingress redirect dev port1

tc qdisc add dev port1 clsact
tc filter add dev port1 ingress protocol ip \
   prio 10 matchall action mirred egress redirect dev port0

ping -c 1 -W0.01 10.10.10.10

Fixes: fe946a751d9b ("net/sched: act_mirred: add loop detection")
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_mirred.c | 45 ++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 05e0b14b5773..9ef261e19e40 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -26,6 +26,8 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_wrapper.h>
 
+#define MIRRED_DEFER_LIMIT 3
+
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
@@ -234,12 +236,15 @@ tcf_mirred_forward(bool at_ingress, bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
-	if (!want_ingress)
+	if (!want_ingress) {
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else if (!at_ingress)
-		err = netif_rx(skb);
-	else
-		err = netif_receive_skb(skb);
+	} else {
+		skb->ttl++;
+		if (!at_ingress)
+			err = netif_rx(skb);
+		else
+			err = netif_receive_skb(skb);
+	}
 
 	return err;
 }
@@ -426,6 +431,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	struct netdev_xmit *xmit;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
+	bool want_ingress;
 	int i, m_eaction;
 	u32 blockid;
 
@@ -434,7 +440,8 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 #else
 	xmit = this_cpu_ptr(&softnet_data.xmit);
 #endif
-	if (unlikely(xmit->sched_mirred_nest >= MIRRED_NEST_LIMIT)) {
+	if (unlikely(xmit->sched_mirred_nest >= MIRRED_NEST_LIMIT ||
+		     skb->ttl >= MIRRED_DEFER_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
 		return TC_ACT_SHOT;
@@ -453,23 +460,27 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		tcf_action_inc_overlimit_qstats(&m->common);
 		return retval;
 	}
-	for (i = 0; i < xmit->sched_mirred_nest; i++) {
-		if (xmit->sched_mirred_dev[i] != dev)
-			continue;
-		pr_notice_once("tc mirred: loop on device %s\n",
-			       netdev_name(dev));
-		tcf_action_inc_overlimit_qstats(&m->common);
-		return retval;
-	}
 
-	xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = dev;
+	m_eaction = READ_ONCE(m->tcfm_eaction);
+	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+	if (!want_ingress) {
+		for (i = 0; i < xmit->sched_mirred_nest; i++) {
+			if (xmit->sched_mirred_dev[i] != dev)
+				continue;
+			pr_notice_once("tc mirred: loop on device %s\n",
+				       netdev_name(dev));
+			tcf_action_inc_overlimit_qstats(&m->common);
+			return retval;
+		}
+		xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = dev;
+	}
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
-	m_eaction = READ_ONCE(m->tcfm_eaction);
 
 	retval = tcf_mirred_to_dev(skb, m, dev, m_mac_header_xmit, m_eaction,
 				   retval);
-	xmit->sched_mirred_nest--;
+	if (!want_ingress)
+		xmit->sched_mirred_nest--;
 
 	return retval;
 }
-- 
2.34.1

