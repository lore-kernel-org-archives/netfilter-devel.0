Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6117C204
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724087651; cv=none; b=aV74IhESXe4/kMNtGJLTwP9pFi8cWRYdoP+rLxTB8K9suRft6Lg3kQlzfq34SWVcskiSciAU4101lmUA2MUZCvbXiuKPzkVy7ewZ1LsbKwFvburV4Zs8uVBlK6chv8r8isPR0b9sE8nTLRJrZsjt+6UgS9HdC2nVFHN22gVyFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724087651; c=relaxed/simple;
	bh=cxW1ova37a8Jti4mpZVyW0vtAh3AYulcOOqp4D5oAic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CM5/yLcmYRDjXPqwvCjAS62NDXM7pk7hRtVjRY0bN9DLMnknqPMFzOXJCBNh0H+SLlZl+CvTQ2C28JSVPuAe7Ab4tWZ8eEDIrNIwdxqc7ZB1S4Dcr5gFGOSNczFdnpNLzMv7YBC2LS38z5P1+lV0hRtNcFOoh6qfN84Y+QUNquk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51554 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg5xD-005cXu-IX; Mon, 19 Aug 2024 19:14:06 +0200
Date: Mon, 19 Aug 2024 19:14:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pgnd <pgnd@dev-mail.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Fwd: correct nft v1.1.0 usage for flowtable h/w offload? `flags
 offload` &/or `devices=`
Message-ID: <ZsN9Wob9N5Puajg_@calendula>
References: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
 <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
X-Spam-Score: -1.9 (-)

Hi,

Driver does not support this.

Not many drivers support this by the time I am writing this.

This infrastructure is attracting margial attention from driver
developers / hardware vendors.

It is frustrating.

Sorry.

On Thu, Aug 15, 2024 at 12:38:01PM -0400, pgnd wrote:
> ('radio silence' on netfilter@ ML ... trying here)
> 
> i'm setting up nftables flowtable for h/w offload, per
> 
> 	https://wiki.nftables.org/wiki-nftables/index.php/Flowtables
> 	https://docs.kernel.org/networking/nf_flowtable.html#hardware-offload
> 	https://thermalcircle.de/doku.php?id=blog:linux:flowtables_1_a_netfilter_nftables_fastpath
> &
> 	a slew of older posts @ ML ...
> 
> 
> on
> 
> 	/usr/local/sbin/nft -V
> 		nftables v1.1.0 (Commodore Bullmoose)
> 		  cli:          editline
> 		  json:         yes
> 		  minigmp:      no
> 		  libxtables:   no
> 
> 	uname -rm
> 		6.10.3-200.fc40.x86_64 x86_64
> 
> 
> with
> 
> 	lspci | grep -i eth
> 		02:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
> 		03:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
> 
> 	ethtool -k enp3s0 | grep -i offload.*on
> 		tcp-segmentation-offload: on
> 		generic-segmentation-offload: on
> 		generic-receive-offload: on
> 		rx-vlan-offload: on
> 		tx-vlan-offload: on
> 		hw-tc-offload: on
> 
> 	(which, iiuc, is sufficient?)
> 
> a test config
> 
> 	cat test.nft
> 		#!/usr/local/sbin/nft -f
> 
> 		table inet filter {
> 
> 			flowtable f {
> 				hook ingress priority 0;
> 				devices = { enp2s0, enp3s0 };
> 			}
> 
> 			chain input {
> 				type filter hook input priority 0;
> 				policy accept;
> 			}
> 
> 			chain forward {
> 				type filter hook forward priority 1;
> 				policy drop;
> 
> 				ct state invalid drop;
> 
> 				tcp dport { 80, 443 } ct state established flow offload @f;
> 
> 				ct state { established, related } accept;
> 				accept;
> 			}
> 		}
> 
> fails conf check,
> 
> 	nft -c -f ./test.nft
> 		./test.nft:8:12-12: Error: Could not process rule: Operation not supported
> 		        flowtable f {
> 		                  ^
> 
> otoh, per example @
> 
> 	https://docs.kernel.org/networking/nf_flowtable.html#hardware-offload
> 
> edit
> 
> 	flowtable f {
> 		hook ingress priority 0;
> -		devices = { enp2s0, enp3s0 };
> +		flags offload;
> 	}
> 
> passes conf check. and after load
> 
> 	nft list flowtables
> 		table inet filter {
> 		        flowtable f {
> 		                hook ingress priority filter
> 		                flags offload
> 		        }
> 		}
> 
> what's the correct/current usage for flowtable declaration in hardware offload use case?
> as documented @ wiki, or kernel docs?
> _seems_ it's kernel docs ...
> 
> 
> reading @,
> 
> 	https://netfilter.org/projects/nftables/files/changes-nftables-1.1.0.txt
> 
> i don't find (yet) the change re `flags offload` usage.
> 
> what commit introduced it?
> 
> 
> 
