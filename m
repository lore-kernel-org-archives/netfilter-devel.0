Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73D01DA23
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 19:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758827773; cv=pass; b=hdRpxxxd2dgb3+Nq5FaCRFs8umCJAvDRsMw6yRzLvSK6FZKJVYj9z397m+7DKdY9OSPPDLJxYL6JqjpUiq56YoKozOnR1BFLcJx3AGaOTZBHqvDZv66SVS3EkONfGv7i0Tcf1iNpUp6NaL7g3QV2dkyaG3cCSGtwCt+4OdYx+6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758827773; c=relaxed/simple;
	bh=g+CSkkafYpO2aa32WnXg8s9+8Zt474mEK2f2DPGCIx8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TcB8EpZd1NKksXTdRyntLsro1YTmHg6UfszHs8NWOZaC/e8ABC+OcK8ebweXlE0GHcLNbqLLWUXuzppYkKw8bKt2ZOISJiaqrA85HKDBAUI7+e0nnl65TSpt7SRsb2VGl7WoB1CILNMO71CtarGrNQh4d9ORRipSwy8a2mcCJGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 0CB3D6A19D3;
	Thu, 25 Sep 2025 15:48:35 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-110-226-144.trex-nlb.outbound.svc.cluster.local [100.110.226.144])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 04B826A2269;
	Thu, 25 Sep 2025 15:48:33 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758815314; a=rsa-sha256;
	cv=none;
	b=grP9k/kW4DOWpQ/sioPc5WkReYjsHaplB54F2GuUYbr6n/yQZzs8bcs5dmLYyIzp74sk2T
	glMFvLHKHHtTYTBcfvhqh+W2zgj3xvaSBXXk+UQ5CqqpnS6qPdFkda+uoWsQ/JXe0MS7/l
	oyknSShl2BshT6PKHGB6XbStasD6QzpqdKgSkFVta7oRNGpRAP0kB+Z4TvA6FZR4HQmysF
	coO3WVp8qoKD38J00kx6gPZ+RlzulZ6Jh0XEnnG5bf4XveTnLnzSqVre79QbufTG4PeqvC
	VGTiVIziAK5XB64lVMqh8aDqrt9AD11+uLIqU5kNpG0wclPt34djeEYhWnGUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758815314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uETEg77LJfMyqHfqTeZ6vvDS3fjtqbpRrcCGP6pBaRs=;
	b=ZuV3H4MjpgL3AYetOIne+PIiv6IFQb8TdQU8iNEAnQpcspm8+2wJVFw+Cad+/xJpVQSfRb
	i3iUg6sPs3wuWrz6qqXhb/3n+AWItX2tYAcH2JwgXZHrgJQnTX+MKZzAsVYQai4SLppmLd
	mTganToG3EbVy5DmInkbNxWYAfX5ANezRv5oxNSrL2Vah7uiF3vTR6ZI8+Zf1fay5yyY8M
	pXZ/DgAlcOP5KsXVvIJqcXXmVeu0vcU7qSF2Pp2GLL79azn74eXmkE38CuI9TabEBH25UH
	S0tfWJV7PFj9Tj7J8xetHzYAxqGJguejstD/6AhDub0cp06yJL3HMGCh8IFgYA==
ARC-Authentication-Results: i=1;
	rspamd-55b8bfbc7f-z882k;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Inform-Arithmetic: 744437b16d911218_1758815314700_1978673800
X-MC-Loop-Signature: 1758815314700:1090377521
X-MC-Ingress-Time: 1758815314700
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.226.144 (trex/7.1.3);
	Thu, 25 Sep 2025 15:48:34 +0000
Received: from [79.127.207.171] (port=2337 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1oCw-00000009SCb-0pzU;
	Thu, 25 Sep 2025 15:48:32 +0000
Message-ID: <c825ad4a7e7318d211fcbb419b1003d063dc702c.camel@scientia.org>
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>, 
	netfilter-devel@vger.kernel.org
Date: Thu, 25 Sep 2025 17:48:30 +0200
In-Reply-To: <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
	 <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Thu, 2025-09-25 at 14:36 +0200, Fernando Fernandez Mancera wrote:
> 2. Introduce a new "--numeric-interface" which prevents resolving iif
> or=20
> oif.

What IMO would be most helpful for users is an option, which for all
values simply causes the "real" value to be printed.

With "real" I mean:
- if e.g. an ip daddr matches on 1.1.1.1, then print 1.1.1.1
- if there were an ip domainname where netfilter would resolve, the
  that option should print the hostname
- if using iifname, the actual matched value is the string, so print
  that
- if using iif or oif, the actual matched value is the ID, so print
  that, in particular as (perhaps with the exception of lo), e.g. eth0
  isn't per definition ID 2 or whatever


For things like ICMP Type codes, IP protocol numbers, port numbers...
things are different to e.g. the iface ID.
For them, e.g. type 0 is always guaranteed to be icmp echo request and
22 is always port SSH.


So it could IMO be handy to have an option which gives the above
("real") but still uses non-numeric values for things where the
number<->string is fixed, and if one uses the option e.g. twice, then
even those are printed with their numeric values.


Cheers,
Chris.
