Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39283AD531
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774010038; cv=none; b=SbJpCAD3dEH/DaxoolQus3zHbdLmQOMeMBxAK3w/MOca5DrB2INFOn1HaRjZlVehJAr8+1VPDfFGUh9/cOX6m+mPxN3OGtI/UeEbLwSPLituzfC8PwzxNCkvJTcz5WehVbnwIWXTXuwXcI53sXB2VJMQ2XuAcKs+A3tbWbGqIkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774010038; c=relaxed/simple;
	bh=z2eKuIR0URmIl3tkSfaOKj9CZrpgz1ZBW1qz+ooCI0k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gSLd7Kh5GbrdlbgC0oPtknse0H+ow/BAnRdkn9h1N9ZYJOLF90GN/vKrfV6umoVdsseJgbByq+AlM/AvH/M1rPWG6yQj3B6paO2nXX8WZ2V/HpJlj+g4wHlByqdu0XsXKdV99Z40VrXBF25NgPPbwDChFo0bWjvK9Q6XlIWwaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fchnY4kq3z7s85S;
	Fri, 20 Mar 2026 13:33:53 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id W3OB7r-Bnym8; Fri, 20 Mar 2026 13:33:51 +0100 (CET)
Received: from mentat.rmki.kfki.hu (unknown [148.6.192.8])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4fchnW2mdLz7s84c;
	Fri, 20 Mar 2026 13:33:51 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 4194A140DF3; Fri, 20 Mar 2026 13:33:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 3D97114010F;
	Fri, 20 Mar 2026 13:33:51 +0100 (CET)
Date: Fri, 20 Mar 2026 13:33:51 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] netfilter: ipset: Fix data race between add and list
 header
In-Reply-To: <ab03vtQI7WWq9puC@strlen.de>
Message-ID: <fb95d5cd-3e85-212e-7dae-dcbf7d79d268@netfilter.org>
References: <20260320114041.3486273-1-kadlec@netfilter.org> <ab03vtQI7WWq9puC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 20 Mar 2026, Florian Westphal wrote:

> Just to be sure, is this nf-next or nf material?

I was unsure about it, because of the missing reproducer I could not 
verify the fix.
 
> And, what do you make of:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260313180132.75655-1-davidbaum461@gmail.com/
> and
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250722153205.4626-1-phil@nwl.cc/

For both patches:

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Thanks for reminding me about the pending patches!

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
