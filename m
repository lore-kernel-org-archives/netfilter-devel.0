Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795639835;
	b=VoJIjP56LtwVgFlTE+xgHUUGojQvzbnAy4y7KDyVjXikTTrzGYgsb1baGtydMss/r8UM
	 6Fa97z+SAkzS05ZGvrGDx+IejccwHsh53MuFedE+9bdfjxAsQbJ/Kyo4nJc0wsN+/tO5r
	 eGbe7SSyIY2j5ztxcUuzTW8d6q3/B/MarbfiIxxLiZACpcYyIH/odpzNTPPcFK5shjs2q
	 FOlCL3g0YmmH+E8xGlIwF/j+TPVzL0/RyzBK0fbSqvIXdPOrpQgw6prKgAF9oLoFfYutw
	 Atof0RICHm0K2t8HZDEqNAM1GlVZk8gxL3vORRybK2HxBJ12QStp+552NJtN/KccP4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795639835;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jtR2BCwBiiOXE/nYUDE0bn3/rGtsWTBfFTX/QPsmJxQ=;
	b=D0e7kM+Z7J8bQNS92iH8uJJdehnL+labBhKqO0iZky2WbKcmaRJOy2f+PTczmZVT9ksL
	 k5cC0K7jH9Ex0vm9TehZm7uoelE42uhhPai7LZCVpWrgOEObhs3Zz1EZJPv29QTsLp3VL
	 dL2Te6yPVSd4/k4xoGv9et+o+jvNUP0pGdnRBmMZchhB8uQHNUOSFcbDS/lgsZTcbOUaV
	 Npk3fhv0E9qxXHC9fzcMU7ocLOjYp6UC94UkMRqPBVPP2sS85yn9n11rB4RiqX5ygVmbm
	 5um6jiZH7nzSzhzNXhtIy9+WDisttBhRVePkz0+hqSOYgFOIVPTj7I3RP7Wlcdu2pBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oOlGNqW/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D1D606A321;
	Wed, 25 Nov 2026 20:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOlGNqW/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795639835;
	b=DWXa2kU026xFwUE/9vAnx6RGsV98Jr+ehrLO30WViEQuzfEep44gb4qEw8U3e1MOU5ut
	 l7vp0pGSDrsmH3+oJ3EzK4AP6Xp0UlqGkXZngg152x2kXsiBhRoAyHLZ4forzRC5pRA+F
	 Gidvo9nOXJ2cY/JRMf+BRy01cOf2VmKqFyE5ZIR0H0LNaH1Wz97JVCrTOcWTMXeWPm5Sg
	 zkyrhTVluD/iLyepbRLPDbjd3znOWh2wihI9+L+fDDnZzI9IV0O+qrRIghT98Ou6PA4tL
	 8+zODFwQ2vs+hmWNefTBD6lmb3Ogf/3a2u2SW4ercLqq0RASg+zP/2mrj82edEOwqyg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795639835;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jtR2BCwBiiOXE/nYUDE0bn3/rGtsWTBfFTX/QPsmJxQ=;
	b=igwR/j4o001Yz+WM7W6bp2iuGzIel7U4Nl6TfqK9jXuiH27Z81zcvz1OUr4UhN35gnmg
	 Yfsm1fUOR85Illeveoc0jWGk4MhRxy9fcXuJZRchZxRAdfzPQ6vksc5NOyw/w0XtY6KNz
	 U2DsTW2PtDp3SZM/tTJ8Hjy6usSCjaEwYFiv27P9Vj5wu906gpzdv0FWi8P/HTXEPKghw
	 MnuPYSZLPz7VianWFInwJ+uxE9CLcUL10NEXvyOB5SwsoOZe77uF55DZF3Kof5ufrkiR5
	 9qnfxLgQ7tBG7LJCudXYt8G7yDPWKCZU6gm9lArS0FEIh8aQdd8HIroY4gP52gR6Zvg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D60FB1F000CA;
	Wed, 25 Nov 2026 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795639835;
	bh=jtR2BCwBiiOXE/nYUDE0bn3/rGtsWTBfFTX/QPsmJxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=oOlGNqW/wuKrPdxb8Ew1Lkl6eUy1HyTQ2+tc8RDGsN2YOeb/+0/Xle7IRQmsq3bxo
	 C7VylX0dYkyAMWrIqplK1/IYUsIJ1qZm4/yfKrGAbSrSJhmreIuBut0HqEVriJyEzt
	 eKOx0d+pGjWPc04WDXCT1ctLCdBMkx06Y0AQYNlwak6JWwZmQRx5aYqtPu4IY3e2v5
	 VpT8w0L4qCJHZUayMCjopoJAEMBwz2NOdZwUEdHIvKFP2+M7N64FwR1VlhloKeyNVn
	 43HnbfpSkOw8t1MiDletp0PAiGWFTiaxHclvThB0aqZjft7jIkQeWnvRL+hUTpCwvk
	 cbzoon8h0xBjw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 594504D03C;
	Wed, 25 Nov 2026 20:50:31 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Wed, 25 Nov 2026 23:50:29 +0300
Subject: [PATCH RFC net-next 1/7] dt-bindings: net: dsa: allow the QCA
 four-byte tag protocol
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261125-almondplus-offload-rfc-v1-1-703175c6340c@gmail.com>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
In-Reply-To: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>, 
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Hans Ulli Kroll <ulli.kroll@googlemail.com>, 
 Linus Walleij <linusw@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 Russell King <linux@armlinux.org.uk>, 
 Christian Marangi <ansuelsmth@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, Fil Dunsky <filipp.dunsky@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795639829; l=758;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=wkWk664vl65KKLXoTZskWR/R2hKT7/ZFZXG8a8vLUkk=;
 b=/eO4EXD1n36cNyH3ASrEAiKexWlKJjTPGD8kpZhI/7Ia3+/vWyKH6iBhrle27HletfgHHNBVX
 gpEUi5XwYYBDCMK0lIDc8Hybti2nuEAwSXdBZnU7RwLpRbJDx8PeB1N
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com
Content-Transfer-Encoding: 7bit

From: Fil Dunsky <filipp.dunsky@gmail.com>

The CS7542 parser needs an EtherType identifier ahead of the QCA
metadata. Allow CPU ports to select that format through the existing DSA
property.

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 480120469..30c6f70c9 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -53,6 +53,7 @@ properties:
     enum:
       - dsa
       - edsa
+      - qca4
       - ocelot
       - ocelot-8021q
       - rtl8_4

-- 
2.53.0


