Received: from egyptian.ash.relay.mailchannels.net (egyptian.ash.relay.mailchannels.net [23.83.222.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A0810785
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 01:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760838495; cv=pass; b=RAA+9Q8FvBt/MFaXIwZxMfhRXb5RnYlrXQcGdZQG2dX3zTi67Fl4FgzTnAw/w8fYUOxDSRU2vGERvrDJD35azZ/l9l+wRLS4RJ/XN9Qcvt+6dFMadwc0VUuE+c4wGGwbaaZFDbZM1CloRCPkKB3UerRihVW6HiG7bbdo7KAkPjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760838495; c=relaxed/simple;
	bh=bNSvduMJxPk2gfbPaqpJyvav9W1Amhsvu+HOrCBpr/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY56KOyub8TXsToqXfsqCK73EKgq1xo1yWqFHMjfZaO88+xgqXMkT7J4bp3MD8h33nJniLx8bVs+cGjzqIiGdWxBPzzaEvB2N822bwZtA5EDfpe4+7nIOvqXHh/bHu7/vR7zp7T6SwPVGPRsy2kZ7tcaNN6cHv3DTspPu+vO81I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E0DB1361CE5;
	Sun, 19 Oct 2025 01:40:10 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-121-87-189.trex-nlb.outbound.svc.cluster.local [100.121.87.189])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id E9C58361E0C;
	Sun, 19 Oct 2025 01:40:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838006; a=rsa-sha256;
	cv=none;
	b=C5lxidD5XWZHAhap40i3XPbh9sInktLVfXRtUCIavcdTKNV1979ngVinsS2PUoN+DGiHlY
	cK5fyDsVxe7keSHPO7ElsF20BsYkT0WVRh2gfWl96AtLS4BlefSsGG3rB5nKFAc6EkcQw7
	B0qjZ+MA7eKnnQFPnD4KUCqmfCyrO5c+dkw2enA4fBXLPnxnys7qFrCK97tfiNcEuvO0i5
	8aoMQZM0pG3oX5ehYcdZn197w8Rugeo6+gBeYNeQ82s1YKEnWm8IJtEbilstkdq+d/Bf++
	aWC8xPLSqooB6wfoFYxW7Xcxii9V99xAdgjUsjlgU2BVYiONRuyj/Mg5OsC+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hzOsnvU2nXWzJKsGVg+IdqBlDeEdOqtaHZXZXginHSo=;
	b=pvX6STN1tm5UrLigui0B0aZYB7IjYwZtLF12r2ANTfSH7/Ayw4qUilHRfh5zGOF7/o+mfs
	CY3SHjm2L7UQ0+mSWup7iUcGK0PswLcnt2eOycUIb4+isM9t5DVnnspoqGxO55T1Q8ObuN
	/4DTZn8NPl6QDtjOzgWOEtYae6sMmwfAYzfp2dUHB2PAoYrz32pXdNbNhY1YOzZkFI5rzK
	o4ZMT604Gp3HXlHDnnDt1FwQTAvasil3rOsNDnFHbep+QOgr1YfqIpfrVsBuILGFGjc3T2
	sX9RFXC2s5mYIsKfxL7U5zbvHrR1oJVD8adSk8vjM9wpLid+osjjMTTUE6u+jA==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-dmgkf;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Minister-Broad: 40bab2490e644051_1760838010826_735185792
X-MC-Loop-Signature: 1760838010826:3350717110
X-MC-Ingress-Time: 1760838010826
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.189 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:10 +0000
Received: from [212.104.214.84] (port=1699 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP0-0000000DT4u-2IkX;
	Sun, 19 Oct 2025 01:40:04 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 9134859EEDED; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 4/6] doc: add more documentation on bitmasks and sets
Date: Sun, 19 Oct 2025 03:38:11 +0200
Message-ID: <20251019014000.49891-5-mail@christoph.anton.mitterer.name>
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
 doc/data-types.txt | 26 ++++++++++++++++++++++++++
 doc/nft.txt        | 10 ++++++++++
 2 files changed, 36 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 18af266a..8a86060d 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -26,6 +26,32 @@ integer
 
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
+Note that *'expression' 'bit'[,'bit']...* is not the same as *'expression'
+{'bit'[,'bit']...}* and analogously with a named set.
+The latter constitute a lookup in a set and will match only if the set contains
+exactly one value that matches.
+For example: *tcp flags syn,ack* matches packets that have at least the flag SYN
+, the flag ACK or the flags SYN and ACK set (regardless of whether or not any
+other flags are set), whereas *tcp flags { syn, ack }* matches only packets that
+have either only the flag SYN or only the flag ACK set (with all other flags
+having to be not set).
+See also <<SETS>> above.
+
+As usual, the the *nft describe* command may be used to get details on a data
+type, which for bitmasks shows the symbolic names and values of the bits.
+
 STRING TYPE
 ~~~~~~~~~~~~
 [options="header"]
diff --git a/doc/nft.txt b/doc/nft.txt
index 363c67ba..09da6f28 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -776,6 +776,16 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
 effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
 Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
 
+Equality of a value with a set is given if the value matches exactly one value
+in the set.
+It shall be noted that for bitmask values this means, that
+*'expression' 'bit'[,'bit']...* (which yields true if *any* of the bits are set)
+is not the same as *'expression' {'bit'[,'bit']...}* (which yields true if
+exactly one of the bits are set).
+It may however be (effectively) the same, in cases like
+`ct state established,related` and `ct state {established,related}`, where these
+states are mutually exclusive.
+
 MAPS
 -----
 [verse]
-- 
2.51.0

