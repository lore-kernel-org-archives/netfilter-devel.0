From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables RFC v3 PATCH 04/16] nft: Integrate nft translator
 engine in current core
Date: Mon, 12 Aug 2013 10:15:22 +0300
Message-ID: <52088B8A.8080007@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1376055090-26551-5-git-send-email-tomasz.bursztyka@linux.intel.com> <20130809212454.GA7102@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15089 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3HLHP0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:15:26 -0400
In-Reply-To: <20130809212454.GA7102@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> If I understood this correctly, your approach uses the array of
> instructions above as keys to look up for the corresponding parser. In
> that case, I'm afraid that this engine won't cover the complexity of
> the payload instructions since we'll end up having*a lot*  of matching
> combinations that will overlap in your tree. You cannot resolve that
> ambiguity problem of what parser needs to be invoked without looking
> at other information that is contained in the instruction, eg. payload
> base and offset.

It already handles overlapping patterns. I decided to go the simplest way:
- you can register as many parser you want for a pattern, of course.
- engine will try as many parser it has for a pattern as long as those 
return -1, the one who returns 0 wins (engine tries then to continue on 
next expressions, finding other patterns)
- engine follows longest pattern first: so if no parser as won on the 
current pattern, engine will start to go backward. (it will try to match 
shorter pattern)

Have a look at nft_trans_add_instruction(), 
retrieve_nft_trans_instructions() and execute_relevant_instruction() for 
insights.

Sure it's definitely not the most optimized but I believe it should be 
sufficient for our concerns.
And anyway, the API is good enough so the engine itself can be 
transparently improved if necessary.

Tomasz


