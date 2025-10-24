Received: from cockroach.ash.relay.mailchannels.net (cockroach.ash.relay.mailchannels.net [23.83.222.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E119DF6A
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761270026; cv=pass; b=KQ+/RVQH/QAAMRIt5eWI8q+tCXmJKuGGeLy30++GHwNzrXieFdmm4nY1mxrRq90CMewPl+6SOtR+yWkAQBVpme8kwKARpxwtv0pD+fsBj9ZPImu/CvyE0QxhZrP6DEWoAkHxrehfImYQx+uNt4afpnwYizUdxTezPlPps3Qnrq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761270026; c=relaxed/simple;
	bh=Y+xVR6/HSjtDBqPbfJ4fVeVJDDrs6y33l/Ky+G6R9fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsFk3dqZeerHpzYdEPMymnbwixI0vY9E5ca9+tYQZAeWUf2v7jdMlhl13hVyqHlVfNLfRq1ODn8VZIBqjOYi4mFKAWOzy06JLoT3r/4WVo2l9i8OPkr69ACaF6BKdWChh6dTQ0efXhFjm+oKCcJKBTVVG0JEsZ+gG/g8jfNm/0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 277D5721F3A;
	Fri, 24 Oct 2025 01:40:17 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-117-181-104.trex-nlb.outbound.svc.cluster.local [100.117.181.104])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id F17C67216A4;
	Fri, 24 Oct 2025 01:40:15 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761270016; a=rsa-sha256;
	cv=none;
	b=8m4t74CeDMPkLpXcvXP0XiJmcIx7+UXh61rn7FAEyeVrvmGOYW9/xxBoaYAKO3nHdkW9AZ
	4jFA0JmZGoHPrk6wog0f3jTYbW88tQIm8ZykuOqesluM/bjlXCV7XltCL8qqoq14jr+w55
	CzudTcl/FMO76qedRLEIXDl/gIPLyLvhwjaDTOYlgofi7311BEeYjFcCI7emmC1wg+4OgH
	zsKnUQ7IIj6ToB4KXz39O3IV/bEHHedn0abI/kpbyVd5nxAh6TI1/sTEPHrCWOjkaRecQn
	SfrZoHtd1TeeLZicGH3lHba+R0kincRHF/sWSZDV2kKXNiHR/CiFjC7tAt4GqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761270016;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9NfyKSJ+5uPUhbsaWGkdjSADaCxUdO42AntxGkPjEY=;
	b=SMtW9LIR04WCUun238IczKJSdqsuQ4Of+Z6d1PcyY5Ms2tTTmVABH12FIG/8ohZX0wnVXq
	mQIffW8hunWvfNQy7hPfx6nsANIENnXd4BiFGZXX9ARhVf3zi5UQZO8sC4iqXvukGZiWq+
	Bt4KBiR+H/WEvCNKFcD4jdbFeqGwCXrv68w2BBqG6EjwhCY1jzTWFh3Glmas1q41nHdoj3
	NMQ3um7j5bZ1Kzt7BT3FgM0Fc1U6kY0nw71tN9OpyiOeH9ljvKJ/NShJRxR6AJ6KwCTolV
	vLPkK+uzQOJOvRoulsh7CiPX3krk77nX9JQAV4wHQYXyN2bEY6AhtKuURtXU8w==
ARC-Authentication-Results: i=1;
	rspamd-9799b5d46-7ljh4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Abiding-Army: 30e2a61a59e61fa3_1761270016891_2052342807
X-MC-Loop-Signature: 1761270016891:622950431
X-MC-Ingress-Time: 1761270016891
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.181.104 (trex/7.1.3);
	Fri, 24 Oct 2025 01:40:16 +0000
Received: from [212.104.214.84] (port=20492 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC6mu-0000000FiJ7-2nO0;
	Fri, 24 Oct 2025 01:40:14 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 342325AA52F6; Fri, 24 Oct 2025 03:40:13 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de
Subject: [PATCH v5 3/4] doc: add more documentation on bitmasks and sets
Date: Fri, 24 Oct 2025 03:36:47 +0200
Message-ID: <20251024014010.994513-4-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024014010.994513-1-mail@christoph.anton.mitterer.name>
References: <20251024014010.994513-1-mail@christoph.anton.mitterer.name>
Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
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
 doc/data-types.txt | 32 ++++++++++++++++++++++++++++++++
 doc/nft.txt        |  5 +++++
 2 files changed, 37 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 18af266a..e44308b5 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -13,6 +13,7 @@ The integer type is used for numeric values. It may be specified as a decimal,
 hexadecimal or octal number. The integer type does not have a fixed size, its
 size is determined by the expression for which it is used.
 
+[[BITMASK_TYPE]]
 BITMASK TYPE
 ~~~~~~~~~~~~
 [options="header"]
@@ -26,6 +27,37 @@ integer
 
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
index 10f1eb9e..4a90f020 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -775,6 +775,11 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
 effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
 Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
 
+Equality of a value with a set is given if the value matches exactly one value
+in the set (which for intervals means that it’s contained in any of them).
+See <<BITMASK_TYPE>> for the subtle differences between syntactically similarly
+looking equiality checks of sets and bitmasks.
+
 MAPS
 -----
 [verse]
-- 
2.51.0

