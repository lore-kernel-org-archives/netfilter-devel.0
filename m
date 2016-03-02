From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Wed, 2 Mar 2016 13:24:01 +0100
Message-ID: <56D6DB61.7070203@chello.at>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
 <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
 <20160302113411.GA2068@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:27527 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbcCBMYF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:24:05 -0500
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1ab5ov-0007ab-OT
	for netfilter-devel@vger.kernel.org; Wed, 02 Mar 2016 13:24:01 +0100
In-Reply-To: <20160302113411.GA2068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.03.2016 12:34, Pablo Neira Ayuso wrote:
> On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
>> This is a fully featured completion for ip[6]tables.
>> It knows about all the basic parameters and the options of all
>> targets and matches. Mandatory and exclusive options and inversion
>> of options are taken care of. Protocol dependency and previously
>> set values of options are also taken into account.
>> Completion of option values is done whereever possible.
>> Enviroment variables allow to modify completion behaviour.
>> As to feed ip address from file or to turn on input validation.
>> A readme file is included.
>>
>> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
>> ---
>>   utils/iptables_bash_completion/README.md |  290 ++++
>>   utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++
>
> This is fair good amount of work, but this is also quite a bit of
> new shell code to be maintained in our trees.
>
> Moreover, I was told that, in the specific case of debian, there is a
> package (bash-completion) where you place this.
>
> So sorry, I'm not applying this.

Hello Pablo,

what a pitty! :-/
Before writing this patch, I've asked the developers of bash completion 
for inclusion.
For them it's fair to big and specific to maintain.
They were worried about iptables becoming deprecated and them having 
dead code in their package.
The only chance for inclusion, and that's not granted too, is to 
additionally write a test suite with tools I don't have any knowledge 
about yet - and to sign up as maintainer there.
So they recommended me to request inclusion in iptables.

I think this is a good piece of work, probably the best featured bash 
completion ever, and I'd wish to get it distributed.
My abilities in that matter are limited.

Of course I'd keep fixing bugs and add new iptables features (though I 
think there are not many to expect in the future, right?).
If someone submits a bug report, I'll take care of it if anyhow 
possible. Just need to be notified by CC or so.

Thanks for considering.

Best regards,
Mart

