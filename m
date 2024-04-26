Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E0C823DC
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2024 05:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714110307; cv=none; b=lNSJSsy0tnuBdpGJnhnESD657Akgrxgmhkfojq/BNUrTh/GjsN6aZ+rJoPNvmPgTG/n4PZDEyp/+EB4ndrRKMD9Dt++2VmRfVMfcdI7HldhOO8BTdc1zVZ0GaKuaxrmHdFjw6Frzw2pNeRYiKV4Ya51whKa/NbwWQ417jHatMLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714110307; c=relaxed/simple;
	bh=x5fCGmKPiA2lffgM7W4p4nLMa6fGYMsWURoEzbEwQpU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6eLlcT3Zo2tKKlPSfR1nQ6vfvnBLCV7j8al5U+n67vzeujbqSD4GbPWrnjXA9WQrwTUy8lqU04yxuZwxG04JuMl1G4w5XL/YlC2JwzAOCLvo1eMmYGFyF+iLr/L4QBNIiSZATEEy0yc8PmDMhOgA5Axoj2/1+h08Hw8NgQMj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SP5ZhtsD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SP5ZhtsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714110305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azkTO+VrLcVY1n/gUdPW60eiZibK6orDA9NsUrpoA1A=;
	b=SP5ZhtsDxOPl75AYEGcd9fOjfY3Kt/ErzqQl0s+h66maEHPUt8l3Dv+fh6Jgump5BIa1L4
	7Zu8P7KqLnr1DBGFW2SYxxzXnp49KwTng6PmdWwyhvtP0V+xyVXnO/VRh3JU9gaTqhMH56
	9CFs9sKgCd2meGDIkcol6Qnsa9ZeuCQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-Kv7egY6pMbeActDKzknGRg-1; Fri, 26 Apr 2024 01:45:01 -0400
X-MC-Unique: Kv7egY6pMbeActDKzknGRg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a558739aaf4so111129866b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 22:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714110299; x=1714715099;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azkTO+VrLcVY1n/gUdPW60eiZibK6orDA9NsUrpoA1A=;
        b=lY6VBpfo2jje4KtaYLjy76eO5CRbP4Lp71rmOPvPjk3VxQM5nJQahRJ5u0Lwg3rafG
         uZPUd4XlJERovadQhIauVyzngmCdfoSz/eVS9/VM2UGuAvIy1TMZXAbyVWPxbOwdsKX9
         WjtjHwc3FFQ17Hyi4B5hVTIakALZWEXoI2CIGHp7v28ifdy27F17WePoQQ6nCDZQ49wx
         ohraYLz40dFnw+mTflhyFjKxhQof++A0ygCVgHl7z8bHTai0HAq2rPijoTH1ErWmZS/d
         SgKCMPqO1J0QdRZehKjlHxlqBKEswr5k+Fw68hnfTL079E5CmbhWim3B5LPnN6hq9e3u
         MOzA==
X-Gm-Message-State: AOJu0YxSI80jMSJx2E0quLm2rUpZwm360VBIyr4lK6ERNaZP3UFqO7a1
	+fdwofS85GoUFqz620GSbi+qm/jJqAdLYCC4N8Xu418Jzmjx8o9VxCcf325Y+BK++rHsGjT9MuE
	DgwBfsPWS/8Q7R+VQPbmp4BvIqMFTt4Kzi4/8MDKNinxMoZpEL4QLS9Y37msI9i+8c2nc0gqEcZ
	c/
X-Received: by 2002:a17:907:bb97:b0:a51:dcda:dcde with SMTP id xo23-20020a170907bb9700b00a51dcdadcdemr1415724ejc.70.1714110299412;
        Thu, 25 Apr 2024 22:44:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnJEtZSzwzILllMwrOgkK7+s1tYR7+R6jxbh5gcp5tKi+9HD8Nzf6YxIB0g+sbGRZao8FjKQ==
X-Received: by 2002:a17:907:bb97:b0:a51:dcda:dcde with SMTP id xo23-20020a170907bb9700b00a51dcdadcdemr1415674ejc.70.1714110298344;
        Thu, 25 Apr 2024 22:44:58 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id dv25-20020a170906b81900b00a58befa5d9fsm1003237ejb.69.2024.04.25.22.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2024 22:44:57 -0700 (PDT)
Date: Fri, 26 Apr 2024 07:44:24 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 4/8] netfilter: nft_set_pipapo: prepare walk
 function for on-demand clone
Message-ID: <20240426074424.670803cf@elisabeth>
In-Reply-To: <20240425120651.16326-5-fw@strlen.de>
References: <20240425120651.16326-1-fw@strlen.de>
	<20240425120651.16326-5-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 14:06:43 +0200
Florian Westphal <fw@strlen.de> wrote:

> The existing code uses iter->type to figure out what data is needed, the
> live copy (READ) or clone (UPDATE).
> 
> Without pending updates, priv->clone and priv->match will point to
> different memory locations, but they have identical content.
> 
> Future patch will make priv->clone == NULL if there are no pending changes,
> in this case we must copy the live data for the UPDATE case.
> 
> Currently this would require GFP_ATOMIC allocation.  Split the walk
> function in two parts: one that does the walk and one that decides which
> data is needed.
> 
> In the UPDATE case, callers hold the transaction mutex so we do not need
> the rcu read lock.  This allows to use GFP_KERNEL allocation while
> cloning.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

