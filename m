Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD611C4A20;
	Sun,  9 Feb 2025 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099465; cv=none; b=dqMJIsDkA0fRUSoyW6rGUCfk6bYCdXawCf6RaDvTvINlUPh2jxTVH+O1+RLPxgJ9N5pcpUJE2Fw2Z5SyKXc7enNPJJL0Ft5dvXVdv+88qXTqho41DW6nOJbUDrAe/xNR86Iwo9/sy20D5BdF63jnbMZaojek6dtkFd8NKuo5mqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099465; c=relaxed/simple;
	bh=eot2qzjFYblE5xeGOIs0eZ0Yx1RMdl3bwN0jHhnk9xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgS6eFtFxCqUFl1R3agR7OGvIJ2M9LsW42hMNk4tZ5Qt297HIDbE4gzbKmLuZcy4kWX6wtDImG5KtTAFQf+zccF9WNq6DSeQwu9v4wKOF16OgH2R7l/dqIOLv9ZYauMuqcPYlsYAoW81822TNF7B8OWzAn6tdhz1AWnQDqXE49g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gAYzIKIB; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAYzIKIB"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab7c14b880dso303866b.1;
        Sun, 09 Feb 2025 03:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099462; x=1739704262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x342s989e3SqEpDprSMMdkIM/WvPO0edPGoockwe0Ec=;
        b=gAYzIKIBQj5NfeIIS5cS1Vj+8PZSWQstYg3Yi1Y5WOudOmO+nODICJMK0zID/s/uTk
         cmppT+usqansBT3NWoJrE/IPdTBP9ow4ZA7oZjD0ru2yTs7LhtXW9ZUL6tS8qjQcCMQA
         wXojlKdbu9Rjg+DtWseCu+DxG059qCu5MtFAm8hIoGk7cvubSUaE1ndOdXnuS25NF7XS
         K9dnq1QnSndsngU7t7VV3IaYFh3HE42ben4fUjB2OKm6wa0Oh0+nYE+NCcuG16rTcyDO
         bt6TEudqTxbmoM/LQcN/kPOtjVQ8vQEHQ5KuB66yqAqqtYKo4ByZ/UWYwF+SvAQBoR+S
         xmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099462; x=1739704262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x342s989e3SqEpDprSMMdkIM/WvPO0edPGoockwe0Ec=;
        b=k5xXamO2TX8I/BTKy/Z5HTV4rxleNoQ0NuB+6nMhAMRtlrpWVbBZNVr729T5PdNP4G
         tKoNFUpJSXWmG9HORXlyD33sBXWEClNo0aj254MpVDyF/uhe31dRoxJHNH9oE7uoNDf8
         0vhptFn2MBfCQ3hXA1S8IF3cLamUmCZq9hBJQtkvPQ/y4WHOAJ7EnQu6mrzCSvixUSkf
         F3vUpeSZPca/ZwKi9T7SFXAGY1nDv3QQNEySPT+d+kaCXIahdz6ej2Cw7O2Qti87WOkU
         6qnxd2VHEZygOAzj5RyzCGDiCTZMwty0ly0M28KpA5xGW9+EYLjww485Ov2fFTNvCL89
         dsRA==
X-Forwarded-Encrypted: i=1; AJvYcCUyaMtl1HiRWU3RLxeJ3zoDSbWjLBoTZNVc85GTeCK9njtweZlbV7gguupNBkZLnuN5tUmDUX9OaHENuKY=@vger.kernel.org, AJvYcCVFZflMDZC3uG4F27NDSHStrwWx0AnrTOPzeZrp/UP2wCoRArzLdfkofCMjxVv7mmKGXxmBqZ00vYC+JG1rncQu@vger.kernel.org
X-Gm-Message-State: AOJu0YxONs9+xvCiTsjLoYSe2HSvTtiCMK1Uu4MxVCNvNlTG4Mxuv/ij
	5a3g2knS3Y5I+5B99O2NTUqmPtrurgobe9PyRkkqkZGszq9EWl4a
X-Gm-Gg: ASbGncvvitLuqNqkpJkVnvAss/offN25srotRJYyN3x6eKwu2qSzixYiUuPpM5ZH2qd
	qOgHQozSsHE2EgdgFBtyu59LoRMZYHVJ+xGDL4ZbUghsjny4lZiJOHZzg5PON0NGLJEIeujJ3rI
	Wideua1Aiv0vgkg3can7LtbAn2i9r6h9VvwfdG+nxLSuJsEFu08jwXLvjN/1wOZj6UVU+M0sd6g
	KOUdKVrY32YYYDW9g2bMk2L3fW1YQaeYVuf+IZCQ5eu2Ywybp7YQARbJitxWKgB8SY4WlKkCFHE
	7gWt8Ol9yhysSvc/fTWXLzIlQpBczYRg298xjpHyC+E7L1aBUlm21R5drg1x7rBjhJf6YUtfXGS
	hwN6engEaEim78+qXEhAp1FXQRYWLVxIj
X-Google-Smtp-Source: AGHT+IGzFOqbzdxNGu8XFTKkecQMR7PLLsHBIzTQkjtLs9gLGZn/h4ghB6cukLwFR4KP5Q7Rs/NF3g==
X-Received: by 2002:a17:907:c283:b0:aa6:66eb:9c06 with SMTP id a640c23a62f3a-ab789a9be1fmr1119975466b.5.1739099461657;
        Sun, 09 Feb 2025 03:11:01 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:11:00 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v6 net-next 11/14] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Sun,  9 Feb 2025 12:10:31 +0100
Message-ID: <20250209111034.241571-12-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bitfield info->ingress_vlans and correcponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b9e6d9e6df66..c95fad495460 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -116,6 +116,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			if (path->type == DEV_PATH_DSA) {
 				i = stack->num_paths;
+				if (!info->num_encaps ||
+				    !(info->ingress_vlans & BIT(info->num_encaps - 1)))
+					break;
+				info->num_encaps--;
+				info->ingress_vlans &= ~BIT(info->num_encaps - 1);
 				break;
 			}
 			if (path->type == DEV_PATH_MTK_WDMA) {
-- 
2.47.1

