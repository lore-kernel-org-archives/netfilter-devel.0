From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Tue, 22 Jul 2014 15:49:58 -0500
Message-ID: <53CECE76.2070200@akamai.com>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:32188 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363AbaGVUzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:55:03 -0400
In-Reply-To: <1406004850-31336-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/21/2014 11:54 PM, Josh Hunt wrote:
> Below is a first pass attempt at fixing a problem we've come across when
> trying to do an iptables-restore where the hashlimit name stays the same, but
> one of the hashlimit parameters changes but does not take affect.
>
> For ex, if you have an existing hashlimit rule, do an iptables-save, change the
> rate for that rule, and then do an iptables-restore the new rate will not be
> enforced.
>
> This appears to be due to a problem where hashlimit only checks for existing
> hashes by name and family and does not consider any of the other config
> parameters.
>
> I've attempted to fix this by having it check for all hashlimit config params,
> this way it doesn't accidentally match just on name. This brought up an issue
> of having to make hashlimit aware of how many references there are to its
> proc entry.
>
> I'm not submitting this for inclusion yet, but for feedback. Mainly on the approach
> and if there's possibly a better way of resolving this problem. My handling of
> the proc "problem" is pretty messy right now and possibly incomplete, but the
> patch below allows the case I described above to pass now. I hope to clean up
> the proc handling in a v2.

I just realized that what I'm doing with the proc stuff isn't going to 
work, but feedback on the other portion is still appreciated.

Thanks
Josh
