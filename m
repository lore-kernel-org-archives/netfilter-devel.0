Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E80204588;
	Fri, 21 Feb 2025 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134295; cv=none; b=K5MgbiTK8yk58I35NVWVWS1LzjNN72fPqWiOAM6F26jpwNrJvkjlODbXUYc0Bc/73ZGzoEV1h5DcTqoc6dGwOeSmp6tX3AvXyvrGeReBOgIaA94CivnKAW9S5LbjXbgwaY1DhIYDQJCxLEjOX6icwMcy48I0tZxWV2BCrAFg9Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134295; c=relaxed/simple;
	bh=zsuGkG9pt7DR8lIBmmpcoQmZuYi7n9jRkvURlQJZYoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fYqOz9mFdNv5y+fa0ApasnN2t1bMf2IzTebTJVGS3ELNJcYyuZ2F4y32XyRZwzbAVlhIPFSEFotKlAJ5ZFMPKI8+Y61qDWcdOcTrRkAlB62Eqo5Ut+CquWVmiJJfTY0E4Ds9OIG35Hc9MT2jTwhCgYFN74qY4DdC75bpLsqckwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Zaacu6yf; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Zaacu6yf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=4wsFt
	kC/20HRHnGDtuXh0yXz80WT2rBNa6hfJHDeBME=; b=Zaacu6yfs0qHHjg4DEJMj
	QkSPtptluZiHuUdTEd0GCsyEETN8GuqkFCKinoERecPPWPA5NZVNf7GfEAnEW0Zu
	1lpArqGlF0OhbC1Sh7VWecETumJWxa33xNIX36Ru4shGLYGHKgueSHiWLwb3tvQz
	tWCDssmGaW+tPJjhBajal8=
Received: from ubuntu.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnzzbSU7hnU7KwBA--.55096S2;
	Fri, 21 Feb 2025 18:22:11 +0800 (CST)
From: wh_bin@126.com
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongbin wang <wh_bin@126.com>
Subject: [PATCH] netfilter: conntrack do not print ah and esp as unknown via /proc
Date: Fri, 21 Feb 2025 10:21:53 +0000
Message-Id: <20250221102153.4625-1-wh_bin@126.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnzzbSU7hnU7KwBA--.55096S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF47CrykJFW8XF4fWry3Jwb_yoW3Arg_A3
	97WF18XFs5JF9Fvr4Duw4fCry2ka4rZr93Xr9ruayI9a45GryI9rWkWrnYv345GwsYgFyx
	Crs8try2v3yvkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKksgUUUUUU==
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiOgb6ome4TsNZowAAsM

From: hongbin wang <wh_bin@126.com>

/proc/net/nf_conntrack shows ah and esp as unknown.

Signed-off-by: hongbin wang <wh_bin@126.com>
---
 net/netfilter/nf_conntrack_standalone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 502cf10aab41..29fb5a07a6c2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -266,6 +266,8 @@ static const char* l4proto_name(u16 proto)
 	case IPPROTO_SCTP: return "sctp";
 	case IPPROTO_UDPLITE: return "udplite";
 	case IPPROTO_ICMPV6: return "icmpv6";
+	case IPPROTO_ESP: return "esp";
+	case IPPROTO_AH: return "ah";
 	}
 
 	return "unknown";
-- 
2.34.1

