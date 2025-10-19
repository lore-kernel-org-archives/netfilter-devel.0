Received: from dog.birch.relay.mailchannels.net (dog.birch.relay.mailchannels.net [23.83.209.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD836FC5
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 02:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760840381; cv=pass; b=OBfj0sQZOTwbzRtm6Xuxk37Fg2w86mFzfrJLYq1jS+31HD2wwHb1G1O7H7SkFxfpVKUxXfqeaay7q+/fFFi/wyJPrfB10mUyDif+VrTUdWOMy9YIj2Q+KbZxurX7u0dVAHprc1G5KeiArg9c+82qwn53I+6pRDFE4N/4e9gQCXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760840381; c=relaxed/simple;
	bh=pdkGXJ6WCO5C6meyLVK9qKI85jMTIrestyBUEL0U3uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVprzEptEJAkWl43oC2rzqpaGzP7r1KH4DL6F1wv8pMpWgs3cax2p8OS7ezTu6HuJ5xkfMUN5n0EsJ5+N/lM/eCabQYT7kwMC0g9zS1IpHF2JF9cWELAsKUC97qXtHJ9NzGn6MNUF1OWptNC4qsruDQovs5w3e4LfNJRSKXY4C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 078F78A0B2E;
	Sun, 19 Oct 2025 01:40:12 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.121.87.184])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 209A38A0823;
	Sun, 19 Oct 2025 01:40:06 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838007; a=rsa-sha256;
	cv=none;
	b=zg9pdc1KIaklorCxIOI6Yd6TaxjeN69e0SChMpYZfMx1qng8z6eBvjZfo8keH5D4+vX3Tb
	VtzJgl3LMJF6l2+9tScKoiW8/gmA+F4r54zJSwFtOeHXIBgsjnTTXqBUCLzm2oHILHNXvd
	JoviUZVjAV4VqsXvqeDvl7KYSnY2SbKHU3LtegrIsFu4JiPeJEd1AAB4/jgevBQxFIvwom
	lthD9NqlN9USf1ihG+P6aW0wTPHfbHDXAWLr+TFHK7VLWfR/nsvfaaErksk+h3lAuSo3s7
	wBSYHt7kEtDbAPPjiSiNt+ASpOt99S5ymSzM9rHPaBvnT6coizeltqJgWfl9fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwysecX2A59Xh9NMIgmKGJfASnwQfcLSqxsegNKjGRo=;
	b=MqEMXxNatTJA5fwQm7yVMyRd7NyXSKeDk85Myd6NilapCteYE8RoE2VDXqoKFf+0nI8Ajc
	lqeCvHUrvvh+nhL/Sox73l6dYga085zEM/pR6Sw8RgIw+HxWGntM7ZGgkoA7dilEd5+pdo
	ULhdn9XiWjD60E/6QBK0WUCLBvkfD7ZUh5hyMDK3d/18fsjgGmzkHhLferDL9Ls2Sfuc4n
	7qZ1YjHHTQ+Gf/XLWZq3gijUBH7/SyuZgd8lNGduBvVijDuz+JmzSFQMA/YToBbsY5eQdg
	U6CxUKZAxBy3hpWrJqu/6EEZZhhql7Y0VFWC3aVMPj/M7+smX6JSo4hEuISJ0w==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-dmgkf;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Trail-Suffer: 3ed8033676bcd153_1760838011937_1634669761
X-MC-Loop-Signature: 1760838011937:2180636965
X-MC-Ingress-Time: 1760838011937
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.184 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:11 +0000
Received: from [212.104.214.84] (port=56065 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP1-0000000DT6e-40EB;
	Sun, 19 Oct 2025 01:40:05 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 9A2ED59EEDF1; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 6/6] doc: minor improvements the `reject` statement
Date: Sun, 19 Oct 2025 03:38:13 +0200
Message-ID: <20251019014000.49891-7-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 doc/statements.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 61a4614d..5d34d03a 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -233,10 +233,11 @@ ____
                  *tcp reset*
 ____
 
-A reject statement is used to send back an error packet in response to the
-matched packet otherwise it is equivalent to drop so it is a terminating
-statement, ending rule traversal. This statement is only valid in base chains
-using the *prerouting*, *input*,
+A reject statement tries to send back an error packet in response to the matched
+packet and then interally issues a *drop* verdict.
+It’s thus a terminating statement with all consequences of the latter (see
+<<OVERALL EVALUATION OF THE RULESET>> respectively <<VERDICT STATEMENTS>>).
+This statement is only valid in base chains using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-- 
2.51.0

