From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 13:18:07 +0100
Message-ID: <4B866A7F.7070205@netfilter.org>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jiri Pirko <jpirko@redhat.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab0BYMSh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:18:37 -0500
In-Reply-To: <4B864F9A.90207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jiri Pirko wrote:
>> Hi all.
>>
>> I want to ask if there is any particular reason for ipt_CLUSTERIP to support
>> only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
>> even with another types of network hw with different addr_len.
> 
> None that I'm aware of, but the length is also used in the ABI,
> so you presently can't supply larger addresses.

Not directly related to this but I wanted to discuss this time ago. Now
that we have xt_CLUSTER I think that we can deprecate ipt_CLUSTERIP.

With regards to this issue, it seems arptables only support EUI-48 (6
bytes) for ethernet addresses, so xt_CLUSTER would inherit the same
problem but the point would be to fix arptables (not sure if possible
now without breaking ABI or adding some versioning like iptables).
