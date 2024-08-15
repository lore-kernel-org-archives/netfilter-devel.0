Received: from fhigh8-smtp.messagingengine.com (fhigh8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05A610E5
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739886; cv=none; b=VsOiwwK9blgimXqtC7tbyBEGKS5J//9JgZ+olvbdPCje2mRpZNwrm4gsdhw4bqamkuwAvIfz2JU5v/cjRCQtaz4VOncTekIbqSaQZbCxsphewUsnU8iqRbZMzT9LJh8wLY8smVzg1IoLqN2vA3Snjrsg+vQG+60g2j4xRzgkHug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739886; c=relaxed/simple;
	bh=0jg9xd3jcSuVa8OC62H9Ier+G0RUpKHU5IYw3T/Q68Y=;
	h=Message-ID:Date:MIME-Version:Subject:References:From:To:
	 In-Reply-To:Content-Type; b=dDcYaQdsmFN+fLM/8mn9FjXfLL7ivuLY4gzibWYxDMaGnIP+OR4MVtYly7i4uZt22x1AzfXbv4k/A9P/p38MntPk4AKhKQ5Bd5IRTzr+ZtNOPNrUsGHtxyyXHPRMEcVupI1U8dRf2l1F0YDpy0TFdHCYDQn+zSVhmiNUGKKFEOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=onyMnwy2; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="onyMnwy2"
Received: from phl-compute-02.internal (phl-compute-02.nyi.internal [10.202.2.42])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id A70471151AE8
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 12:38:02 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 15 Aug 2024 12:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723739882; x=
	1723826282; bh=/qhdqpDytjFY8JQRQpmCG8R8RMV+0u5qeuR6E+dDSnI=; b=o
	nyMnwy2tTomzUkhDPdiX5mwJj8QT3AenYWaAkotXLAVTSrcJ2+M06uB6F5g1JXds
	skSdC4TrXHnsUtVdOwswOf/msLmvGK1QKSAYKTFs8EL+hKKPHiScyiZ4Osm7YYZ0
	j4g/+FA14EuTa4bOZ/m7MXu28wGn4WBFDTytTNrQKaalxANH/xjtZB1Ba/E5E/4u
	4Y14H3XKVn+5I7b2G9O1FCr6yZAQ65VFruCPW+J5Ke22hQt5TyMe2GAGothROVL3
	Fa6Aqhq6dezh/gxmFZz2qSlZNEdFGc6skm31ILG9UjO3psHQGIxk1YVKo8OumJeu
	WIiRuBREhH96dR80KHzhg==
X-ME-Sender: <xms:6i6-ZvDFCHRJu56c7rvHxaDzDKJXEVzLwEegonTWEtAUi-XKqdW1IQ>
    <xme:6i6-ZlgDyCqCbo7EnlP1yW4PQVawu8B9zr0s2_6eG-oKZstYYLyAk9nt-mWRsb6ji
    mzzQluDU42H7fol>
X-ME-Received: <xmr:6i6-ZqnUqkZKuLs8kRyc9DHjZF2T79hciD0AdofVlxw7jLsENLfVR_rx7oUWA186V2CvikaqHcBJrGGHoECFB5GJ6geHtXrzCMyLRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddruddtiedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgg
    gfufhrfhfhvfgjtgfgsehtjeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhnuges
    uggvvhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpeffjeeiteduvdetkeeitd
    dvteeuvddttdegudefvdelieejgefggeetieejieegveenucffohhmrghinhepnhhfthgr
    sghlvghsrdhorhhgpdhkvghrnhgvlhdrohhrghdpthhhvghrmhgrlhgtihhrtghlvgdrug
    gvpdhnvghtfhhilhhtvghrrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepphhgnhguseguvghvqdhmrghilhdrnhgvthdpnhgspghrtg
    hpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhgvthhfihhlthgv
    rhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:6i6-ZhzOe3Cmf4BrMSut04u4NHy9qi-gbPQsE-fZbkxqBgC_jxLqkg>
    <xmx:6i6-ZkSu96WFdUePYh02ZnCVePxLvnNPzt4HkSXB-vsveFuj2UQVkA>
    <xmx:6i6-ZkbnnFDM-mzDqcpXD68QsGRTTUbAqM9AQPGLmjyEMtP38W3Ylg>
    <xmx:6i6-ZlTuvKX6MIh6vB3bmptF0zu0gvkhIYdXVsjTdOvbyCmLLDsFgg>
    <xmx:6i6-ZqNzdqhgyTV2XQ47aLDJYQxy5aWuzZXcTiUtCrZR8vVklc3iLoqY>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netfilter-devel@vger.kernel.org>; Thu,
 15 Aug 2024 12:38:02 -0400 (EDT)
Message-ID: <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
Date: Thu, 15 Aug 2024 12:38:01 -0400
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: correct nft v1.1.0 usage for flowtable h/w offload? `flags
 offload` &/or `devices=`
Content-Language: en-US, fr, de-DE, pl, es-ES
Reply-To: pgnd@dev-mail.net
References: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
From: pgnd <pgnd@dev-mail.net>
To: netfilter-devel@vger.kernel.org
In-Reply-To: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
X-Forwarded-Message-Id: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

('radio silence' on netfilter@ ML ... trying here)

i'm setting up nftables flowtable for h/w offload, per

	https://wiki.nftables.org/wiki-nftables/index.php/Flowtables
	https://docs.kernel.org/networking/nf_flowtable.html#hardware-offload
	https://thermalcircle.de/doku.php?id=blog:linux:flowtables_1_a_netfilter_nftables_fastpath
&
	a slew of older posts @ ML ...


on

	/usr/local/sbin/nft -V
		nftables v1.1.0 (Commodore Bullmoose)
		  cli:          editline
		  json:         yes
		  minigmp:      no
		  libxtables:   no

	uname -rm
		6.10.3-200.fc40.x86_64 x86_64


with

	lspci | grep -i eth
		02:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
		03:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)

	ethtool -k enp3s0 | grep -i offload.*on
		tcp-segmentation-offload: on
		generic-segmentation-offload: on
		generic-receive-offload: on
		rx-vlan-offload: on
		tx-vlan-offload: on
		hw-tc-offload: on

	(which, iiuc, is sufficient?)

a test config

	cat test.nft
		#!/usr/local/sbin/nft -f

		table inet filter {

			flowtable f {
				hook ingress priority 0;
				devices = { enp2s0, enp3s0 };
			}

			chain input {
				type filter hook input priority 0;
				policy accept;
			}

			chain forward {
				type filter hook forward priority 1;
				policy drop;

				ct state invalid drop;

				tcp dport { 80, 443 } ct state established flow offload @f;

				ct state { established, related } accept;
				accept;
			}
		}

fails conf check,

	nft -c -f ./test.nft
		./test.nft:8:12-12: Error: Could not process rule: Operation not supported
		        flowtable f {
		                  ^

otoh, per example @

	https://docs.kernel.org/networking/nf_flowtable.html#hardware-offload

edit

	flowtable f {
		hook ingress priority 0;
-		devices = { enp2s0, enp3s0 };
+		flags offload;
	}

passes conf check. and after load

	nft list flowtables
		table inet filter {
		        flowtable f {
		                hook ingress priority filter
		                flags offload
		        }
		}

what's the correct/current usage for flowtable declaration in hardware offload use case?
as documented @ wiki, or kernel docs?
_seems_ it's kernel docs ...


reading @,

	https://netfilter.org/projects/nftables/files/changes-nftables-1.1.0.txt

i don't find (yet) the change re `flags offload` usage.

what commit introduced it?


