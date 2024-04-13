Received: from smtp0-kfki.kfki.hu (smtp0-kfki.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8381AAC4
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2024 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713016982; cv=none; b=HJ9kzfREhgpsigIx0M5u3GL47JG2Yqn2gqZVqNAMYoBJtWdrUs0zcDVSC97XPv9/eFPc/T7jOnAcVmOiQKiM17uML4+uapVo8JvtsjR5PtwmN9iBdMc1zT0bi3PiO6cY5sdyIH4LrD4Via28ooiouY4txBJZlYw/UHCpi5RpdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713016982; c=relaxed/simple;
	bh=MLveATyalszWDJouybyZHNkPpbgsJEAOONo6gz/QB2M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uvL943qHCnenK0aYvXkOEGHJMI+WcAwFpheC+QVhDLPU9UYVuajKSL3bWEwXm+Y8o80fUUNl7OA5HLg/ze4ClFOqZWpvt2huHLC7QV50TbcuYr7T3g+aDKyfQkyQEOtVf3eNRbsqaay4AcDu2c5X4lo/DdK9PQ7DQ+H4RKbFcxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id B0A3367400CA;
	Sat, 13 Apr 2024 16:02:54 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Sat, 13 Apr 2024 16:02:52 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (host-94-248-219-63.kabelnet.hu [94.248.219.63])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 5925567400E6;
	Sat, 13 Apr 2024 16:02:52 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id E0CC71D6; Sat, 13 Apr 2024 16:02:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id D62472A8;
	Sat, 13 Apr 2024 16:02:51 +0200 (CEST)
Date: Sat, 13 Apr 2024 16:02:51 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: keltargw <keltar.gw@gmail.com>
cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Incorrect dependency handling with delayed ipset destroy ipset
 7.21
In-Reply-To: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com>
Message-ID: <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org>
References: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 8%

On Sat, 13 Apr 2024, keltargw wrote:

> I have a problem with recent kernels. Due to delayed ipset destroy I'm 
> unable to destroy ipset that was recently in use by another (destroyed) 
> ipset. It is demonstrated by this example:
> 
> #!/bin/bash
> set -x
> 
> ipset create qwe1 list:set
> ipset create asd1 hash:net
> ipset add qwe1 asd1
> ipset add asd1 1.1.1.1
> 
> ipset destroy qwe1
> ipset list asd1 -t
> ipset destroy asd1
> 
> Second ipset destroy reports an error "ipset v7.21: Set cannot be
> destroyed: it is in use by a kernel component".
> If this command is repeated after a short delay, it deletes ipset
> without any problems.
> 
> It seems it could be fixed with that kernel module patch:
> 
> Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> ===================================================================
> --- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
> +++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> @@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
>   u32 flags = flag_exist(info->nlh);
>   u16 features = 0;
> 
> + /* Wait for flush to ensure references are cleared */
> + rcu_barrier();
> +
>   read_lock_bh(&ip_set_ref_lock);
>   s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
>      &i);
> 
> If you have any suggestions on how this problem should be approached
> please let me know.

I'd better solve it in the list type itself: your patch unnecessarily 
slows down all set destroy operations.

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
