From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 12:29:50 +0200
Message-ID: <4717359E.9020208@trash.net>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain> <20071018101200.28424.26306.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33848 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761594AbXJRKaP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:30:15 -0400
In-Reply-To: <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> 
> 
> On Thu, 18 Oct 2007, Patrick McHardy wrote:
> 
>> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
>>
>> Setting the last_dir parameter was missing from the previous one.
> 
> This description is IMHO wrong. It should be as in previous, little 
> incomplete (last_dir), patch:
> 
> "If one side aborts an established connection, the entry still lingers for
> 10s in conntrack for the late packets. Allow to open up the connection
> again for the party which sent the RST packet."


The first patch was submitted seperately with a somewhat similar
description. This is just the incremental fix.
