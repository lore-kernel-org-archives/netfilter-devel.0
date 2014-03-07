From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] ipset patches for nf-next
Date: Fri, 7 Mar 2014 11:48:37 +0100
Message-ID: <20140307104837.GB11150@localhost>
References: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47272 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaCGKsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:48:47 -0500
Content-Disposition: inline
In-Reply-To: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 06, 2014 at 10:23:40AM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next series of patches:
> 
> * Follow the manual page behavior for the SET target at list:set
>   type of sets when the set contains both inet and inet6 type of sets,
>   from Sergey Popovich
> * Fix coccinelle warnings about 0/1 return values instead of false/true,
>   from Fengguang Wu
> * Introduce the hash:ip,mark hash type from Vytas Dauksa
> * Add markmask option to hash:ip,mark type from Vytas Dauksa
> * Prepare the kernel for create option flags when no extension is needed
>   from Jozsef Kadlecsik
> * Fix ABI breakage by the markmask option patch, from Florian Westphal
> * Move registration message to init from net_init from Ilia Mirkin
> * Add forceadd kernel support for hash set types from Josh Hunt.
> 
> You can pull the changes from
> 
> 	git://blackhole.kfki.hu/nf-next master

Pulled, thanks Jozsef.
