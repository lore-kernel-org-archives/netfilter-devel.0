From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Subject: Re: DCCP conntrack/NAT
Date: Tue, 8 Apr 2008 14:38:41 +0100
Message-ID: <20080408133841.GA31174@gerrit.erg.abdn.ac.uk>
References: <47F64C0D.5080700@trash.net> <20080407215017.GB8682@gerrit.erg.abdn.ac.uk> <47FAA40D.7010905@trash.net> <20080408092717.GB6265@gerrit.erg.abdn.ac.uk> <47FB4962.60300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:44182 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbYDHNiq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:38:46 -0400
Content-Disposition: inline
In-Reply-To: <47FB4962.60300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> I have a question regarding the original direction - currently it is
>> linked to the client which actively initiates a connection. DCCP  
>> suffers from the problem that peer-to-peer NAT traversal is not
>> really possible just because of this client/server division. There
>> is a proposal which effects a pseudo simultaneous open, by letting
>> the server send an initiation packet, to fix this problem (TCP
>> peer-to-peer NAT traversal also favours simultaneous-open). I wonder
>> if this would be possible, but it is really a future-work question.
>
> Yes, that should be possible. But how does the server know that
> the client intends to initiate a connection?
>
This is outside the actual NAT implementation, via out-of-band, e.g. using SIP
or Session Traversal Utilities for NAT (draft-ietf-behave-rfc3489bis).

In this regard, the role-reversal patch will be a great help, since it
will allow support for peer-to-peer NAT traversal (i.e. NAT-ed server).


The University of Aberdeen is a charity registered in Scotland, No SC013683.

