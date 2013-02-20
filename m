From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set resize
Date: Wed, 20 Feb 2013 16:35:20 -0600
Message-ID: <51254FA8.3050407@akamai.com>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com> <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:60005 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412Ab3BTWfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:35:23 -0500
In-Reply-To: <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/20/2013 03:44 PM, Jozsef Kadlecsik wrote:
>
> That's a good catch and perfect patch.
>
> I'm just at the checking phase of the next release, which required a
> fairly large rewriting of the types - and which, as a side effect, fixed
> this bug. If I won't be able to release the rewritten version by the
> weekend, I'm going to apply your patch and release an interim version.

Thanks Jozsef.

Is there a git tree I could check out to look at the new changes? I'd be 
interested in seeing what you've done. Also, what was the motivation 
behind the large changes you're doing?

Thanks
Josh
