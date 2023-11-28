Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OfT239YU"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB23A3
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 04:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2s+dM/MI5/GoQkd51T26IMMVpQjt1JeH9OO5jr4n72M=; b=OfT239YU2V83+lqghtKXj1NCt4
	3xeyMLtBBXKbAAxVP/dibxHX6RBAY2Ak1V5Y0aiO4lkCl+sQ2ObGkZ++neRO2d7JVZvF+49yy1REC
	oQ/il6WfodMZ2W76ri+UFykFBPYdZBfFaityYP6amYMDcEJaAZDOAUkqpj9noO03j3tA3g4TtHfqt
	ozstP9FMheqr43ZVKq6yyzTfSQZSCt4CK5ppGzkKtGiFiePjEU0vE23KOzJ/h6jeyiszCBuru2ouj
	jg5U8plKbwC5HBN8VEejvaWC/M09DmWS5w2RHk8+S4DjcNv9Jv9yvy52CyjqG2T3NUvbrDqZAC4/R
	4+DJWOUg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r7x4v-0003za-KD; Tue, 28 Nov 2023 13:20:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH] man: Do not escape exclamation marks
Date: Tue, 28 Nov 2023 13:32:43 +0100
Message-ID: <20231128123243.12790-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This appears to be not necessary, also mandoc complains about it:

| mandoc: iptables/iptables-extensions.8:2170:52: UNSUPP: unsupported escape sequence: \!

Fixes: 71eddedcbf7ae ("libip6t_DNPT: add manpage")
Fixes: 0a4c357cb91e1 ("libip6t_SNPT: add manpage")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_DNPT.man | 2 +-
 extensions/libip6t_SNPT.man | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_DNPT.man b/extensions/libip6t_DNPT.man
index a9c06700a7dcd..2c4ae61b249c0 100644
--- a/extensions/libip6t_DNPT.man
+++ b/extensions/libip6t_DNPT.man
@@ -15,7 +15,7 @@ Set destination prefix that you want to use in the translation and length
 .PP
 You have to use the SNPT target to undo the translation. Example:
 .IP
-ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
+ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 ! \-o vboxnet0
 \-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
 .IP
 ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
diff --git a/extensions/libip6t_SNPT.man b/extensions/libip6t_SNPT.man
index 1185d9c01ce8a..8741c648d5986 100644
--- a/extensions/libip6t_SNPT.man
+++ b/extensions/libip6t_SNPT.man
@@ -15,7 +15,7 @@ Set destination prefix that you want to use in the translation and length
 .PP
 You have to use the DNPT target to undo the translation. Example:
 .IP
-ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
+ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 ! \-o vboxnet0
 \-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
 .IP
 ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
-- 
2.41.0

