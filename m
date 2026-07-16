Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5162C0F69
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211444; cv=none; b=OXcQLap0bOtX/DVtKFG42llCGNPXlwMsDmRcfMiPgGMm2R9a72q4DIziXeBtBEckaVGLR6EL2vw1gc+bp9otB3+CbTuDkF5yXnBfd47Q2MJYDIlL7WfD6mQjC43ltPiZG5/3a3NRqnnzQTh47NBHhtL+v9ZheJrvTzEHUCcDOO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211444; c=relaxed/simple;
	bh=TqzIqU2RtDFj7G25hBc9Pmx6AiRHNXviAn5cD3MVXMo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Gz09RvIjvgRkxAY49sfaty975KwhUF1mC3e1OqE8cQbs/nYs3lIwiF69IJTqY8TVOCTmFTiCxHrm+qjK2iG9umnRmdBZT+Pg89unhL+EhXvyVhcp/fTuxZ2WetMM5OkNmiSJWymNE7fm/oe6cihtdSOSd8ah0xb10EutvH/RTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=UPuIUm/j; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="UPuIUm/j"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1FVT33ZnzGFDCH;
	Thu, 16 Jul 2026 16:17:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784211439; x=1786025840; bh=/Nka9/Xtrv
	SvFNt5FfIzA8XHwMZDChSUmu5gp2HL6ZY=; b=UPuIUm/j/YFi6Q8KYREJrY2esW
	o3kxr1G49s4Q9HEkZ4dlmjeTVbhTi2w29YSsNAeVJ3XfzsVDrWZn8fvgOn9lzbRR
	6wxAVgFNFFYY3iffGh5UMoUeH7dfu73qdGjkf+0jp9EIpqgT4fMLumHbAq0SojuK
	7JxZBdNmhHBkdjvjw=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ihcFS1f4LD8z; Thu, 16 Jul 2026 16:17:19 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1FVR3CzczGFDCG;
	Thu, 16 Jul 2026 16:17:19 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 6134634316E; Thu, 16 Jul 2026 16:17:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 5FF6534316D;
	Thu, 16 Jul 2026 16:17:19 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:17:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 11/12] netfilter: ipset: remove last region
 lock usage
In-Reply-To: <aljl4IafjFKZpMDy@strlen.de>
Message-ID: <9350a546-bde0-e858-f034-9b16e651b072@blackhole.kfki.hu>
References: <20260714131828.10685-1-fw@strlen.de> <20260714131828.10685-12-fw@strlen.de> <6111cb97-d92e-814b-3224-ba7b42bdcb5d@blackhole.kfki.hu> <aljl4IafjFKZpMDy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 16 Jul 2026, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
>>> Move lock responsibility into kadt/uadt/flush callbacks and remove the
>>> last .region_lock users.
>>
>> Why move the set->lock locking into the callbacks? As now all types use it,
>> it'd be easier to keep it in core and not replicate it in all callbacks.
>
> Ideally the hash types would never use it (or only for comment
> extension) for delete/add.

The comment string is kept in struct ip_set_comment_rcu. The whole mess 
about the extension was due to resize copying the pointer of the wrapper 
struct ip_set_comment while ongoing gc could happen. However resize is 
gone now. Re-add from userspace can change the comment string but it can 
nicely be handled with rcu. So as far as I see ext_size remains to be 
solved and the hash types could remain lockless.

Best regards,
Jozsef


