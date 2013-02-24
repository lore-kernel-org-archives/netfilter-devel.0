From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set resize
Date: Sun, 24 Feb 2013 16:01:13 -0600
Message-ID: <512A8DA9.7060808@akamai.com>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com> <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu> <51254FA8.3050407@akamai.com> <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:53651 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758953Ab3BXWBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:01:16 -0500
In-Reply-To: <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/24/2013 01:52 PM, Jozsef Kadlecsik wrote:
>
> The support of the extensions attached to the set members required a
> reorganization. Until now just the timeout as extension existed. The new
> extension to be introduced is the packet and bytes counters per elements.
> It was mandatory to rewrite the handling of the extensions and the
> generation of the variants of a set type.
>

Very cool. I'll be very interested to try those out.

Thanks!
Josh

