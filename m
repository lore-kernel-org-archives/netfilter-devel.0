Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94F41DDED
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784206450; cv=none; b=csxGCdhwx2eIiW3PbhdmZmRb1dPtMciX+phFa0iCtO43cWimbazcfeCuD869wkaBOegmirTjteEY9mfLtSXneU/1edp3kUD5vdKK/HARyu+P/sk1Z279+zBeiWGIbqrLrxF9SoUM3EWK5Z428t5SlqmZOmyCd16i4o/YRpknmCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784206450; c=relaxed/simple;
	bh=Z2HjNFJhzWBdrJOo3cDzn9xRYpBX+AEUFoYbm+nYtvY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fWNbasNR7KavD9c7+2kv3R9n9lJYa5NJwIu4q3QPi8QxCbPDazgGk/qC5GIfYjC+ikncIaD62QmiTj2YYb0l05tiN6oSsP0+lFPP1zs5TWUE/XVxXKMX0gY7H2grA1N7kd+z7+F1NEaYVD8BZqn3e2/F/gsrvt367Vkn7vuPiOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Dv4H/WUt; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Dv4H/WUt"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4h1CfF3VTCz3sb0S;
	Thu, 16 Jul 2026 14:53:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784206435; x=1786020836; bh=VMty472EDc
	D7Diu9ibAQNI3iggGGMNjz2JX5vYtTmfo=; b=Dv4H/WUtBtYNbv7BiwIzZ1bhJ5
	rP9GyKSDdRAgfGpEJI2pHm8mV6G/oKdxIYW9qNpbNV9yD61Npsd05BnNi835HX+4
	+pD4yG7D4pscWe78IpjHhdYKDBCijX9ZdSSPutoWDceXJgvvHtV7Aa0VgIzjmrat
	+McVbxoedA5qBZ4/I=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id nf96ntgt6WYm; Thu, 16 Jul 2026 14:53:55 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4h1CfC1gP5z3sb0N;
	Thu, 16 Jul 2026 14:53:55 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 2B4E734316E; Thu, 16 Jul 2026 14:53:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 2A1A734316D;
	Thu, 16 Jul 2026 14:53:55 +0200 (CEST)
Date: Thu, 16 Jul 2026 14:53:55 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 07/12] netfilter: ipset: add rhashtable
 boilerplate stubs
In-Reply-To: <20260714131828.10685-8-fw@strlen.de>
Message-ID: <8c03ba3c-f438-3dc4-f01b-f536c4c79217@blackhole.kfki.hu>
References: <20260714131828.10685-1-fw@strlen.de> <20260714131828.10685-8-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Tue, 14 Jul 2026, Florian Westphal wrote:

> Preparation patch.  Adds an rhashtable to the set and initialised
> and destroys it.  No elements are ever added to this hashtable.
>
> This change is supposed to be devoid of side effects and is
> separate to reduce size of the conversion patch.
> +/* 0 = key matches object (equal), non-zero = not equal */
> +static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
> +{
> +	const struct mtype_rht_elem *e = obj;
> +	u32 multi = 0;
> +
> +	return !mtype_data_equal(&e->elem,
> +				 (const struct mtype_elem *)arg->key, &multi);
> +}

It does not belong to this patch, but the "multi" arg of 
mtype_data_equal() is needed only for the netiface type: it supports the 
same ip/cidr behind multiple interfaces but the element can store a single 
interface only. The "multi" flag made possible to take into account 
multiple interfaces properly when growing the array in the hash.

The interfaces should be stored in a linked list at element level and the 
"multi" arg of mtype_data_equal() can be removed, which is not needed in 
rhashtable anyway.

Best regards,
Jozsef

