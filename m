From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: conntrack-tools unknown protocol search by number
Date: Mon, 06 Oct 2008 15:46:16 -0500
Message-ID: <48EA7918.10503@astrocorp.com>
References: <48E6952B.5090905@astrocorp.com> <48E7396F.1010107@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([64.122.215.18]:21465 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYJFUnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:43:24 -0400
In-Reply-To: <48E7396F.1010107@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yeah, I can add support for the other protocols.

-Bryan

Pablo Neira Ayuso wrote:
> Hi Bryan,
>
> Bryan Duff wrote:
>   
>> Now instead of "conntrack -L -p tcp" you can do "conntrack -L -p 6" -
>> useful for "unknown" proto's like gre, ah, esp.
>>     
>
> Thanks for the patch. I have rework it a bit, the new patch is attached.
> I'll push it to git if nobody complains.
>
> BTW: udplite, dccp and sctp support are missing, in case that you want
> to contribute something else. You'll also have to add the missing bits
> into libnetfilter_conntrack.
>
>   

