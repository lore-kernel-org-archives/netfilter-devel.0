Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B472381AA;
	Tue,  7 Jan 2025 12:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253386; cv=none; b=YVj0X64U9AxMUjEFBdvx+0HllY5lngzbZMUPPYMH2edfYInnUtZAkO48d2LSMDFUvIbUU2L+1MmTFKdFgZ39YsVsSSKlLdEMLcmEmMgYOUrcMV8LvaTaD8PB4Xt1CwyggmGboPFiVkTfnqMHsQjxU+qRwJWJQ49gZUIGiOo2zyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253386; c=relaxed/simple;
	bh=OHF/A52nffmMZ2Ft4EZ+KA9ujcfz203olhxdXb7tGi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=asM8O4BQe74GgtszNdyJ1d7TcQ7BL/gO2AIq7gKJBsgiFsX1tZGmmfPhsajMhPkVbjFN2jBD8C4QIio6/lelCk7aiFZG6ubtSfAzxu25l7DSqYZXiE6f3QiQ8oWI32S+vbMK3CR2el7S5PL9ZBcQa4RMJLg8sRvnixTv0LMI8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j5Njq55V; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5Njq55V"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso30723568a12.0;
        Tue, 07 Jan 2025 04:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736253383; x=1736858183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1iRQLDB7T+T6mcX0QSHuvP8QOBEcY1WYeSSWjcXJNfA=;
        b=j5Njq55VCfs7V5FzumPtzKG8Eqxta5LGLMUFO9xx3LZwmImAi/mp7gdcvnRUtTFWpB
         CdGEmWXWfO8KnDOya38lq/r98ItHsdQUg4C2DGYslyLr5ygAxb53/dbcuYtJByq8iWTn
         BgIe7aNE9oAN0YWKzEPNwfG+uyreqY0aoZ0GfENv2EtsAmuBPYJiL03CW4lPpAb1/Jh6
         m5aFl1shDfFO8Y3G/DQqf3uZwEgXHib5tRlZb1KV5aBNxlO9n0hHi5guvJxOubC+nZWF
         R/94begAL6uObNI2TZ/sJ5A1IYOiNehAxvMTtky6P/ZctmyhYAYjwVKJuAlJDz4mEIa8
         yGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736253383; x=1736858183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iRQLDB7T+T6mcX0QSHuvP8QOBEcY1WYeSSWjcXJNfA=;
        b=NKL0ZeV4peOumok77g46th/dsMhGUBhwTik7QOflcwxvREtUnmzAAXeGTPxetqeTKu
         EZTe566BNBQWq7yCIpEf2rA2lAEh8FArqDiVFrdmmrSUVZ5atSpVxOlnUxBW1AcJTDPd
         YOOFQVnP7cFuI2QYDESpGU38ysL6xOVr6u6SKi7q53wZqIj1NwGNOIq7aW79GqWbCFOF
         XDkXEej1y+odYo6Y4Gbg+1HHKVO/xTDQJAEStJGvMDcdfSC4UHmJ8c9c8cyslkiSQHWZ
         XMdGg04T/sfl0jlejai13S6o2yZebFwyOxXCAojDDcCDAUY6hZVq4CFQnrI7tyldEP3G
         5C/w==
X-Forwarded-Encrypted: i=1; AJvYcCVCfHAldlXWn1gLi34+NDGNFi7o5jHyctjSPjli7b2MNBX+DCJsxXj/TLX2jMeqHOA1BBOqXR2W+oImDXMM263j@vger.kernel.org, AJvYcCXZ6tQK4HvQ8VLvkbLIKIzUoBx+WJu84mnido+xkiA5CwC2PH3ra3XcOs6cyDSocPMG3yHJ57anXQeLvU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAr2Fy4EAvIpX8CmbyAnFGYycvU71lca42dQn8hGazBIL6s/hn
	ULlMNoIlkpqgQHwHB7Omtmf9vEMkNkhCpXIm50CpQzi/0CObdhIq
X-Gm-Gg: ASbGncu0sGR+FYS1UNaWUAR+YuK0IcBbT4f30UbX7T547Lckb4BOs3hgC0oeewoGRTg
	rCnsGqt+epymeW6tO4pNwr8cIVxAd7CyDdX+FtYH0X6p/Dr8OfVDGCnR+CCYiic5Si+1N0i0y4o
	rEc730zzcv1tpcJ8wdFL6Ukx/ZAdguRh7nIlGWMU1Lp239+5sCrNTPEAwSoXIa6QfO7d+/eMhIt
	JxxrXe3lDgt9wZOfHBq7x0ioUJ3QkApu245Xak/G6lV6rXorrKRW48eoP0LS1Q8pMd2neqOkPVT
	kdBzJz6mXLt7ee1EuWLMaM4jZyWOgUDdUc/+a0Az+iFPxRPOJLxolzvpc6eIKkHmNjpD5foZtA=
	=
X-Google-Smtp-Source: AGHT+IGW23CFpUMXDq22TqAb+Ssg5WtHBDf4GPbKhJxZxOpLIHvlqjNy2qcYwN7W5pI330PsYIomtw==
X-Received: by 2002:a05:6402:2802:b0:5d2:723c:a568 with SMTP id 4fb4d7f45d1cf-5d81ddf3ba0mr62395981a12.10.1736253382371;
        Tue, 07 Jan 2025 04:36:22 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80678c8dbsm24148450a12.40.2025.01.07.04.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 04:36:22 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Russell King <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next] net: phylink: always config mac for (delayed) phy
Date: Tue,  7 Jan 2025 13:36:15 +0100
Message-ID: <20250107123615.161095-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The situation: mtk lynxi pcs (eth1 on BananaPi R3) with a rollball
rtl8221b sfp.

When setting eth1 link up, the phy is not immediately attached. It takes
a few seconds, pl->phydev is not set yet.

So when setting link eth1 up:

phylink_mac_config: mode=inband/2500base-x/none adv=00,00000000,00008000,
0000e240 pause=04

When the phy is attached the link an mode does not change and
phylink_mac_initial_config() is not called. No message 'Link is Up' found
in the kernel log.

We need:

phylink_mac_config: mode=phy/2500base-x/none adv=00,00000000,00008000,
000060ef pause=04

Perhaps forcing phylink_mac_initial_config() always for a phy is not the
desired approach, so I send this patch as RFC to see which approach
will be most suitable.

Log before this patch is applied:
[root@bpir3 ~]# dmesg | grep eth1
[    2.515179] mtk_soc_eth 15100000.ethernet eth1: mediatek frame engine at 0xffff800082380000, irq 123
[   38.271431] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
[   38.279828] mtk_soc_eth 15100000.ethernet eth1: major config, requested inband/2500base-x
[   38.288009] mtk_soc_eth 15100000.ethernet eth1: interface 2500base-x inband modes: pcs=01 phy=00
[   38.296800] mtk_soc_eth 15100000.ethernet eth1: major config, active inband/inband,an-disabled/2500base-x
[   38.306362] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/none adv=00,00000000,00008000,0000e240 pause=04
[   39.220149] mtk_soc_eth 15100000.ethernet eth1:  interface 2 (mii) rate match none supports 0-3,6-7,13-14
[   39.229758] mtk_soc_eth 15100000.ethernet eth1:  interface 3 (gmii) rate match none supports 0-3,5-7,13-14
[   39.239420] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
[   39.249173] mtk_soc_eth 15100000.ethernet eth1:  interface 22 (1000base-x) rate match none supports 5-7,13-14
[   39.259080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
[   39.594676] mtk_soc_eth 15100000.ethernet eth1: PHY i2c:sfp-1:11 uses interfaces 4,23, validating 4,23
[   39.603992] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
[   39.650080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
[   39.660266] mtk_soc_eth 15100000.ethernet eth1: PHY [i2c:sfp-1:11] driver [RTL8221B-VB-CG 2.5Gbps PHY (C45)] (irq=POLL)
[   39.671037] mtk_soc_eth 15100000.ethernet eth1: phy: 2500base-x setting supported 00,00000000,00008000,000060ef advertising 00,00000000,00008000,000060ef
[   39.684761] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00008000,000060ef
[   40.380076] mtk_soc_eth 15100000.ethernet eth1: phy link down 2500base-x/Unknown/Unknown/none/off
[   40.397090] brlan: port 5(eth1) entered blocking state
[   40.402223] brlan: port 5(eth1) entered disabled state
[   40.407437] mtk_soc_eth 15100000.ethernet eth1: entered allmulticast mode
[   40.414400] mtk_soc_eth 15100000.ethernet eth1: entered promiscuous mode
[   44.500077] mtk_soc_eth 15100000.ethernet eth1: phy link up 2500base-x/2.5Gbps/Full/none/off
[   44.508528] mtk_soc_eth 15100000.ethernet eth1: No phy led trigger registered for speed(2500)

Log after this patch is applied:
[root@bpir3 ~]# dmesg | grep eth1
[    2.515149] mtk_soc_eth 15100000.ethernet eth1: mediatek frame engine at 0xffff800082400000, irq 123
[   38.989414] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
[   38.997838] mtk_soc_eth 15100000.ethernet eth1: major config, requested inband/2500base-x
[   39.006029] mtk_soc_eth 15100000.ethernet eth1: interface 2500base-x inband modes: pcs=01 phy=00
[   39.014818] mtk_soc_eth 15100000.ethernet eth1: major config, active inband/inband,an-disabled/2500base-x
[   39.024368] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/none adv=00,00000000,00008000,0000e240 pause=04
[   39.960119] mtk_soc_eth 15100000.ethernet eth1:  interface 2 (mii) rate match none supports 0-3,6-7,13-14
[   39.969738] mtk_soc_eth 15100000.ethernet eth1:  interface 3 (gmii) rate match none supports 0-3,5-7,13-14
[   39.979409] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
[   39.989153] mtk_soc_eth 15100000.ethernet eth1:  interface 22 (1000base-x) rate match none supports 5-7,13-14
[   39.999063] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
[   40.334663] mtk_soc_eth 15100000.ethernet eth1: PHY i2c:sfp-1:11 uses interfaces 4,23, validating 4,23
[   40.343980] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
[   40.390049] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
[   40.400234] mtk_soc_eth 15100000.ethernet eth1: PHY [i2c:sfp-1:11] driver [RTL8221B-VB-CG 2.5Gbps PHY (C45)] (irq=POLL)
[   40.411005] mtk_soc_eth 15100000.ethernet eth1: phy: 2500base-x setting supported 00,00000000,00008000,000060ef advertising 00,00000000,00008000,000060ef
[   40.424730] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00008000,000060ef
[   40.436368] mtk_soc_eth 15100000.ethernet eth1: major config, requested inband/2500base-x
[   40.444539] mtk_soc_eth 15100000.ethernet eth1: interface 2500base-x inband modes: pcs=01 phy=00
[   40.453307] mtk_soc_eth 15100000.ethernet eth1: major config, active phy/outband/2500base-x
[   40.461653] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=phy/2500base-x/none adv=00,00000000,00008000,000060ef pause=04
[   41.170029] mtk_soc_eth 15100000.ethernet eth1: phy link down 2500base-x/Unknown/Unknown/none/off
[   41.187047] brlan: port 5(eth1) entered blocking state
[   41.192213] brlan: port 5(eth1) entered disabled state
[   41.197404] mtk_soc_eth 15100000.ethernet eth1: entered allmulticast mode
[   41.204358] mtk_soc_eth 15100000.ethernet eth1: entered promiscuous mode
[   46.600038] mtk_soc_eth 15100000.ethernet eth1: phy link up 2500base-x/2.5Gbps/Full/none/off
[   46.600057] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control off
[   46.616926] mtk_soc_eth 15100000.ethernet eth1: No phy led trigger registered for speed(2500)
[   46.634003] brlan: port 5(eth1) entered blocking state
[   46.639155] brlan: port 5(eth1) entered forwarding state

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/phy/phylink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6d50c2fdb190..6fd66ba9002a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3424,6 +3424,9 @@ static void phylink_sfp_set_config(struct phylink *pl,
 			     phy_modes(state->interface));
 	}
 
+	if (pl->phydev)
+		changed = true;
+
 	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
 				 &pl->phylink_disable_state))
 		phylink_mac_initial_config(pl, false);
-- 
2.47.1

