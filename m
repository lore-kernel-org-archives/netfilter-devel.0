From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 15:08:29 +0100
Message-ID: <49C251DD.3020309@trash.net>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr> <49C24EC7.3020402@trash.net> <alpine.LSU.2.00.0903191456190.27642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36163 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZCSOIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:08:36 -0400
In-Reply-To: <alpine.LSU.2.00.0903191456190.27642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-03-19 14:55, Patrick McHardy wrote:
>   
>
>> Object files are a completely different questions. We've had tons of crap
>> in there for unmerged patches that we did later merge and had to change
>> the API, which caused "breakage" for people.
>>     
>
> Yes, but we can, and specifically I do, expect Pablo to fabricate
> something better, more consistent, and which has been reviewed with
> regard to the 'guideline checklist' than the unreviewed rotting
> bits that used to be in the past POM tree.
>   

I do to, but I don't see why we should risk it. Its just as well possible
that someone testing it thinks of a great feature that would perfectly fit
in, but needs ABI changes. The -rc phase is for testing and also fixing
and changing things, releasing userspace before the kernel part is set in
stone is unnecessarily reducing the short amount of time we have for this.
