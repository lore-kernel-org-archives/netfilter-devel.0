Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CD5291176;
	Thu, 24 Apr 2025 21:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529326; cv=none; b=U4BEtx7V6WV1pz08K/NErlmFKUMRM+hL1lcxNEjmcj4aL4oi7tXta/cPtxfHNZXe74oe+ZAcSXGrbyzZuyJC20GuRy8vT3KTAVUzg+v8AC7LOChFK8sMYsDaGYX1V+mAoCjKtC9kQkcUyPdogPho775KmYtAhJU0YFiHVpWkqbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529326; c=relaxed/simple;
	bh=Obpy6Gk9BM7Cii4f8ARMhEnscTfegUK0L4kYnsY1s94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WVsqCJwVy39noLDGpuzBJ6ZX5cKBNHqfKCzoLihMLw6aswKEzZt9iAF6lLO6CUNyP4e2s0KehxVI5Od6q6bKUDl5X1Dd6r3OeWQh+GmvVkb2VNMGO+W10uZb5N5Cpygr3n+tCgVNo8uEjV9H027jnGNrvA/VbybcsSmHP1+5zi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lr9y4a25; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gRoyyvSO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lr9y4a25";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gRoyyvSO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5155F60716; Thu, 24 Apr 2025 23:15:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529323;
	bh=/EEmQF7EDJiKm8KlBu3EyGVNLb/l73f/WI9g4RoKC6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lr9y4a25XICKQfSAhLeyryYnrUKxVv0xeUsZH0SHTW5WVzQltVTh+hJpR1A/0tg/0
	 1+lYEbvvFTwWpP/5ljDjd3oZbOE72Y8kEQZ6Apok2U0YxYK82LakKblYTWZgDSWYCW
	 lYXnnQPykxO5ksDmYbC3lPAWgnLt0nwqZisAHE7kxULOE9PT1OyJ4bHjxvvewzSm6Z
	 xwGIi39pq6uC18CdatLBsx+2w+z2bKm+n170f+CdCovtvTbrVwuS12wQyLVY7GUNF5
	 RX4mh42QcFNv/VCj9NYtOemS9tXP+ZLO/E/RCstaO1SwqLGd2TNN95Q+9qy0Vz7Siv
	 cCcSBmGKrjQ0w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0735060717;
	Thu, 24 Apr 2025 23:15:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529315;
	bh=/EEmQF7EDJiKm8KlBu3EyGVNLb/l73f/WI9g4RoKC6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRoyyvSOfcQdYC8P15LQBCQdw9eUs+8a8S6hUGoKBkl1ne3Nd7LbvtlU/hAZ0Opw4
	 HiIFynaIxNkL/K4MIxkhZ0SX9/xJj2UMo66WHwjSkE/lzzkC09H+vBIZbILeoK13qr
	 pXU+vdGzplAi80gckINkyuRPTrKvSFGbCFMYkSeiSUfle6JLeqrXIjLKQTfqOKmii9
	 wcP4HK5Gz+tdXLAPeKMmVkkkK2+Irc5jSNkZqX9WwPhxvoFGus7I32R+czATXNGBC4
	 kLRiNf0oCAuJSc7Be96ycETvqQTEJSH0YR6ul1A3/o1h/vM/lmBFVZkX0FS5AEvgj2
	 ymFG2DOXexTbw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 6/7] docs: tproxy: fix formatting for nft code block
Date: Thu, 24 Apr 2025 23:14:54 +0200
Message-Id: <20250424211455.242482-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Linxuan <chenlinxuan@uniontech.com>

The nft command snippet for redirecting traffic isn't formatted
in a literal code block like the rest of snippets.
Fix the formatting inconsistency.

Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/tproxy.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 7f7c1ff6f159..75e4990cc3db 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -69,9 +69,9 @@ add rules like this to the iptables ruleset above::
     # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
       --tproxy-mark 0x1/0x1 --on-port 50080
 
-Or the following rule to nft:
+Or the following rule to nft::
 
-# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
+    # nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
 
 Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
 IP_TRANSPARENT) for the listening socket.
-- 
2.30.2

