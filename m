Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97685259CA5
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378896; cv=none; b=TjwApAbtcJZmjnG/CdUFSG1qp3hzDLQZVtLrvwSOaEFfZACoop4wXdhpBUpAi0fCGI4QtaxlLXDXWu7Q5Z28XsyKxmszq0JWrxAEYvDN0QpKzA3sXGAyj2aF2T/oslKdSZ3g4HZBcJyd0AVSHC8EHqab+Mb4anQLOhWNxE6KzMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378896; c=relaxed/simple;
	bh=hk5OVtzUI/3IZIHbx/d7uO7ZuMyUzshxUVc4jzJGI8s=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=i8WhcvufQBfc6tJOBdtFosUtn/csr5m1d7daLrHF/a5xodvJEWWxU2cm1pIanJal9f5ZNf//1cwAp2uYm954iGGT37/VtIGEtaRYj7I7NRH7NahfL8hXb9XT+W0fGczQ81ZrEe1xzLepUreAo8qcwlJ01Nndu1dwluoEx1LdH3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4cllT83gB2zGFDLn;
	Mon, 13 Oct 2025 19:58:36 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Ii-N55pWCSAn; Mon, 13 Oct 2025 19:58:34 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (77-234-80-199.pool.digikabel.hu [77.234.80.199])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4cllT64B06zGFDLk;
	Mon, 13 Oct 2025 19:58:34 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 64FF41405B6; Mon, 13 Oct 2025 19:58:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 60A10140539;
	Mon, 13 Oct 2025 19:58:34 +0200 (CEST)
Date: Mon, 13 Oct 2025 19:58:34 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Ata Yardimci <atayardimci97@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [libipset] lifetime & reuse of context from ipset_init()
In-Reply-To: <CAGE3PDpNxA6eY_0Eo9Hj7anxtE9QMhAi3FUT5QONLvXnZ0Xk9Q@mail.gmail.com>
Message-ID: <bc3a9ae7-5c95-8fe0-b7d2-2dadff0d64ef@netfilter.org>
References: <CAGE3PDpNxA6eY_0Eo9Hj7anxtE9QMhAi3FUT5QONLvXnZ0Xk9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 1%

Hi,

On Mon, 13 Oct 2025, Ata Yardimci wrote:

> I am using libipset in an application that continuously keeps the ipset 
> context active and accepts events from outside to issue commands to 
> ipset, this way I avoid opening a new process for each task.
> 
> I supplied modified error function pointers to ipset_custom_printf to 
> avoid the exit() call after an error, to keep the process running. 
> Mostly it runs fine, I tested it with many basic commands.
> 
> However I also encountered various problems during my tests, some of 
> which I may report as a bug, others, I have to ask about the intended 
> usage instructions first.
> 
> My questions are,
> 1-) Does this library aim to support executing many ipset commands 
> without exiting the process? (I guess it does but the exit() in 
> default_custom_error confused me)

Yes, it is supposed to send as many commands as required.

> 2-) If it does, are you supposed to reinit the ipset context after each 
> error?

Yes, because errors are assumed to be fatal: it is hard to judge whether 
the error means a failure to enforce a firewall policy or not. Therefore 
the safer approach is used: the human must decide about how to fix it.
 
> In my tests, I found the library to be quite usable for issuing many 
> ipset commands with the same context even after errors, but needed some 
> tweaks like resetting the output buffers after an error, or handling an 
> extra packet arriving at the Netlink channel and such.
> 
> According to the reply, I will understand which of these I should approach
> as a bug or intended behavior.

Please send your bugreports, better use the netfilter bugzilla. There can 
be easily bugs in libipset which simply didn't occur while used by ipset 
itself.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
