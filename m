From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set resize
Date: Thu, 21 Feb 2013 00:46:52 +0100
Message-ID: <20130220234652.GA5060@localhost>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com>
 <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Hunt <johunt@akamai.com>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:33923 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143Ab3BTXq5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:46:57 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Wed, Feb 20, 2013 at 10:44:18PM +0100, Jozsef Kadlecsik wrote:
[...]
> That's a good catch and perfect patch.
> 
> I'm just at the checking phase of the next release, which required a 
> fairly large rewriting of the types - and which, as a side effect, fixed 
> this bug. If I won't be able to release the rewritten version by the 
> weekend, I'm going to apply your patch and release an interim version.

My suggestion is to apply the fix first so we can pass this to -stable.

Let me know. Thanks.
