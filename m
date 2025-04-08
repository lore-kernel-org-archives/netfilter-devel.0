Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F622B8DB;
	Tue,  8 Apr 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122505; cv=none; b=p4Ih5tbDXVzethw1EewMSwvDKrRNOXDgjbJC4ub3Rgr9Wy+LGCo9YUZ9T1tPbM7nwQ2Ab8aRX1A9DXsTBcKEDjOBAWXyqNgamBrZoUqZBiSFcC/nELuhLIiufup6/naSruFdaAUa6z9Y7O1wNFF8VdGUjAhDhXr1oxks6jEODkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122505; c=relaxed/simple;
	bh=23EVXG7kfqfWj5zpc9iYyPrQjwTk0DrW8lEhtvwVJ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQZhGeI58bzfTBBFAB4No4qE0CryrdLkfxx/oTbkeVGbTwSuFZLlkLY8vbitWY2mAcdlwP8IZLX30NyKHuEeLE8xvyVHn76XSy64Je8RzpmXwpKtpKlY5xY1Um6TqW0WTjam4yhAFKd9Htd4PNoVTVCJG98xK2qju16/+Xc0HQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cT/Ls0Qs; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cT/Ls0Qs"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e6c18e2c7dso11132502a12.3;
        Tue, 08 Apr 2025 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122502; x=1744727302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3OIEodSl6lDw6tf2ZiYVl8tYf0/bPtkzTz2bpfAeGs=;
        b=cT/Ls0QspDYo5hd2/WPXkymexOI37vyxTP6N4J7pLBNd7VSz+79/Rel6N1ZzOx0awd
         DcrDqOQXyK6OWJgHCnIiMxLe87XlQSARihi2GjkiWwO/YM0xaTPy4fGd0Dp/fDjxCvkH
         MJSkf4Joc6pvAT2kH/2nekCzbrU+7EmC9NEJYRIejg9FYgMMUT+3wo5G6pfJPeixkwS6
         QpjvunSkh62wnVtyirtpVLqIR/MGC6HT8VdE3lJyly3IboNGz/spRfvH6yEyxI2SWzLZ
         A9kNUTQ1RLD78gc2tudOmUUGI7AwJT5O0QTEFkSP/iH/Z+w2tV1CpJIAS98Tf3qIteIl
         iU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122502; x=1744727302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3OIEodSl6lDw6tf2ZiYVl8tYf0/bPtkzTz2bpfAeGs=;
        b=XPS8MtqJixKfy23KlVPAYwO3zVTjuT2Qs1KRALiW8s7oGfHP0ppc+CqQn68WZiiarE
         MOis+pXIHmJrXO+xHufjWlinyz1WAl9etSx9xj+jge4LtDggf6tUd/hvHamYXHJ91gE9
         8kH5U0MfoluSmp4obetL5IF3t80eVPiMDLPHyt0rhm27rhbjoa8im9A7ESuVyxvEwvWg
         mDSO9awUIyX9U8XMX/tPGBl1Wl3NGI9q1O/7R3Rr5M7vfY+5d4Xt3znTviJbYoiMoTe9
         rGqfCDgQrV/OXB1ZdHpbIWfn0qwlqlCHvCtPhMsf00S+iADQGurRYWeRZC47HDDxxSlz
         Ct+w==
X-Forwarded-Encrypted: i=1; AJvYcCXVIpqWNv5vqd7PZcTpcLLV+T4TsmPaxIyo3IvgWF0+Apn9i23z1KkyLj+6nS59T16SuLrXFO69SGVRe8jg2ew=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwG1c1VM/lNUFaq6h4xYBhQQy6c56XkFlbWEwaeIN22ZBbt5Iw
	UVR3G2hW39iichqUdOlNi4o2Y8pJ0QdZhwbKrezXL0dSL2xayyiV
X-Gm-Gg: ASbGncshDSzkAal3x1QZmDQHCsfmLlUC6LNxOyk3/b68O0iZqjJI2yAPYM+eiND62VJ
	Ru7e1m1tOHkp0+6GTl4PcwCSNy/3uiI2V6pif4qiGtLIf+rL8AxAO235RVofzHQDObAZNt/r5zR
	PVCnpUxILlAbROy9fM0islznzSRA6NJgMsoldAwn4ht9lg4kEcDXAl1/cGBKnbMWMMHxxP3uOyp
	ZmDscJ6FtVtVFum9SAkw6d72wl+wt/LNK11AdDKBHHDxbGGBazjG1WnwJMlrmnjkeTIHhdkUit3
	9Kt32+u6ZEeGbtWxnvmUL8TlLizp2ybI6wpRwrMQLImssli5msteIfDPFb5CHsrmrntfcqyBCzg
	ZF8arVkKKw4xcru4yIJIaLxyKjLQiBqqv4jIoH1kcRfcrFFqoRQcD984QvQpto5N77zQAYSAojA
	==
X-Google-Smtp-Source: AGHT+IFtUh86dw5P1rvEOKZJFOy3wFYBIYbNLQmENevkMKk9v92p3r9P4/WPi1ZmD1fshbslhyGHlw==
X-Received: by 2002:a05:6402:278d:b0:5ed:76b0:a688 with SMTP id 4fb4d7f45d1cf-5f0db8a2343mr10499321a12.21.1744122502160;
        Tue, 08 Apr 2025 07:28:22 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2236164a12.35.2025.04.08.07.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:28:21 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 3/6] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue,  8 Apr 2025 16:27:59 +0200
Message-ID: <20250408142802.96101-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142802.96101-1-ericwouds@gmail.com>
References: <20250408142802.96101-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 9d9363e91587..f60ecedf2fa7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -344,6 +344,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule);
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..5543ce03a196 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,6 +679,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule)
+{
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
+		return -1;
+
+	flow_offload_redirect(net, flow, dir, flow_rule);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
+
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
-- 
2.47.1

