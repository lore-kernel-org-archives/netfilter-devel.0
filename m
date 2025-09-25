Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D6F2E8B6B
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 21:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758835278; cv=pass; b=URDbtBiWFvun5Uen1JsDUb5r/DE3RRuS9VgBmKCO8R2pjIFCheseiv0KOO/RF72JY96ed6mDt5JwJaZlbi+ZNMBxT0Vl66m39+RO8T5T/eNLVCbDa93w/Smbm4y6Ci0KWJ6Hw8y3Iv+o28cP3KAsYZO+n1Pl2vWigvcBre6Mjvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758835278; c=relaxed/simple;
	bh=X+6N/QtouMbT/KpK4qUCoy/Lg3Wf8uAmMlXd62MUjJE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K2huvSfYS1FkAp+0+vWzsJTWZpWxbsR0WnMN3Ryxz2ddyy1+RkUOi2mcHrCiLRd25YKJlUjYqX8epx/xKTZuKQ4PmTQRNkE6z1XUc9nMt0uJlemxRQsaUOv3I5BgaiJhAQhGPHZPklm2EdP4UeYUwDmjj7cL/8bgmTuZ9REmgZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C83282622F5;
	Thu, 25 Sep 2025 20:44:11 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-6.trex.outbound.svc.cluster.local [100.109.34.94])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id CFF05261F06;
	Thu, 25 Sep 2025 20:44:10 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758833051; a=rsa-sha256;
	cv=none;
	b=P2Eaqb+mpLOg8eG5m45GBK7IOJ7odHC1Opc9FDor5hWkH8SHY8iISvLd++ks0aar9BnzHp
	H3jGxLWbs+yQMDwKwqbCXAd9TK5/g+4qW+PXxTf6QPsROcMiUik320La2S+30AqzT5fD3r
	K92LUsuUOZRAvSQBArnaZC7ard3+TnAJ0umymsu/UpwANVL4VkSc9GiXyMWwvzk9Qj6RYQ
	Of9iOitsfrUTUvCRM64dWx9nAwpROXgFk3TwPZAZUCs7RWvAVzvobxn2PbKACFd0IjNP0a
	u0lkPuXlopxY2LKTQfJpRvaZKf3r3tL1WePDyVTIIpjGgsLTQl+zfTLsXuxK5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758833051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+6N/QtouMbT/KpK4qUCoy/Lg3Wf8uAmMlXd62MUjJE=;
	b=SI4sIl/XsrMi2VvaVMGcHA85KDpwSlEJYeq6C1RhlAOalBJ4tr7snIgXoest3dP/DdY/+a
	9I2zg1VuAk/DErjBwIlcqvLJGPB0aTmx5YN/HglPuge8KKtSRTjn30e6ECjrwO5L6Qxf7r
	KK696styiDO5ruNT2eWqz1unDEheLZJC3qbiGb5+ZZiq9UYQKkODjZz4L75RJtuBvuzN29
	/NSWvMH7I+qShccNdcCpDzLt9XIHQjJ6Q3tyGFECx2TTjE+73s4mCDyIbijzFb6VA5qRwu
	vt/vdmXyHD2S3VR8A/iHoI8iDN9sEj6j1m9HLgeWuNdYruRA0z/MMUjOEMpO9w==
ARC-Authentication-Results: i=1;
	rspamd-65bb85d4cc-x4xzv;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cure-Wide-Eyed: 7c20430518e2427e_1758833051510_2336590795
X-MC-Loop-Signature: 1758833051510:1300289812
X-MC-Ingress-Time: 1758833051510
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.34.94 (trex/7.1.3);
	Thu, 25 Sep 2025 20:44:11 +0000
Received: from [79.127.207.161] (port=62665 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1sp0-0000000Ag4Q-17ZZ;
	Thu, 25 Sep 2025 20:44:09 +0000
Message-ID: <a14a19376e165796b8b4989fec1739a830c4b2e5.camel@scientia.org>
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Date: Thu, 25 Sep 2025 22:44:06 +0200
In-Reply-To: <aNVxqaP7iZpeMh6S@strlen.de>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
	 <aNVUxFz1RDsu7wuk@strlen.de>
	 <658f160530a48d923a345334fca2729c879762de.camel@scientia.org>
	 <aNVxqaP7iZpeMh6S@strlen.de>
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

On Thu, 2025-09-25 at 18:45 +0200, Florian Westphal wrote:
> Sure, only when renamed.=C2=A0 When you remove it raw value is shown
> and it won't match anymore.

Still, when explicitly using --numeric, which one can expect to show
the real values that are matched, and it still shows the string,...
then I guess it's easy for people to wrongly expect that it would
actually match on the name.


> Sure but why do you use iif with a interface that gets removed in
> between?

Well, *I* don't, but given the number of examples floating around that
use iif/oif I guess it's safe to assume that many users might not
realise.

And I'd have argued that the whole point of a --numeric is to show the
real values, that are actually used for matching.
Except that for values where the names are statically defined, I'd have
argued one could use a double -n to make them print the real numbers.


Aynway... not a big deal.


Cheers,
Chris.
