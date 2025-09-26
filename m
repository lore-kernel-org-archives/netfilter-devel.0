Received: from indigo.cherry.relay.mailchannels.net (indigo.cherry.relay.mailchannels.net [23.83.223.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D138DE1
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853276; cv=pass; b=gTkHn83agn6YxNb6DWV3YVJCtODX0NcCJF/T8WbBTazm/kuGnOPT3M2/hJUxf5QDB3AyJZkW/4GOPRckvb42/tCo6eHSEwcC67dJlUJeupUwtn2rQz+qskg6WCm5V22c6CPEghvbbajwjVLa9qH6nQ4A8J4wZyMI3+qJcMHjyaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853276; c=relaxed/simple;
	bh=q8GyBVBNiurWDV87tvkhzT61H11bJM4oK8Cvue3H3RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiwcfHaaR37cWG6eLX4LvaZI3K3YD24yGL+ZPnMPiatUW3XFU5Mb85H+NhRf14vCFAH8zzHXHKNaWKG877TbpWKHFRUykcMl4MLqxkrZw61gptVbBygGjHsxmSlzvnfppriHz42x8iOaYuuPIjbC5kL+MnIDMeG9haZj67k+lT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7676C70153E;
	Fri, 26 Sep 2025 02:11:48 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-110-207-248.trex-nlb.outbound.svc.cluster.local [100.110.207.248])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A0FC970099B;
	Fri, 26 Sep 2025 02:11:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758852708; a=rsa-sha256;
	cv=none;
	b=D1bA/tT7SDWuSLfkivhd9N9RFLoD2uQwJ4m4/ejHhzGw/8PYB/Mzt4DFLq0ERfRqDS9Rp/
	5rrm8E9q/ypEat0EiHAoImzVyDPOh0ICSjHy1+ottkUplCWQefd0hq9euGuedWixkuCkMG
	jwuJedAQ+XIDmdnySulTZXDHnPlx5VDACZXmFRYWOfoiqFmfisQma417irZTopcV15WVxL
	oW3A8ILokSYTkjisRJOAaWB9NG62dH5Zygr0vcZIZwJ9outH3yJcBIdsQggczfxsVaeDKC
	Egpg61IdeedmVW3xkSpNA+/WW1xTrp0iJlUr3x0UeOj69PBS8Yj635bx5wrfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758852708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9DKVscIvttBMiYpaTPtFVfiFS7YO1IqiE9suwUMlTA=;
	b=dRV+k8qd5GbsMUIoPogm3adDEBgQoBcCRGAzlUwYby8zPdknnoIJujJyF7NTIB1gEFta2/
	Gr0vQoNGcZg1RY6Y3HxLpRXWBazA6NcjhLp021EuZU5cAeky/WLMhxMClXMSTPglWlu5Db
	PsWhG7Ri+YZOpy8eoPs7jN1X2wvEx3wnJI4+jNp/Ko+exOOZZzKT+4lxqCg15ZdryzMVno
	FS8ccCJ4RdJYmYkCzrFrtV1prJAqzB+6c1qtijjKLRxS9Fs7ePwxiOasKl7BBVUkHLGk24
	KPXGKr06x3f9myYLG9OOynU79NF2ba1+m31BUgZ9V/Chbxi3nauJRBfAGvDwXw==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-v4hsc;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Wide-Eyed-Shoe: 590ee30b36e42855_1758852708332_2185684610
X-MC-Loop-Signature: 1758852708332:4270706667
X-MC-Ingress-Time: 1758852708331
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.207.248 (trex/7.1.3);
	Fri, 26 Sep 2025 02:11:48 +0000
Received: from [79.127.207.161] (port=17102 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1xw3-0000000CeCd-3ljj;
	Fri, 26 Sep 2025 02:11:46 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id 84F7155FB50E; Fri, 26 Sep 2025 04:11:44 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] doc: miscellaneois improvements
Date: Fri, 26 Sep 2025 03:52:42 +0200
Message-ID: <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aNTwsMd8wSe4aKmz@calendula>
References: <aNTwsMd8wSe4aKmz@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Hey.

On Thu, 2025-09-25 at 09:35 +0200, Pablo Neira Ayuso wrote:
>  for your lengthy notes, it is easier for us if you send us
> dividual patches for each issue that can be reviewed.
> 
> is is more work on your side, but less work on us to digest this
> ngthy notes.

Well... I didn't really want to O:-) in particular as I'm at best a nftables
noob, but here you go.

Please consider these more a RFC and someone who really knows how things work
should throughly review and better double check.

While I did try to test most of the claims I make... that was a bit difficult for
some others and I might have made things up.
And even if something works as observed, it may still not be as it should be.

With respect to my original mail[0], the patches of this series should cover the
following points with the following things where I'm unsure what do do:
 (2): [PATCH 1/7] doc: clarify evaluation of chains
 (3): [PATCH 2/7] doc: fix/improve documentation of verdicts
      HELP NEEDED: does queue work like drop, i.e. immediatey end any further
                   evaluation?
 N/A: [PATCH 3/7] =?UTF-8?q?doc:=20minor=20improvements=20with=20respec?=
      HELP NEEDED: In these lines:
                   https://git.netfilter.org/nftables/tree/doc/nft.txt?id=98e51e687616a4b54efa3b723917c292e3acc380#n520
                   https://git.netfilter.org/nftables/tree/doc/nft.txt?id=98e51e687616a4b54efa3b723917c292e3acc380#n757
                   https://git.netfilter.org/nftables/tree/doc/nft.txt?id=98e51e687616a4b54efa3b723917c292e3acc380#n826
                   I don't know whether ruleset should be replaced by rule.
 (4): [PATCH 4/7] doc: add overall description of the ruleset evaluation
      HELP NEEDED: queue verdict is missing, see above
 (5): [PATCH 5/7] doc: add some more documentation on bitmasks
 (6): [PATCH 6/7] =?UTF-8?q?doc:=20describe=20include=E2=80=99s=20colla?=
(11): [PATCH 7/7] doc: describe how values match sets

I don't know the answer to my original point (12)

Also, I can't do any patches for the wiki, so I'll happily leave that up to you,
i.e. my original points (7-11). O:-)
Same for the "teaching" point (13), I think that should be done by someone who
really knows what he's doing.

Cheers,
Chris.

[0] https://lore.kernel.org/netfilter-devel/3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org/T/#mb4387c098ee8cfec0baffecb42a7dfbac518adf7


