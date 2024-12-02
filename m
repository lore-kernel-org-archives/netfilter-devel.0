Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78341FA167;
	Mon,  2 Dec 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733137882; cv=none; b=WUdfR0fkwTDMO9iwD0Qpob1nYHpYni6XM4I96NyEY1MTJHvyEnhVKGPszyRGEPseh23MIHF+Hw8PSaAS2yi1Q/ZRk3duSaroS3dYcCN60r25JP9gkHcnLX0hdh7DyBqvMrwS6Uzv7hH/fh2feKbnMFvAiB6s3RVvdtFkw1BJJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733137882; c=relaxed/simple;
	bh=sQlY9ZcRDmTiTXinK2DlHWEK9pxEuVYAimddKiRGj5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RqcBW8avDxZbghKvl+ul0ObiiLm02Bb+4Oo4tJ6nGi8glUWjwohoyhdft7I4zdtSHzyHJHZ0fZoPEXYfW5XnjG5VwlkF9RDp+JKzvWUwFmojOcoF2AeaMWvUHd2v1VFzKgHD44tsnjPZ+KE5Ei6gXGj4adloFvCL3LM84S6T1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I70wTbJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I70wTbJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA32DC4CED1;
	Mon,  2 Dec 2024 11:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733137881;
	bh=sQlY9ZcRDmTiTXinK2DlHWEK9pxEuVYAimddKiRGj5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I70wTbJMs1xHUDqFnMkZOFHsaelBP5M3f+rUcgIZCggH1c7dske+VfQF4p+SfD3mz
	 vxTm73qA57U3wR0CfqKuzp7tQ1K8ngPTZTkb56b4ndDvwkXP3udL1VYWh7KSmnZfNI
	 8hv+8azXAUaieNJ3Oj5+OZ/iPskWr/AfbiJzZki8=
Date: Mon, 2 Dec 2024 12:11:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 4.19.y 1/1] inet: inet_defrag: prevent sk release while
 still in use
Message-ID: <2024120254-glare-crust-e398@gregkh>
References: <20241125205944.3444476-1-saeed.mirzamohammadi@oracle.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125205944.3444476-1-saeed.mirzamohammadi@oracle.com>

On Mon, Nov 25, 2024 at 12:59:37PM -0800, Saeed Mirzamohammadi wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit 18685451fc4e546fc0e718580d32df3c0e5c8272 upstream.

Ok, but then you say:

> (cherry picked from commit 1b6de5e6575b56502665c65cf93b0ae6aa0f51ab)

Can't have it two different ways :(

Please fix up properly.

thanks,

greg k-h
