From: Patrick McHardy <kaber@trash.net>
Subject: Re: DCCP conntrack/NAT
Date: Tue, 08 Apr 2008 16:26:02 +0200
Message-ID: <47FB807A.3000605@trash.net>
References: <47F64C0D.5080700@trash.net> <20080407215017.GB8682@gerrit.erg.abdn.ac.uk> <47FAA40D.7010905@trash.net> <20080408092717.GB6265@gerrit.erg.abdn.ac.uk> <47FB4962.60300@trash.net> <20080408133841.GA31174@gerrit.erg.abdn.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40678 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYDHO2u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:28:50 -0400
In-Reply-To: <20080408133841.GA31174@gerrit.erg.abdn.ac.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gerrit Renker wrote:
>>> I have a question regarding the original direction - currently it is
>>> linked to the client which actively initiates a connection. DCCP  
>>> suffers from the problem that peer-to-peer NAT traversal is not
>>> really possible just because of this client/server division. There
>>> is a proposal which effects a pseudo simultaneous open, by letting
>>> the server send an initiation packet, to fix this problem (TCP
>>> peer-to-peer NAT traversal also favours simultaneous-open). I wonder
>>> if this would be possible, but it is really a future-work question.
>>>       
>> Yes, that should be possible. But how does the server know that
>> the client intends to initiate a connection?
>>
>>     
> This is outside the actual NAT implementation, via out-of-band, e.g. using SIP
> or Session Traversal Utilities for NAT (draft-ietf-behave-rfc3489bis).
>
> In this regard, the role-reversal patch will be a great help, since it
> will allow support for peer-to-peer NAT traversal (i.e. NAT-ed server).

This sounds like it would already work when using the netfilter
SIP helper. But the DCCP_LISTEN method is a lot simpler.

