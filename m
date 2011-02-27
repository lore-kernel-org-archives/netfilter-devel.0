From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sun, 27 Feb 2011 16:22:30 +0100
Message-ID: <4D6A6C36.9050402@trash.net>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org> <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu> <4D698FCB.6060205@netfilter.org> <4D699421.4070309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34989 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1B0PW3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:22:29 -0500
In-Reply-To: <4D699421.4070309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.02.2011 01:00, Pablo Neira Ayuso wrote:
> On 27/02/11 00:42, Pablo Neira Ayuso wrote:
>> On 26/02/11 22:45, Jozsef Kadlecsik wrote:
>>> On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:
>>>> I have test it here, it works fine. Let me know if you're OK with it.
>>>
>>> The patch looks OK but I think Changli Gao is also right and it'd be 
>>> simpler to set the [reply][synack][SR] state to sIG. What do you think?
>>
>> I read his email before leaving and after I made the new patch.
>>
>> Indeed, his idea is simpler, here's a new patch. I tested it here, it
>> works fine.
>>
>> Patrick, please apply!
> 
> Hm, I forgot to include the description. New patch attached.

Thanks. I'll apply this tommorrow, assuming Jozsef is fine with
this version.
