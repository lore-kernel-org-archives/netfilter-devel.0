Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98AC1F0E34
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 10:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426809; cv=none; b=JCsA0eiOcnoRSwVjoM81aPgRNu/kLWXlxD7E1QX4IiWA1mIgmfNuQLyGLqhqO+JLNhYq/ml7duteOhQS54j1Tpilw8CRxaS1EtVbG7fI2a/1I23bRPey6ifSHV1arZpvgdSi6QIxHYZXeBwIM1QLn5IEQC24EhzePzAe2IhlYNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426809; c=relaxed/simple;
	bh=cfxwduF5YioqAXqtf88N2gSVBd5XFgzGSkD7Dhxe8qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X+VkymgubUspl207YgHVKZtrTRLx3dAni3ednaTn2cWiYAtNknfpA3JlZ+VNGt+WIYXDpDXauTajcWcl/kbIjbyw6qHIu0B21DH4R6jLICCErHYvOosl+tmfQeW8OiqpIjDpRgmZxxsiReBwWh/E8YM21gJ9r20Cq/LsKoOXTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=T2SGxJh8; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="T2SGxJh8"
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4b6lMv0847zDqBC;
	Wed, 28 May 2025 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
	t=1748426363; bh=cfxwduF5YioqAXqtf88N2gSVBd5XFgzGSkD7Dhxe8qs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T2SGxJh8Jyk7sm0rcLGej6SGNCgal/Q036JicXgWQe5dIxwBti9thSMFq0QW6lPnl
	 2T7YwPrlPco3IvuYjQYj4Q8s3xTLwW/E7Hdx+HXMVP6yhCAeoLqRTRIPLMBz1CCCm5
	 XPk009L07t0t5uiyqrpQrvVJSUb0jvmlmU4F//SA=
X-Riseup-User-ID: 1DBDA10919F74721B7462169633FC2C8520A6263341DC83575BA578D4858556D
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4b6lMq6vbvzJswZ;
	Wed, 28 May 2025 09:59:19 +0000 (UTC)
Message-ID: <26ea02a2-d1b1-451f-9b1c-f1d27c591b4c@riseup.net>
Date: Wed, 28 May 2025 11:59:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7 nft] tunnel: add erspan support
To: Florian Westphal <fw@strlen.de>,
 Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 Pablo Neira Ayuso <pablo@netfilter.org>
References: <cover.1748374810.git.fmancera@suse.de>
 <ae88d3525c46a523e1b8a0b97450225804033014.1748374810.git.fmancera@suse.de>
 <aDZcyv8zZJh-fpzB@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
In-Reply-To: <aDZcyv8zZJh-fpzB@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/28/25 2:46 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>> This patch extends the tunnel metadata object to define erspan tunnel
>> specific configurations:
>>
>>   table netdev x {
>>          tunnel y {
>>                  id 10
>>                  ip saddr 192.168.2.10
>>                  ip daddr 192.168.2.11
>>                  sport 10
>>                  dport 20
>>                  ttl 10
>>                  erspan {
>>                          version 1
>>                          index 2
>>                  }
>>          }
>>   }
> 
> Would it make sense to make this
> 
> tunnel erspan y {
>                   id 10
>                   ip saddr 192.168.2.10
>                   ip daddr 192.168.2.11
>                   sport 10
>                   dport 20
>                   ttl 10
>                   version 1
>                   index 2
> }
> 
> Or was the sub-section intentional to cleanly separate the common parts
> from the tunnel specific knobs?
> 

The sub-section was to cleanly separate it and easily understand what 
are the tunnel specific options configured.

> In that case, maybe 'tunnel y {
> 	...
> 	type erspan { ... '?
> 
> Or do you think its unecessarily verbose?
> 
> I think it might be good to make it clear that this is an either-or thing
> and multiple 'type' declarations aren't permitted.
> 

IMHO, adding "type erspan {" won't hurt but I thought it was clear 
enough. If you think adding the "type" keyword makes it clearer, I can 
do it for sure.

Please, notice that if more than one specific sub-section is set, the 
bison parser will complain.

> Or are there plans to support
> 
> table netdev x {
>         tunnel y {
>                 id 10
>                 ip saddr 192.168.2.10
>                 ip daddr 192.168.2.11
>                 sport 10
>                 dport 20
>                 ttl 10
>                 erspan {
>                         version 1
>                         index 2
> 	       }
> 	       geneve {
> 		...
> ?

I do not think there are plans to support this at all.

