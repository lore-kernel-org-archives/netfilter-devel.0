From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Thu, 3 Mar 2016 15:18:45 +0100
Message-ID: <56D847C5.2030707@chello.at>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
 <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
 <20160302113411.GA2068@salvia> <56D6DB61.7070203@chello.at>
 <20160302125445.GA5129@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mart Frauenlob <mart.frauenlob@chello.at>,
	netfilter-devel@vger.kernel.org,
	Giuseppe Longo <giuseppelng@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-2.mx.upcmail.net ([62.179.121.149]:58758 "EHLO
	vie01a-dmta-at02-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733AbcCCOSt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 09:18:49 -0500
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1abU5W-0002PX-C5
	for netfilter-devel@vger.kernel.org; Thu, 03 Mar 2016 15:18:46 +0100
In-Reply-To: <20160302125445.GA5129@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.03.2016 13:54, Pablo Neira Ayuso wrote:
> On Wed, Mar 02, 2016 at 01:24:01PM +0100, Mart Frauenlob wrote:
>> On 02.03.2016 12:34, Pablo Neira Ayuso wrote:
>>> On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
[...]
>
> One idea is to push into iptables some infrastructure so the script
> can inquire iptables on available options. This would be simple C code
> to be places on every extension to print the options. Then, add a tool
> like iptables-completion that you can use to inquire what is possible
> to get as options. Thus, we get a generic script that inquires
> iptables, instead of having them all hardcoded into the script.

One more thing coming into my mind:
A new tool would not be backwards compatible.
While the shell completion could be used with old versions up to when 
the -S parameter was introduced. When commenting out some unsupported 
extensions in their definition array, it'll be suitable for vast parts.

