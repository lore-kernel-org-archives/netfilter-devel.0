From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 14:16:58 +0200
Message-ID: <47174EBA.5090903@trash.net>
References: <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl>	<4717359E.9020208@trash.net>	<Pine.LNX.4.64.0710181231210.17074@bizon.gios.gov.pl> <20071018.051252.71873220.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ole@ans.pl, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36142 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbXJRMR2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:17:28 -0400
In-Reply-To: <20071018.051252.71873220.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> From: Krzysztof Oledzki <ole@ans.pl>
> Date: Thu, 18 Oct 2007 12:37:42 +0200 (CEST)
> 
>>>> On Thu, 18 Oct 2007, Patrick McHardy wrote:
>>>>
>>>>> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
>>>>>
>>>>> Setting the last_dir parameter was missing from the previous one.
>>>> This description is IMHO wrong. It should be as in previous, little 
>>>> incomplete (last_dir), patch:
>>>>
>>>> "If one side aborts an established connection, the entry still lingers for
>>>> 10s in conntrack for the late packets. Allow to open up the connection
>>>> again for the party which sent the RST packet."
>>>
> Please sort out this changelog message issue so I can apply
> the patch correctly :-)


Please take the one from Krzysztof :)

