Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C8713D516;
	Tue, 24 Sep 2024 20:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727208858; cv=none; b=rGZB98OaJSaE+bZyB1LYXL2H3dQZZwRLHZwyEcHigKSNt9xeIlgLH6rFEPfJfbmDPHP06qkus3eAnIOn9Q7NtMgWiH1+oFt8R3Aag/ghS1MIziK9iDrKY3FH6nTCqQk2vzlNFeEVk8qN7C2PHmYgfokcWzcifPajH7/3kN+kMVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727208858; c=relaxed/simple;
	bh=iw5rqZhlyRRvWig+zMEW4R2IZGqmW6nnfjeUJSwKezE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIuM2sA8WPSOHVaQKfHvuQOimy//alYaA1m31WAIpClhAGhMZPOGH5YTi8GKYB1Sbd8ONsr0LGZb+FxRMGieJ6Ry/OK5yN/6vzCwPo3hQAFL2oz7pC9bb2zyXGlD4uOOZC31/NgU7P0sGPAd0H22QDybd+bALCeGJINI2PVbtGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 06/14] docs: tproxy: ignore non-transparent sockets in iptables
Date: Tue, 24 Sep 2024 22:13:53 +0200
Message-Id: <20240924201401.2712-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240924201401.2712-1-pablo@netfilter.org>
References: <20240924201401.2712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

The iptables example was added in commit d2f26037a38a (netfilter: Add
documentation for tproxy, 2008-10-08), but xt_socket 'transparent'
option was added in commit a31e1ffd2231 (netfilter: xt_socket: added new
revision of the 'socket' match supporting flags, 2009-06-09).

Now add the 'transparent' option to the iptables example to ignore
non-transparent sockets, which is also consistent with the nft example.

Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/tproxy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 00dc3a1a66b4..7f7c1ff6f159 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -17,7 +17,7 @@ The idea is that you identify packets with destination address matching a local
 socket on your box, set the packet mark to a certain value::
 
     # iptables -t mangle -N DIVERT
-    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+    # iptables -t mangle -A PREROUTING -p tcp -m socket --transparent -j DIVERT
     # iptables -t mangle -A DIVERT -j MARK --set-mark 1
     # iptables -t mangle -A DIVERT -j ACCEPT
 
-- 
2.30.2

