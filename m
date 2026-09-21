Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ED54AA1CE
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002640; cv=none; b=uuIV9VvnRDslxEWfUttsRA75ay2Oit69eyWXKZ/bM4vH4wJsGPfgRDfp1n75Q4rOQ1ig0Gbmezt7ZLvHERxemBbr7JDJGolNUwMoVdV47Ju/Csbap9ElT9PWn+TBJapEH0B2WvSODkEu+j+sZtv6++NtsjDEZrB4B0Fr/aGXqS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002640; c=relaxed/simple;
	bh=bOu2j+h1JsGrW/73PwD/ne4SKy+cAAoi4+vaYnS3JPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pqp4mvCDS3c4EES7UOZ6b0kBso9ablXp0lv/tsZ4KMIODN/69N9ejTB8Jrveg4S3KJrO+JoCL4LuFUt/qoG9cLCjUcpgTkg4Ebm6z89t3zbS2QPO4HAFR8UuUbGg6mUnnsJrsjRV2weaaJeFWbSDo/yFfVEYcEeXpdDCLDdnKlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49e8361492fso12426475e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 07:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790002631; x=1790607431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ezyNqdfklEHB2imnyaqpGNvPz3WXjxpC3pksDJMQYU=;
        b=nGtQp3rIoFoqqeqBDUEmZEU8CM8mT7Kl2Ezxut4UtX0g3zxmZm3nX/LtDG8iBU9Q3e
         a8Qh33SnKjiof0tUK7abwpCag+uh0AQI6WA9CBRey4uuenyTw+gtWhLNYwT9WRZEbd/N
         7Q8qJq0+pTJRVx4Dwy8TsoZUETXHCSikFrBa6E0YJYPIMWbepWlpwx5cbZ0pJZgtVayP
         GnxVt9LMpJsjs9rq2OhQrc+oD5VgTidQYNka8MqR1d6e7rOZxVAzxyStEfp0Rdp3OfEv
         AmqK0VJQ6Ub4V3JPdyMSbaes+nFufNe7fzyeAy/bjFUfuTI92U6U0CdC50Kr8QbCcWOo
         Jw8g==
X-Forwarded-Encrypted: i=1; AKwUvBy88IdwmdPT1pdEBWV5zd2aw+DAiOG88BIovHTRVpDcfNVJgyFsXrvBKoW66qUk3nlO4lnIdomz2m5pvJyWOig=@vger.kernel.org
X-Gm-Message-State: AFuF++lczl422wKOsm2FVjSaCV1DRNt2YdZtegumZmKbm97z+a+94TQk
	eNYbDDgWE/CKaO0y0nNw9nNxcAQsupGOpejqOpo4/51b/a/IE+Y+8XzC
X-Gm-Gg: AYBFou1Xtjd3jj5SXBhWTflm80UqRG4i7nDLdwb01O60Pam2yu9SEkfIjoYCXotwImm
	0vciPrC4SnZbXS/DsQGwNiV2Tew7m879Vig704PMokF5tUHPlJQ7YGqi06RqphIMXX7MfcnZYVs
	DdsIf7SQs/L85L7O3VB4wxfweKJ0JcRqX4ngxPbW/VBAVhbGg6PI6YW5wI2qXzWRzqm9XGxvJwJ
	CFsKvmrbq3dKR4bL9lLD7YAPjck33tO3r2BZt9IIvt+GWuRy1AT/flSJ/bpWnBmlFYD2/YqVzWn
	xOrsBCLrCoO6jEWIHlYRKEJE4LuqFhRd1mGM2JeYh1is4ZVXyj71cuABKJHrv97h11xgtxKKjc0
	RC+tXJzJkHUI6/IQHyZnzVDT2LM6otTlbA/9XAV7evBrIfGdbfYjZAESMhaOFWv2RduVYsSO3cy
	b5dzhQZHlVDSZOtllTjb50G/xpgPICeDeCTQn7F/EvHoBgoAZ8sZCB4JGAIU8pBGYZU0JNdWqi6
	WlhWrCfm6tmBqk1d28UPH3ev1DudKBaM3uICr2WnarRhG6Ox6Be
X-Received: by 2002:a05:600c:3493:b0:49f:bd3c:bc21 with SMTP id 5b1f17b1804b1-49fc573b55emr150845005e9.28.1790002630316;
        Mon, 21 Sep 2026 07:57:10 -0700 (PDT)
Received: from im-t490s.redhat.corp (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd0eabfcsm243153905e9.3.2026.09.21.07.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:57:09 -0700 (PDT)
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
	Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net 0/6] ovs, net/sched: fixes for UAF after conntrack extension realloc
Date: Mon, 21 Sep 2026 16:55:42 +0200
Message-ID: <20260921145655.3167436-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One clean up change plus two fixes for the UAF on helper extension
realloc x 2.  First half for OVS and the second half for the similar
code in act_ct.  This should cover all the known cases of this problem
in these two modules.


Ilya Maximets (6):
  net: openvswitch: conntrack: avoid modifying shared unconfirmed ct
    entry
  net: openvswitch: conntrack: remove 'add_helper' dead code
  net: openvswitch: conntrack: fix helper UAF due to extensions realloc
  net/sched: act_ct: avoid modifying shared unconfirmed ct entry
  net/sched: act_ct: remove 'add_helper' dead code
  net/sched: act_ct: fix helper UAF due to extensions realloc

 include/net/netfilter/nf_conntrack.h |  5 ++++
 net/openvswitch/conntrack.c          | 37 +++++++++++++++++++-------
 net/sched/act_ct.c                   | 39 +++++++++++++++++++++-------
 3 files changed, 61 insertions(+), 20 deletions(-)

-- 
2.55.0

