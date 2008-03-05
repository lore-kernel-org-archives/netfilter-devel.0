From: Patrick McHardy <kaber@trash.net>
Subject: Re: linux-2.4 CLASSIFY patch.
Date: Wed, 05 Mar 2008 17:45:39 +0100
Message-ID: <47CECE33.5030508@trash.net>
References: <Pine.LNX.4.64.0803051139270.26467@cube> <47CE8033.9020404@trash.net> <Pine.LNX.4.64.0803051354270.28409@cube> <47CEAF23.3050002@trash.net> <Pine.LNX.4.64.0803051558220.30939@cube>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: w@1wt.eu, netfilter-devel@vger.kernel.org
To: Unknown <borg@uu3.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:53821 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbYCEQpr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:45:47 -0500
In-Reply-To: <Pine.LNX.4.64.0803051558220.30939@cube>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Unknown wrote:
> CLASSIFY sources has been taken from:
> https://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/
> linux-2.6.11/CLASSIFY
> 
> On Wed, 5 Mar 2008, Patrick McHardy wrote:
>> Unknown wrote:
>>> On Wed, 5 Mar 2008, Patrick McHardy wrote:
>>>> If you send a patch against 2.4 I can review and ACK it.
>>>
>>> Done.
>>>
>>> Patch created against latest stable 2.4 tree: 2.4.36.2
>>> ftp://borg.uu3.net/home/borg/patch/linux-2.4-classify.patch
>>
>>
>> Please send as attachment and CC netfilter-devel@vger.kernel.org
>> and Willy Tareau.
>>


 > diff -ubrN linux-2.4.36.2.orig/Documentation/Configure.help 
linux-2.4.36.2/Documentation/Configure.help
 > --- linux-2.4.36.2.orig/Documentation/Configure.help	Sun Feb 24 
21:38:03 2008
 > +++ linux-2.4.36.2/Documentation/Configure.help	Wed Mar  5 13:48:19 2008
 > ...

Looks OK to me. In case Willy really wants to include it:

Acked-by: Patrick McHardy <kaber@trash.net>
