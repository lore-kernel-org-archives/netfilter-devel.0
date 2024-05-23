Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674D1E535
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 07:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716448702; cv=none; b=o0eJySrOGYS9DB6xtkWH9vyMiC4iDv5XX7jTnXbz7b41VeAA94ksaZ2KidR54qBPH4Fc4MpdwcY1DhKIVanxhl5XBwnDJqsL4PGQuNfDGwZbF/YlPpiCmLgIEMphDQC7QuLUhNdeR4d23lff/H0EuSu9r8Arjcki/lBQoEEn9zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716448702; c=relaxed/simple;
	bh=veLVHX2Linaco3UUqh8LCT3zKtz7VmzvbBJhD40prAA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ghnBwoe80QyZJtzxzkx7/Q9wY31vZ+q69GM0GxQyduOB6BAUsbz/oam53GqMapY9Um6OLesbqac7R2IDbhyxEv+IuMF2qmrGLEXQc5NJwdbwvD/+b+J8FGRpXizK1+frvzVsxmYbS/g67sNEctjg5wkgY/OS/KG7YclovCeGNfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id E3CCBCC02BA;
	Thu, 23 May 2024 09:09:07 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu, 23 May 2024 09:09:05 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id A9201CC0113;
	Thu, 23 May 2024 09:09:05 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A3BDF34316B; Thu, 23 May 2024 09:09:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id A330234316A;
	Thu, 23 May 2024 09:09:05 +0200 (CEST)
Date: Thu, 23 May 2024 09:09:05 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Zhixu Liu <zhixu.liu@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] fix json output format for IPSET_OPT_IP
In-Reply-To: <CALMA0xYY-QzN+gbPTxNw3TJt3Rvm-vkN1yb4MgHs1Ey4TuEURw@mail.gmail.com>
Message-ID: <02acedac-3ec3-8b2c-0f27-30cf135be5de@netfilter.org>
References: <CALMA0xYY-QzN+gbPTxNw3TJt3Rvm-vkN1yb4MgHs1Ey4TuEURw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hello,

On Mon, 20 May 2024, Zhixu Liu wrote:

> It should be quoted to be a well formed json file, otherwise see following
> bad example (range is not quoted):
> 
>   # ipset create foo bitmap:ip range 192.168.0.0/16
>   # ipset list -o json foo
>   [
>     {
>       "name" : "foo",
>       "type" : "bitmap:ip",
>       "revision" : 3,
>       "header" : {
>         "range" : 192.168.0.0-192.168.255.255,
>         "memsize" : 8280,
>         "references" : 0,
>         "numentries" : 0
>       },
>       "members" : [
>       ]
>     }
>   ]

Thank you your patch. Please rework it and use a quoted buffer similarly 
to ipset_print_hexnumber() in order to avoid the many "if (env & 
IPSET_ENV_QUOTED)" constructs.

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
