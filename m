Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4086212BF22
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 13:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716557117; cv=none; b=d4Joo4J5WXmieaJKEaHS57oi6WwviwAQwJW3BL69NxGC2v4zHfY3JuJ7rwXZrckx8bcEYFbQJYBlsf+AqflRHRchRFhvil0HkUI+NGk3Y5GxQr8RG6bq7KVln1MryeqzPSoPVt2iWStLFTxcOV9Zjdi4175D01vHw1kA95e6H50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716557117; c=relaxed/simple;
	bh=3OdoR0rcDMiCaq1345gpvna26m8DNNSU26Tqdq4+QKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e/qIE7uhX6EZ5t9smZH0VS1WoXZYxTLUJzGooCXQ+6iXbmI+GoB9p8K+V/tYtCHrnACsOwVVrwZvk/+YpZ7qt0HNAIHdxycwGYPtCMuegFFhvkXIkwXSpA4VlRCnqfKj/sekbm/h0lwwL6OBHg3lCLp6yCY/FX8L8pH/Vf+/GwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b=FTotyZQx; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b="FTotyZQx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716557112; x=1717161912; i=michaelestner@web.de;
	bh=oEi5jaMtiswSDtHzJsKxp6WH8UbpRa9uZTELn3+4lRg=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FTotyZQx8jw08i4VQ7Cj2QQKnvXNhZLrCpi+zqgLSjQA5m8tmDkxC3HbVIUhvuJX
	 Ww2Ecmxf8WpNtGV836kbcOX7Ie4VgjM1vE3KJWTIEn3qsw9zzsoZlzolwV7+LCOz7
	 VO8y8l5zWigrKKYxIJSmnVU1Tn1esKuQA6p3IZFr9Vxu/cJe+0L5aH2ejO5xc7Ls3
	 Jd+NDI7Z5oF5KT344Kt1hBfjSCjW3tmRdbJNKCNhSiGFz57PmNzMXYwF6aZJMwPDu
	 rAVq55giu5R/gz2ha24Cdyb0GMRbweMWn5Ta1Qyj51eb/iGu/DXrlOFr4qJktFbbp
	 7SIz2a2denoZLouzmA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from del01453.ebgroup.elektrobit.com ([130.41.201.208]) by
 smtp.web.de (mrweb106 [213.165.67.124]) with ESMTPSA (Nemesis) id
 1MALeD-1sMMk71WNX-00BtLm; Fri, 24 May 2024 15:25:12 +0200
From: Michael Estner <michaelestner@web.de>
To: phil@nwl.cc
Cc: netfilter-devel@vger.kernel.org,
	Michael Estner <michaelestner@web.de>
Subject: [PATCH] iptables: cleanup FIXME
Date: Fri, 24 May 2024 15:24:52 +0200
Message-Id: <20240524132452.84195-2-michaelestner@web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240524132452.84195-1-michaelestner@web.de>
References: <Zk9yrd8Ji1xAcblw>
 <20240524132452.84195-1-michaelestner@web.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mdmMFnCw3sfOK3oRMj7Ii0G+3cnSHX9zyLijV3FjEVwXY9gNV02
 e3xXtHJxPm4xZc39WNimB6+IpYMq5t3eh1jKmRRiH8d1XCB9OGIrcZPbb75RL46qQXZamPT
 Wu/gDkYOqh2bjxroe3I+PbQVDyQpPlRKqIZW67FChp9ep37Hc6k2zXzWvcbrtB3tHHheUJs
 5oNn5iH89DpKYgKBB2lpQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gbb+hID02Ws=;Agxs9PhAVK/lUzRbC4BQU8eNWz8
 DdhiBv0lH9oyzEVT3IIAiDxt3G+xYbOp+oFYQdvQvCGQ67kTX49sVjQzubTkCaSNjUbvmXsKP
 scaTIMx7rw2fBXwV7MlhGtbSPiQRyT3QI9Q7PdVZC9MWPtHrQhNrQBuzsLkF7g7jv7tWZo6Qo
 eY3a32JlUr1w/XKJMm7OjHEGf4UCmRfsJ2uLHQ5ZMzgwuPHA5cyaG/Nn1T9eCVjnQ2QyDgpVG
 Wb81vRii9MvUwPVK6TcTlEDq08GDvcmGQ20aCfg7PZmYJo0IG8772rHcvwIgcKzLy5GLZEDe2
 nQ33uwkLsM1LUEyjG0YP6aJ0g1yNKSgVQQNAV2G6wd6Oiwsxz6bz6PNM0laaKUtxtMiF1xajb
 wgSSNUrnQdEm0+9q4Rql79oox9Sr/GZdTaw2Cm9o8ircNE6IpAJJNTFCCcqvSHwC/JHOMPAUJ
 ZRm3hW9U0PqtWdJG6BF0EA3DyS0saK3aiC4LM1yCbnkt9SjBoUOurSo/5GBRMFIQwRxexyeUB
 ZdfqJqwPq8wd0XEwJuBOcGQT8zaFccTXZaf/KrCL5Jy8xQGRn08EmInYv4L+501tptbKVxi7H
 WhVMiKcJQxY0f6hJQ0mKwG7e69DBAhwYkR0OW9HSY8NrEjCqlBVMyqc4HGpI4wTwwpgreWYsy
 gdsB62LpEzERZ6ZAn76/EQ7X37yYSc6iUBxefiPMN1w49CXOA7RFpt3z8xpHDo7VJo3ZIhlxs
 qD+GY2513mu2Z4oPzVj1fA1mKaFy6CDc7c9BOXoLFUlyMbaIVuZ8GMEeqh588ZG07hm+poeaQ
 I02eZ46oYlT0fVFxxlczHjMYd6u+kX6Waz3WPO3wnByVE=

Rework FIXME since struct ebt_entry has no flags var.
Use variable bitmask instead.
Update the debug output.

Signed-off-by: Michael Estner <michaelestner@web.de>
=2D--
 iptables/nft-bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 922ce983..f4a3c69a 100644
=2D-- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -373,9 +373,9 @@ static bool nft_bridge_is_same(const struct iptables_c=
ommand_state *cs_a,
 	int i;

 	if (a->ethproto !=3D b->ethproto ||
-	    /* FIXME: a->flags !=3D b->flags || */
+	    a->bitmask !=3D b->bitmask ||
 	    a->invflags !=3D b->invflags) {
-		DEBUGP("different proto/flags/invflags\n");
+		DEBUGP("different proto/bitmask/invflags\n");
 		return false;
 	}

=2D-
2.25.1

