Received: from serval.cherry.relay.mailchannels.net (serval.cherry.relay.mailchannels.net [23.83.223.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABF1B7F4
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.163
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760143040; cv=pass; b=InpobymAnVIP4vHgSQuTN/a4FWTYb2SsRO92GkFDO46znsJlAm0DTDTeogWIFFoqb2g8BGhBTh60rZ2cRAa2VdB9VSAiJ+6Mgx9AS/MOiILajp0CFmZr8oXKv3+CQo1tQ+wXYhN/QaYO5Fr2KBGQcallWLYGExW9e+zGPPAfXTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760143040; c=relaxed/simple;
	bh=U8MLET2Exz5G830tZha9bUQhwnFZr9oINN7WuhBK6Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3Q9cDzv9vWnll8bf/p+ypTnDxMDnkjzGiFdwe0e+MHtFzbvUAfabOW8DDjcayB7zN7AB6p1geEY7crNSsqVRVXnIzst9JwwJmSvsMUtJ8+EkZDS+0VRGjPA9nYhtONXtmw95rDgcMLV5CDHqQkxwU6Uud0ljVBwxRI/wX6HeYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D8B9441874;
	Sat, 11 Oct 2025 00:29:37 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-6.trex.outbound.svc.cluster.local [100.114.109.107])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 1E05C4109C;
	Sat, 11 Oct 2025 00:29:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760142577; a=rsa-sha256;
	cv=none;
	b=DrXMnrz/PSE3YtoV2c8RnjJWeiiyXfMm3WpOa6+IJFPYx0WoMxPRqC3/TgLL53Le5wFtlm
	ZCvKMzHltQk63enLME1TQVrDsypsIjTf0pkpl1pczg+3vseKeslGSIVQNxW3w+/OtyWXBt
	sa2Rqja7KP9VbehAaFKkzauMuR8bqSZQJPJIXU96Pm47yNYptmkx0ivsDbRcYaaDSzdmY6
	00Z6xLHB9L2p+UrlT/K6KLSXuoLdI/j8cGa/JeBovLcIOfso8B2uAqtbbhuPkWtx0lOvU9
	GR4ky0qN5mFFohth2QuP8sIXv3XoZFtLnQQfklFyStYyVanP0Zg6KJWZGEOHCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760142577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hUaKjY3RC65usABykH9NAHnOinsoQbrPrBJ0HMWpjk=;
	b=eBX5VeHzIfaUqIQPuqBfF9sQREdRw4yruF4qBF5xGPwQY6w4/ZHVp7RxwuaedMR+UdUuYV
	6t12kDIxWnIsdEWispBUKZaX6DeHJNSKfVAECKiXaF0/7U5JX1KnC5lgdxwmSSRqsZGZaH
	i8pzKPF/nnDxRlY487umRNmiH0X5Ib9M62hLSNy2mKFG2pbAo3yTTrq90A/p2JEQfgG5RS
	7uCbTxzvmUDt17MuhM6tyloGL2LoSuxABtHhr6PfYMyTyvRaJUtAVChHfwVsfFbQxdSNO/
	H7d/JAbcZ8GZCB7/YXXC6XNefs0vQDLzdXQUHK/9ds3N/3hDAICRJwRN4GiH4A==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-5rx8m;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Towering-Cooing: 7d1e2a052c209844_1760142577785_118876444
X-MC-Loop-Signature: 1760142577785:3257367620
X-MC-Ingress-Time: 1760142577784
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.114.109.107 (trex/7.1.3);
	Sat, 11 Oct 2025 00:29:37 +0000
Received: from [212.104.214.84] (port=61080 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v7NUP-00000009bvR-2q6d;
	Sat, 11 Oct 2025 00:29:35 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id A0C5F58D12D0; Sat, 11 Oct 2025 02:29:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v2 6/7] =?UTF-8?q?doc:=20describe=20include=E2=80=99s=20co?= =?UTF-8?q?llation=20order=20to=20be=20that=20of=20the=20C=20locale?=
Date: Sat, 11 Oct 2025 02:24:02 +0200
Message-ID: <20251011002928.262644-7-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Currently, `nft` doesn’t call `setlocale(3)` and thus `glob(3)` uses the `C`
locale.

Document this as it’s possibly relevant to the ordering of included rules.

This also makes the collation order “official” so any future localisation would
need to adhere to that.

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 20c63f98..3fef1882 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -165,8 +165,8 @@ Include statements support the usual shell wildcard symbols (*,?,[]). Having no
 matches for an include statement is not an error, if wildcard symbols are used
 in the include statement. This allows having potentially empty include
 directories for statements like **include "/etc/firewall/rules/*"**. The wildcard
-matches are loaded in alphabetical order. Files beginning with dot (.) are not
-matched by include statements.
+matches are loaded in the collation order of the C locale. Files beginning with
+dot (.) are not matched by include statements.
 
 SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
-- 
2.51.0

