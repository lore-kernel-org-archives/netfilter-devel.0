Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B527A103;
	Thu,  7 Aug 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566217; cv=none; b=fyrtaF4XHbysjHEXDXkuYH4kkC4bT2sUFMkePa083LWqtdCORwNHenxLCnEElAImt5idVKF/99yWNx0NqxLEIOqXG/ZRlwndkFohA/jA9bW6vCPWNQ1GvaYPcbY+ZvcGa+W3FtNexAWgX1iaCK2u665GPevoHXutC2I7cvCGX4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566217; c=relaxed/simple;
	bh=bMuVZopKxW8L3JF1FPlnErKii7P1JwvQjdRejrP9EgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TXghS76jJP+WOLYeEeKY08GTTdXurdpppPb/MI+P1aLwZ3F0QslcM2Hn+mFR+jSP5L1jk1y7zSePH53sNCy6QJItPAdA1LYYkXxrGAtKgpPlJnW3otiKrncdNwKZwncz6NJTZVGZ3uPLFwx0L8gWBjWU62UJ3OBMU4D59gS2UCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OfVzDsK5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EKpEKG4g; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OfVzDsK5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EKpEKG4g"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E3006606CA; Thu,  7 Aug 2025 13:30:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566207;
	bh=BOKBee0pXDjK0rcqB7/mhJanbHgdrH4s5HlL8r1CbHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfVzDsK51zmUogk0bP4HXBJ+1uUCCfoSiB6Gk4UiLW+B70SC1s3b1eO4dHccz/2Lo
	 g6fad1kuOna3ZKXb9GYoF//J0zsvJyc37d90DhSImUv9CoWs5NYQ4Ex2bQtKxn30O2
	 EHgoksUFmNXm0hWxRS5PMwto5w4uQaxi7VykeJnYzSZgFnTGzzM7c91bSpHWDD+QC0
	 nkiM8zE4dmTS1CwahMDF3d5Oo6SJLx8gY7DsXGW+7ngCQnKGRrO2cJ1FjqGSRPVlQo
	 T373HHeFAjFTa8oge0UFw7fL7R1VKHLs86wdFWC7OvuQYHqlSTYrOed7ddlZazjRI+
	 4ssGOGJAUy+EQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 761A2606CA;
	Thu,  7 Aug 2025 13:29:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566198;
	bh=BOKBee0pXDjK0rcqB7/mhJanbHgdrH4s5HlL8r1CbHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKpEKG4gBY9AmzXmygv7CqpkBoFa+kmflAi2f4o+Zi+PKbCN5+8fT4sQiVHuzwwX6
	 uQJVqzMzWaOa3bokpZJ8jBcJwRCZ6WamVTFH/iaPYGHMeFvbg+lfykTccZq3JqYBHk
	 cjwDAGfPoSgWktuIDk7HfoFq5VKLsMvuMsxjqBzDMsNDylky5pDixxMiE5PKJh6Rr6
	 IFmHyIXTlt+xpERnXcSWmD2WtuFbo1XD7M1lIkm6O1zc08If/IiYySx2ZElVJkpDPh
	 KdZXMoLm80fmbhRAmPbPMuIWqvFaeXLzbE2Yf8YL/xgKao7HPU8KUDS3QPHmylaTae
	 +20KujOwMjqNA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 6/7] netfilter: conntrack: clean up returns in nf_conntrack_log_invalid_sysctl()
Date: Thu,  7 Aug 2025 13:29:47 +0200
Message-Id: <20250807112948.1400523-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

Smatch complains that these look like error paths with missing error
codes, especially the one where we return if nf_log_is_registered() is
true:

    net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
    warn: missing error code? 'ret'

In fact, all these return zero deliberately.  Change them to return a
literal instead which helps readability as well as silencing the warning.

Fixes: e89a68046687 ("netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b8b10a85233..1f14ef0436c6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -567,16 +567,16 @@ nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
 		return ret;
 
 	if (*(u8 *)table->data == 0)
-		return ret;
+		return 0;
 
 	/* Load nf_log_syslog only if no logger is currently registered */
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		if (nf_log_is_registered(i))
-			return ret;
+			return 0;
 	}
 	request_module("%s", "nf_log_syslog");
 
-	return ret;
+	return 0;
 }
 
 static struct ctl_table_header *nf_ct_netfilter_header;
-- 
2.30.2

