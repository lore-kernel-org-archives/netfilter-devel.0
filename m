Received: from cockroach.ash.relay.mailchannels.net (cockroach.ash.relay.mailchannels.net [23.83.222.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6858A1A5B84
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 01:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760838581; cv=pass; b=OMuZcOB9Ihnv9rZ4HJimhOHZTWMB2hLR2kShF//YDFjKKn1PMrIh13HEGOKorTU0pLESyA2YUkntyZY7ic4S5GqkgauYgeeFU5SriRsmeSiL6uYlmC6J8PDGiYHuYwoZAMhikOcEgMZaiQ7DeBqQm5yul5AuF14wnoPiTBV996s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760838581; c=relaxed/simple;
	bh=nCvUn0C2kd8XIGv9KDjlgRF92FAXTdW9OK2+UExtqyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zr96vm2+ycC7lKgrabnrAyiPVWklWfiHNT7NgvT+8LjgMiwNjfkHRb40TAOEUr0KsoDmoJb3pw5+1vA4ZdK1C5jwJ32f9Eklv14eDSIlFP64q1mi1RyUTVSdgjxCOqV3O4zDz+ISHnFc8sH6fvZucItAEx1QnY7draVBL6Qdfk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 807108A095B;
	Sun, 19 Oct 2025 01:40:06 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-7.trex.outbound.svc.cluster.local [100.119.151.11])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9F06E8A088C;
	Sun, 19 Oct 2025 01:40:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838006; a=rsa-sha256;
	cv=none;
	b=48wFrEB4zWwBN4hKJVwjQDdATkqx7JLj6Jit8OnWzweji6ynuoFX+1tPyReS7x5Xd8LRZz
	CLG1ZcNCfB7mK/11wJRLSWPDHt5TUJ4ORHtDez51Lsbdkhk3n5cU6+2XNPnqk0BUla0Swq
	iBdPijYrS7icTTU7gxefk4l6nig+FVgKSydRxsLL/9fjEWn7TQs53FWOiu7EoJ5l+FTFu1
	cx8F0IHJJ36cB7MbLsspEtno1VPn+H6cMUiBUH03DlkGmjvjetK7FvBQBycaoTWFUuRhQr
	sLfiBpNA4HXFGE+8zwQmufSue9X1eHNC6LDupUqQ2e/gtt9p6tAznBbYhkfl5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f/G7wdA+FBBiRn3TKytq+HhM+2w9GqxamJ0jDQtKLjM=;
	b=U2xM9nd5XCGG9ZuMqjss+Uz/gVMQm2JTOR4gAM05Wl24kMjCHmC0YwlJxDNwFP7PPuMFPv
	aWhHFzthH0YE0eEExHJxrEJIlrHslTffGltWbFDJY/ze5jCIHIy57TtWAB3N0st7nO2kQM
	hoHJO1epoCnvfwLr00DwqaS/C39F+/iAM66f6T+tlbfLxz1vvGNGY7QdQ0pJ0rMBq5tv/d
	5ie82Ltk5H8QjEJcYAPIRoqUOFxBxFgND5L5N8jWNGwODPZtF6OZX/c8mC0sHEqNj928LA
	KfIvj3AXK6dGxlorcvcVc101P0APqEHcMQTuKu/VOVNwr0jLWPTZLsvvAVoiKA==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7ffz2;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Daffy-Continue: 749b875168adf17f_1760838006319_4201855896
X-MC-Loop-Signature: 1760838006319:3422572262
X-MC-Ingress-Time: 1760838006319
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.151.11 (trex/7.1.3);
	Sun, 19 Oct 2025 01:40:06 +0000
Received: from [212.104.214.84] (port=37284 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vAIP0-0000000DT4a-1wy5;
	Sun, 19 Oct 2025 01:40:04 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 7C8CD59EEDE5; Sun, 19 Oct 2025 03:40:02 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	pablo@netfilter.org
Subject: [PATCH v3 0/6] doc: miscellaneous improvements
Date: Sun, 19 Oct 2025 03:38:07 +0200
Message-ID: <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Hey.

v3, rebased on master, with some of the changes as discussed in the thread...
and also with some of the "controversial" stuff (which you may change as it
seems fit, or we can also re-iterate).
Of course Florian may add his Signed-off-by:. :-)

The former
  [PATCH v2 1/7] doc: clarify evaluation of chains
has already been merged and was thus dropped from this series.

Thanks,
Chris.

