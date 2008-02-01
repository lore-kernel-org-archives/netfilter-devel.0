From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 17:47:36 +0100
Message-ID: <47A34D28.2010303@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de> <47A2E256.6080600@trash.net> <47A320A4.3030203@netfilter.org> <47A34696.5070109@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39557 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753036AbYBAQr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:47:58 -0500
In-Reply-To: <47A34696.5070109@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso wrote:
>> * Default hashtable size reduced to 512, why?
> 
> You are still talking about the ulogd-NFCT-plugin.diff, right?  Please
> comment on the version as it is at the end of the patchset.

Sorry, I don't understand your patchset logic since I have to apply them
all to understand what you want to do, this is confusing.

>> * This patch checks if every conntrack exists in the kernel every N
>> seconds to handle overruns. Instead, why doesn't it wait for ENOBUFS in
>> the recv buffer and, then try to resync to kernel?
> 
> This is one of the future improvements I've only queued locally.  As
> this isn't critical I suggest to wait for that.

The point is that I don't understand why we have to apply these NFCT
patches which IMO do a sloppy netlink handling and then wait until this
is completely rewritten again properly... (continue below)

>> * ct_hash_find_seq is O(n). Overruns sometimes happen because the CPU
>> reaches 100% consumption, so if it can't backoff, this function won't
>> help that much in those cases.
> 
>  [ULOGD RFC 15/30] NFCT: add sequence cache
> 
> That patch was provided exactly to solve that issue.

... because AFAICS if we check for ENOBUFS and then resync against the
kernel table using GET_CONNTRACK we won't need the sequence cache later,
will we?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
