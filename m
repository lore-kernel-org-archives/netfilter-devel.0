Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFB155756
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2024 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600141; cv=none; b=IieypffeZan/eSrR+kBLpQtf6P74TkR9uBJa2NvxFc/zyBxi3LXau3Ul/PlsUR3DCpDFypxXlOe1Bg5KSRDlfLIKs7KXeX7SR5DunqZxR+iptHat3Gr9hJgkGi1AHjhNzAen8SmMvNkeCdpICHWNus2NrUsMdjzjmPCT5OwM2pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600141; c=relaxed/simple;
	bh=uzg/661+WuFOVfio8nldwkWdeOTqr28aS/NUoSGeHd4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mCuFSI21Th+/QFJB/wDg4jkDIOuPbsqpsDp67vmmyYiCLnu/XPQ2xIe8JKLJSKiLeS9tl3nTT+yu5szwygcR9mR5KTFrHuDYgyAva0SAnBv79Rd202L4OY9+BwPv8ESPi9irJ9Y1yWXK8J9BcaMMnkQynJYUHzQSpXjPUbWAAqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Q03/9WV+; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Q03/9WV+"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0D22E32E0209;
	Thu, 19 Dec 2024 10:22:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1734600126; x=1736414527; bh=/NzK0abqtE
	R1c9SW2Qrr+NY8oi/CJ51oM8rCGuyFXs0=; b=Q03/9WV+jsRMWs9AIRW40klee1
	ZTV7VlDRymnuV34B9Tgn6qqNUqBIwtXY4MokAWrIp06YbMybAE2aRm/bhP5P124A
	f7qiNCbbPwe3GGklACRc2EL84bjq0W+obD9OXebPWE6EAqHZ6+GUC3bNJdS3eJQM
	c8fAdfiOIqTOeb/eM=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id RqkbLf3oO7KS; Thu, 19 Dec 2024 10:22:06 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id D9EB332E0208;
	Thu, 19 Dec 2024 10:22:06 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id CE45334316A; Thu, 19 Dec 2024 10:22:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id CCEBA343169;
	Thu, 19 Dec 2024 10:22:06 +0100 (CET)
Date: Thu, 19 Dec 2024 10:22:06 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
cc: netfilter-devel@vger.kernel.org
Subject: Re: Documentation oddity.
In-Reply-To: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
Message-ID: <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Wed, 18 Dec 2024, G.W. Haywood wrote:

> In the 'man' pages for 'ipset' on my systems, and at
>
> https://ipset.netfilter.org/ipset.man.html
>
> one sees
>
> [quote]
> netmask cidr
>    When the optional netmask parameter specified, network addresses
>    will be stored in the set instead of IP host addresses. The cidr
>    prefix value must be between 1-32. [...]
> [/quote]
>
> I've just used a value of 64 for an IPv6 set.  It seems to work. :)
>
> Have I missed something, or is the documentation in need of an update?

The manpage is uptodate - the webpage version was not refreshed.
Now it's done and it reflects the reality :-)

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu,
          kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
