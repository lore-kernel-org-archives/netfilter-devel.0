From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] ipset patches
Date: Mon, 16 Jan 2012 13:45:59 +0100
Message-ID: <20120116124559.GB13131@1984>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36604 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2APMqW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:46:22 -0500
Content-Disposition: inline
In-Reply-To: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 14, 2012 at 05:38:53PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Here follow the patches which bring the kernel in sync with the current
> ipset release. I included the patches which was sent in September but was
> forgotten due to the kernel.org issues. Please consider applying them.
> 
> Best regards,
> Jozsef
> 
> Jan Engelhardt (3):
>   netfilter: ipset: use NFPROTO_ constants
>   netfilter: ipset: avoid use of kernel-only types
>   netfilter: ipset: expose userspace-relevant parts in ip_set.h
> 
> Jozsef Kadlecsik (5):
>   netfilter: ipset: Autoload set type modules safely
>   netfilter: ipset: Dumping error triggered removing references twice
>   netfilter: ipset: Log warning when a hash type of set gets full
>   netfilter: ipset: Exceptions support added to hash:*net* types
>   netfilter: ipset: hash:net,iface timeout bug fixed

Thanks Jozsef. I'll take this once. net-next becomes active again
(after -rc1 is released).

It would *really* great if you can set some git tree I can pull
your changes from.

I suggest you to base it on my net-next tree:

http://1984.lsi.us.es/git/net-next/

Create some branch, say 'ipset' and pile your changes there. Then,
send me the git URI so I can pull them. I will appreciate it.

If you don't find the time to make it, I'll manually apply them.

Let me know.
