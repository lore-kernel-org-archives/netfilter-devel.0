Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615C3876A4
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790445101; cv=none; b=qhou2d9uw4S44NIfAerR9yImX/9ctX9lCo9+nxNCFZTlArBLIEjHdsbQFc34Al4rp18XsZLXLQ1y63LpmVUD1R2iSFfligFwZG99r6sc6CmI9Ow779NTEx0IPhAIEpXos4xxr0c9v1ZnW4cVOFCW4NAzNsvQzEUQMLdPgACcg/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790445101; c=relaxed/simple;
	bh=EmUMS+ZRzCUeb0rndVpz/BHk6ngRvxk7aEnRstACYI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NgTPOk27q8YtUr9v9ss/ZIW25KCEqR9Btbv5V1lIrciYX1cMogzww/XS+cxmw3kb79lOfX6tl++mnC3a73gWEkWBS6PeaY4yFW6i1CsXrZ+oiF6Mq3lXWFxlcrCcK8N4sHzJ/cTd9njS59eY6NRnRBBJwKl6odvK9DRFgKIOzc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jiCtCpt4; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiCtCpt4"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-34251480737so95540eec.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 10:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790445098; x=1791049898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kh+HhJ5EU4L73Wf3xyAcV+eWsVVzfBMuFzfcoxTkNvA=;
        b=jiCtCpt4vnJnOA8DpIpxUf0gq1glcMmuVGBKTFxetlmQ+0ybEnHVCNsN+BLRSLvx9q
         fYG8ZEy7pWci1/qQ3B1ofb22WapqefvEFIlkaO4jR9oHoUdV1JQxdyn5CEmbLIjG3o8M
         1k/W27mMNFIXm4l4lQrxNdNZ0IpaSozk4jP9PKZBFUiWEdeBjU2YVwa8PCFZfSoAoY6a
         /7VnqfZpwIWQLYxhHJ1A0uBIWF7nnBSdRpKzIEw//b3ot8KBQLSv2x1fFT/5sIpFBvjY
         cz4Q1txOOqmEWw449KGmcH6UG/wcDZdFlXfi4rXAdFUXsdnQkgpR1RNkO451zujkwP+E
         9WRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790445098; x=1791049898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kh+HhJ5EU4L73Wf3xyAcV+eWsVVzfBMuFzfcoxTkNvA=;
        b=F6EO9x4BvA9jHXayXAM3bHsHwTP+klTfwQ/xPZyQNssid7w5ZS9Z07/R98tykTLTf0
         sHkxDrF20CUPIiZsiCf5EjQexFJWgVD/MkJbbqn9TlbHLDad0zZ/nOaKKnPyhgK1a22z
         DzefH8I1/Mefcmi2wICuR0Z6qlJCnTgnbiF3vVfUkndGFb76TDES0OLf5xE7oVgbzz5r
         opfNWHpB3UsjY6Qm2bdxHzFqHl15tXUc9TVIl3wMgNf2E5Zpvc3ruGvZOIp5Vx/KLMaD
         XhLKqYqRuUJx6AVDmikV5uZ1QAauvqzlvJ9Tpp517jY4dVUNneKmO/loMVBAh2ZMFa0k
         2h1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzX4sOTGg0fSCuPNwJqxmHv8sHUt4tMH7QrNjjHkbfndiDYYudnbPaDV+yiXucfFCvAVLFhv5kuHjGPXfpABDI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLoqIEjw5U6z8+0Rb3Nkdf1tO5VvjD88DmKXSRWX7ZPnbgJ5U4J
	+AELZpzgc6JpLweYQhgs7WY4PmPay/FOJD476avZB6QVwV+DadHmAciX
X-Gm-Gg: AYBFou3II7IRCQyVCZeKp/pUq3WB7cdjoglI+2RV/Y28d4CAMwGpXI46MkbtMf2twig
	6u28T4a+9ko5SnDgyTx57txrMaCIVL85jSgA8rSkkqQS2wqB5bDgJxyG/sDmGLnAE6zfAXo88m0
	13b45jSaqz2bjjC5FGlVXZmhOWo70waKNn/TBfA9HG2sHBlHvZU5QvltcoC1tv6d//0uqFEJf3b
	v9uVqfDfGwl7gEKHhTHFUmtu11I7GTi0z+q2UG5tWSKZmpQlVYQqxIl47GdrnVJMuIEan3tx6eZ
	M0/qhaRVq3wXokOjECrshba+FEsqcyLO+tHISLd/gGluZpnsXNHAKQ7g0Ilb1VXX9ojTNhwjX9J
	iTT7CPpVGivUJi02RDc+OBN9HlSw9DmZkPxaLEnJHPUnaEJ/7YiZF1Zi8+25Evf9NhaC8amVPzw
	ChTzc8RL7tnjv5k6FNI003Z1UCnXbWuJEpN6wPsnqDFUtWzmKHiTwHJpaFmKbwJagqAG1vgFpW6
	caCRGT2Q/c+x0axqVXQ3JmJl/ZqSHR70ZXccLAxwD6npOaQgZmz8Lte0SdCuHbrUMeEIw==
X-Received: by 2002:a05:7301:540e:b0:33c:1bd2:1db6 with SMTP id 5a478bee46e88-3426d0df371mr5641086eec.0.1790445096797;
        Sat, 26 Sep 2026 10:51:36 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341459234a1sm15872673eec.24.2026.09.26.10.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:51:36 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] ipvs: Defer application parent freeing until after RCU readers
Date: Sun, 27 Sep 2026 01:51:29 +0800
Message-ID: <20260926175129.2612644-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

unregister_ip_vs_app() removes each incarnation from its protocol list and
uses call_rcu() to defer freeing it, but frees the parent application
immediately. An RCU reader that already found an incarnation can still
access the parent through inc->app in ip_vs_app_inc_get().

During FTP helper module unload, the following interleaving is possible:

  CPU 0 (RCU reader)                 CPU 1 (module unload)
  tcp_app_conn_bind()
    find inc in protocol list
                                     unregister_ip_vs_app()
                                       ip_vs_app_inc_release(inc)
                                         list_del_rcu(&inc->p_list)
                                         call_rcu(&inc->rcu_head, ...)
                                       kfree(a)
    ip_vs_app_inc_get(inc)
      try_module_get(inc->app->module)

The helper module is already going away, so try_module_get() would fail,
but evaluating its argument first reads the freed parent. The subsequent
rcu_barrier() in pernet unregistration cannot protect this earlier free.
KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_app_inc_get+0x7c/0x90
  Call Trace:
   ip_vs_app_inc_get+0x7c/0x90
   tcp_app_conn_bind+0x1bc/0x290
   ip_vs_conn_new+0x1915/0x20d0
   ip_vs_schedule+0x697/0xea0
   tcp_conn_schedule+0x489/0x820
   ip_vs_in_hook+0x7bf/0x1f40
  Allocated by task 88:
   kmemdup_noprof+0x20/0x50
   register_ip_vs_app+0x12d/0x2c0
   __ip_vs_ftp_init+0x56/0x160 [ip_vs_ftp]
  Freed by task 104:
   kfree+0x131/0x3c0
   unregister_ip_vs_app+0x2f4/0x5b0
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   __do_sys_delete_module+0x346/0x510

Use kfree_rcu() with the existing rcu_head to keep the parent alive until
these readers finish. Successful helper references already prevent normal
module unload, and incarnation RCU callbacks do not access the parent.

Fixes: 363c97d7435e ("ipvs: convert app locks")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/netfilter/ipvs/ip_vs_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 11cbdbaf561d..2c1b47702da2 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -242,7 +242,7 @@ void unregister_ip_vs_app(struct netns_ipvs *ipvs, struct ip_vs_app *app)
 		}
 
 		list_del(&a->a_list);
-		kfree(a);
+		kfree_rcu(a, rcu_head);
 
 		/* decrease the module use count */
 		ip_vs_use_count_dec();
-- 
2.43.0

