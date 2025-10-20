Received: from silver.cherry.relay.mailchannels.net (silver.cherry.relay.mailchannels.net [23.83.223.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ED922259B
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004304; cv=pass; b=X4HfB1/UZ47MqFK/7XetqTrESoX+7jflrHAg9IuKKKwX65WGIl0HDGUx0koGy3BWM25o4/xkqssYLhPcSL0iaZTk5bkOPNDzTIvqJonyJpVLMSm7UHDhblJVd9gop5btSj4I2bQ/yGQ0oB2pKgepP433bnLWgw3dhUlKIlB5tIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004304; c=relaxed/simple;
	bh=80/D75yy+ksTRDK1fbe+EfYeFX1Gggo0uS3zXsRJhr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mm4NJn9FvzZ+lXulNAFQCJBxC/+alZ8YKFFtDVB6eivrfAjq+jEouwWqa34Auhz5rlae4hzKSPYGKWRwXeJ8BQHLh47URFSHs8cUyven93FC35BWCFkj9YXh2UllJkCEtfBx4SD4kq6wgqq9Dv3aJjkHIatZ6pbkEK/WYTbhD4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B4A78901DFB;
	Mon, 20 Oct 2025 23:51:36 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-116-230-204.trex-nlb.outbound.svc.cluster.local [100.116.230.204])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id B645C901966;
	Mon, 20 Oct 2025 23:51:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004296; a=rsa-sha256;
	cv=none;
	b=pMU8DIld8j8ag2eOx/VK1kR+YVcyVbSW4TAj+sNWe5iwkdaUg14qAwaYZsoMnOcuVYPHow
	8Nxo/9vJ4rz2VpigSe5ZBFcMYGsSQ5XqyarCK12+reBbPC9Qe0Vgjg8/QUEaLAQsh5x7tF
	pxiDdtunFuYg8RajpDTKMP2KZb5r6AuK7Q1va3G584o0Eh5H/ltUTd+fU2BS935cOMzVzB
	KXhk5FyRNczgBnZdfmzh/LOuYUSnAemQbMZyE5BuFs9NrnO3DfNQE4m9fxN84sT/eU1nOY
	1po2q20kf1sI91mXn0Q1998thyBvZWR5KmKbeqnC+OhOmTxHqAUIL04nk98/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC86XUxtTL1exRBgslf8k1ItRvmN8AChwsLLb5b3V6A=;
	b=GH/1qdUruMIk7orkydGxCsOvGrqR5GdlXqzu22n3d85xC1mcE5TLFbde4jW0hrKBlByPqv
	Ekd77wQlmjVdfDodqY9UHQlHkVH8vPD6czM4ChbNReUt/GS8/bYnQp0azY7KfMuZYV+RSA
	4+SbFLJkdfsnwE3rAX4EKm9DEa2SzQeeMgW7XuUGr1IDSvmnc5p6jdH13b9ga4uv+r7rKA
	UAMBgeC6GLOJ2Ia4sLnJp1zMFIbCfcC3YM+FNKY899DCDqEaOkKVYcq4iAZXFdkidG5Wj6
	t/QPOeLqJpbpGY9XsE8JCGKW8YUC63gstnzUnZ52qDawB4z9eUdJgSFzwGv+cw==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-rdvn2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Squirrel-Snatch: 5da63269636eac68_1761004296592_3333574818
X-MC-Loop-Signature: 1761004296592:3276807394
X-MC-Ingress-Time: 1761004296591
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.230.204 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:36 +0000
Received: from [79.127.207.162] (port=14925 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAzf4-00000009cok-1hRN;
	Mon, 20 Oct 2025 23:51:34 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 6544C5A29C27; Tue, 21 Oct 2025 01:51:32 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v4 3/5] doc: add more documentation on bitmasks and sets
Date: Tue, 21 Oct 2025 01:49:03 +0200
Message-ID: <20251020235130.361377-4-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251020235130.361377-1-mail@christoph.anton.mitterer.name>
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
 doc/data-types.txt | 31 +++++++++++++++++++++++++++++++
 doc/nft.txt        |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 18af266a..b36ca768 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -26,6 +26,37 @@ integer
 
 The bitmask type (*bitmask*) is used for bitmasks.
 
+In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
+'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
+example *ct state*’s bit 0x1 has the symbolic constant `new`).
+
+Equality of a value with such bitmask is given, if the value has any of the
+bitmask’s bits set (and optionally others).
+
+The syntax *'expression' 'value' / 'mask'* is identical to
+*'expression' and 'mask' == 'value'*.
+For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
+`tcp flags and (syn|ack|fin|rst) == syn|ack`.
+
+Note that *'expression' 'bit'[,'bit']...* is not generally the same as
+*'expression' {'bit'[,'bit']...}* and analogously with a named set.
+The latter forms are lookups in a set and will match only if the set contains
+exactly one value that matches.
+They are however effectively the same (with matching bitmasks typically being
+faster) when all bits are semantically mutually exclusive.
+
+Examples:
+* *tcp flags syn,ack* matches packets that have the SYN, the ACK or both SYN and
+  ACK flags set. Other flags are ignored.
+  *tcp flags { syn, ack }* matches packets that have either only the SYN or only
+  the ACK flag set. All other flags must be unset.
+* *ct state established,related* and *ct state { established, related } * match
+  exactly the same packets, because the bits of *ct state* are all mutually
+  exclusive.
+
+As usual, the the *nft describe* command may be used to get details on a data
+type, which for bitmasks shows the symbolic names and values of the bits.
+
 STRING TYPE
 ~~~~~~~~~~~~
 [options="header"]
diff --git a/doc/nft.txt b/doc/nft.txt
index 4cd3fa8e..4ae998ed 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -775,6 +775,11 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
 effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
 Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
 
+Equality of a value with a set is given if the value matches exactly one value
+in the set (which for intervals means that it’s contained in any of them).
+See <<BITMASK TYPE>> for the subtle differences between syntactically similarly
+looking equiality checks of sets and bitmasks.
+
 MAPS
 -----
 [verse]
-- 
2.51.0

