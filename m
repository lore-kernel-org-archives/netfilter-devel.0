Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171741C1AB6;
	Sun,  9 Feb 2025 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099464; cv=none; b=IIwie14tWVrA8S3+XegIzROAu7e2xET4T3XmpUa+5OkCHfIvXwqxl0zP6naJukMUi4OAFJv9dp5CVK1URHHlo0kWhK0K4um5lc0nZ6zGDbXB35g2IFlKK83somgdfztHAPtXn+I27EgahF+4NxMWBDK+dqokyCMC1xYVI0rP86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099464; c=relaxed/simple;
	bh=Xf5mlATXYp8EYoXU9a3w+XGI157o2p4WZAmB5ikh7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0rrf87lfybMUR1m7OF04N5DIjmDZzuALnFYw+5sRjNtcisHTFvPu5JVwjIskRrjU1tNRB3gGnBVctnz+0rZ1L/KKizS2pIJKBN0f1UvlbmIP6id/wdjIaM8MFaXDzDjw12G+a6BM/LPQFg/nDC3WgUm+e5j9bHg0kI1+W/7xsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tpt+wjsv; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tpt+wjsv"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab7157cf352so885998566b.0;
        Sun, 09 Feb 2025 03:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099459; x=1739704259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=Tpt+wjsvZPQZseFgPpKAWw/mxdBW/GP3dfXnX/u35gNgRovRLnqnJVwrQYxM8YglJI
         avdiw8miVaYGM61YHn/R0pzxtnSYdRwET2DaiakoHep4moxWFWLsRBeti4WefNgxL/eq
         wYlh2Q4ttR/jmBS5fTUtjWiBslH3Szi482kyKqWEg3r6fDZ/9yJ2y8f6VQBE98Mxyov9
         0quQC8xmeFXJNAEen6rB8tw9lxD81mzcqBKTFqcvkkJA5YxAW0w/bo0B6rfq+LWQRic1
         2B1kh/cSFBPU8nlW4IjPLs/9iem9a6EcRoxzCFmXRFGyCZcqAs6wy3SVkcdllM66xEdP
         mM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099459; x=1739704259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=Pp7IkpvJJgFfqmdXlI/nZPRjjVrXTVgvr7Dr8lG+OdFWGlo5W/3yHGhIOE9Maii0UO
         9bYuyHyGzJEKZPx1DD+GpfT8AkiAQ9XR17F0qh4e7ZWq7tIKVNZUCeRkDCSus+HkBwos
         LfLGABSs3ypHvXtZOHcFWPfTxpkSRxf6xvJIaa2c7hnBnkC2zuAUeiCOz0yn8CtYe0EM
         IbHOr8XQAfLfTt1gk31t6g3eyfiiGCc5XLMkTUPhQuXdq42lqrNghOufxKdGT5kFaAg1
         X5QZz4o29KQZM8AOTyAvL15F+10TzMsKaIr94RGsmG1az+wWavpb0qTZdhn/2ZE/TCKZ
         Jvwg==
X-Forwarded-Encrypted: i=1; AJvYcCUKdIDCRwZ5k75LA6J7cXnmQKHcOcY7W4hFp9L+2DRJ+wBc3E20p0BI//4e1qZk0WXq6OLVfl4zv6sKWtcjITUu@vger.kernel.org, AJvYcCW6SDX3V16yP7cegQDdS/LnR11sNHMW1/kg4XE8gRwTPpuNkuv6ygR/bNxdRIwkVJFItyrJQr1k6OBcEAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyObD9EZw/r0mXlqJB8Dub+x3lrWf9wjkWpAt3fbIyGZu2UQ9VS
	QSg6j2I/Rn/hO/xDwNN0vm2k9Q+u3eZPmC+SOF/b5AP+HQ4SZ60I
X-Gm-Gg: ASbGncse87ZmbHXvo0mh46wFaw61gc+8TKB8080ZDNaYxYte2Pry+qQTUIUaCH6ZqQH
	oI0GTIZnofA4ceNNBEBOhR6YdICto/F516FpnaFyor/QZyMfBZaNSCYf4G0hsIqe3Q0rtqx/oYk
	XuUGHiAWgt9HEv1AEuGZaNJZ7lXJsWvGANSn1QIKvUj4U0skM66wr3Qd4OOY8imwgmZF52gV5Zs
	PocIxhGo7sQspBU4D4QJOnpdMwplWr5xew6lRXGOemabT1ENkLrIAusKmpa2RXWwOQP6ky4GdrQ
	NEQPoKTY8CRbCDzAflUbnle7dtbdoxIDIF059XAWUHz1oIRazBcUDqKPH2xbcLD6TmoZjAjcizj
	U1cYxXXdoSFjE/H1uHraLgBC+8YAs6VIZ
X-Google-Smtp-Source: AGHT+IFJaFbx7ete5KJozyvNC8/oWulX5RI94rWh7h2VsoTHF0Lp2lI///kU0TTT1M4WqEm7capUsA==
X-Received: by 2002:a17:907:9719:b0:ab2:f255:59f5 with SMTP id a640c23a62f3a-ab789b4a40dmr1114278166b.16.1739099459229;
        Sun, 09 Feb 2025 03:10:59 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:58 -0800 (PST)
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
Subject: [PATCH v6 net-next 10/14] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Sun,  9 Feb 2025 12:10:30 +0100
Message-ID: <20250209111034.241571-11-ericwouds@gmail.com>
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

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 323c531c7046..b9e6d9e6df66 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -105,6 +105,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -117,6 +118,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.47.1

