Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942427FE65;
	Fri, 28 Feb 2025 20:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773799; cv=none; b=T9shyQ39eGqiKQ88NnpLOTBH5TQwTKvwUTd2sCxP1WUYdpfkCf/iTgXd8pMOp5DGeGXSAqszdf9mRcGIBzGcaFYLeu5B43+LXwg+0Z4bfjxZfTCqDJzM50+hdBir1Db0pOUhwV19AfmXWballhfR0gAXQbCMlK+MhJNKzL7udGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773799; c=relaxed/simple;
	bh=FRvZQmo2Och7IQUxCAdMtvRd1w+tCIzOcwLzMvZg5Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF7+O9jhDrWPbULteS8iBjpwRCxYbqSaITOSevFKxCioQK4vzMffIvxYeuh+nJwpNm8a8PWlw8//wjBR3D4sPzwI4k0n50BL+vIf4XFOL3LvGJCLIHTlXMQd3WJyR1WJdKsw5aXh2y9Lt8vcPdcW73NHAoEqoBY3Ms64Sn8ghF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFXX73GE; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFXX73GE"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abbac134a19so382852666b.0;
        Fri, 28 Feb 2025 12:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773796; x=1741378596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2oeCJos5+VWLjM6O6Ww7CfUdtvRNnO3dpetsG6O99c=;
        b=CFXX73GEtDkqKkmPA9PAPLuMZMBM8CJQcx6i1xZ7gui82okgkmd1ZFk4rv8AkXMmNW
         47A6/3gWlvfzpANSXXx6qzQGpaTxF3bXMI/81uHC8dYJftiIiRoeTDRrBNPKqOdH9528
         Ibal9E4pzt7AWMGA4KEjhQ4IQ2gvgE84ujdPXoIDzpPNjLenBpxz7LrdrIVRLhb/D5IF
         qKe0VLKMpruZypdoLlNfFGHBKeWG7bdSBgJ8PZsgirjr+TOzZH7yzLXFmMTP5lXaFmOc
         bSc6inrWf9WiK0zZDXb71TqUXLNooTngEwPIUJGvIAUEW50gZc+48G2mQPKyNLk8K5Zt
         I5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773796; x=1741378596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2oeCJos5+VWLjM6O6Ww7CfUdtvRNnO3dpetsG6O99c=;
        b=s6JR3Nu5n00jIbVEFls3Rv0D+zGCleCe/3aRaC5EwBR+Yre9gxuYyu5vCTsk0UxaM/
         3EIVjx4QvleuX1PhXhKmPUd5mlmXbG6wvmAT8AjjCO581U3XZuRtyJoy/2HYPITs8BEC
         nEbJbEzZF3/wFeD5Z6ft2viPjKA1ZdD1Y356mZ4NAB6GWGkgluleGcHmvsCCSIttVWyh
         6oavf2jBLjQy05bCG0zfEFqY6DYsOFvCs871ywODZbbFeZnjsfvEvznFlV0FewloaAc4
         gM1KqiLP1OjfdlVgaHrMuNHbrhRHoBYezWW7wU2xQQlZtP+TM/Mg3wMi7XrT6m1MaWps
         suVg==
X-Forwarded-Encrypted: i=1; AJvYcCV/Le4m4G/f/XvIjGdNDl5Qq2jy+mXkOFtZ8eSMuyAybLzNOafix5iJzzXtAFrr1NXCh90oupxf4rhw6afaHmde@vger.kernel.org, AJvYcCXQpFuyB2yoabtEkJIBmmdwNN3j1OxFBNl3C31IXF3xIXsC2ddkLis0kg+rp1NP4USFKXkzdQe8Jmx4cTPx@vger.kernel.org, AJvYcCXiyPhiLxOPYPh2qThxzHSnduEhnuSuQwb2c8j+sbFyzS8VkMen6Qdb+Vsg6oDqb7/1MKfAowCGOKXZh3Ga7fk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDNEZECjq6y3JXF+0AcJVso9zSSKjqT1JV7PfKisnaKtiltKoK
	yoIIpS7jPhSw2T7OWOBlfNhB8DJxQHpN42sKv2cKLM431jC9abD2
X-Gm-Gg: ASbGncvEKiViCHZAnDyhsoiSmuhg0GjGe16QfPiyJ5z/PAH+4VPyfjqZhe1mSleYIoI
	YfY2dpVl6gS9z4GRYL3tuI5GsuK/CDf4C9fc9udx/Cf6DqJrnQrx54FSzj0IBIirsPmgBKtzAEx
	MSxATIe777H4mAPeMa70yhpkJnjdJBfdbP5vBA9mf7nzColBqrk+YL7/y3a0+mAt8YZBCY3ukUg
	ZxUkXqCGZ0HmnhgrCDE7McOgdnU7bLB0VGPhEnukHav8AoaUDTlcfhTDbTHSdO8vlqGiO2U+ChF
	CF75cs1mvci/gzHpGvLY3mWwZ7VCC6hpJIqZmrbOuPmrckojyLZrnr9PYDd3UReIQZ945rerRC7
	O4rAFllAU6qVIs7klmZTxkiT52JgGP1kaV6/m8OUM47I=
X-Google-Smtp-Source: AGHT+IGRd37BcugXvRzWetE0RiFp1sspn48cYfwa0XVMvCj+hDeBReablJgdaX0T/5erZICf63Pa2A==
X-Received: by 2002:a17:907:7f91:b0:ab7:c358:2fec with SMTP id a640c23a62f3a-abf25da05d8mr559746666b.5.1740773795955;
        Fri, 28 Feb 2025 12:16:35 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:35 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
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
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v8 net-next 14/15] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Fri, 28 Feb 2025 21:15:32 +0100
Message-ID: <20250228201533.23836-15-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces DEV_PATH_BR_VLAN_KEEP_HW. It is needed in the
bridge fastpath for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.

It is similar to DEV_PATH_BR_VLAN_TAG, with the correcponding bit in
ingress_vlans set.

In the forward fastpath it is not needed.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2ee53478d9f0..17d82e4632dd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,6 +887,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c7646afc8b96..112fd8556217 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -430,6 +430,10 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
+		if (!src)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+		break;
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index aea94d401a30..114d47d5f90f 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1494,13 +1494,17 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 	if (!(v->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return 0;
 
-	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
-	else
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
-
+	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG) {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	} else {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
+	}
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c95fad495460..c0c310c569cd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -148,6 +148,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
+			case DEV_PATH_BR_VLAN_KEEP_HW:
+				info->ingress_vlans |= BIT(info->num_encaps);
+				fallthrough;
 			case DEV_PATH_BR_VLAN_TAG:
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-- 
2.47.1

