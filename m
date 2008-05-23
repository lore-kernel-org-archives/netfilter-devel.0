From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [0/3] conntrack event kernel issues
Date: Fri, 23 May 2008 12:32:28 +0100
Message-ID: <4836AB4C.8030304@gmx.ch>
References: <1211447573.6878.36.camel@pumper.lan.luxnet.ch> <48369678.7000905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750830AbYEWLcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 07:32:31 -0400
In-Reply-To: <48369678.7000905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>> patch1: export ct->status on all conntrack events
>> patch2: set SEEN_REPLY before destroying a conntrack on TCP RST
>> patch3: new status flag SEEN_RELATED
> 
> I can't imagine other uses for this than the one you described,
> especially for 2 and 3. Patch 3 also adds code in a hot path,
> so unless someone can present good arguments in favour of these
> patches, I don't really want to apply them.

This is what I had expected. Especially for patch 3 I know that it's 
very unlikely to be integrated because of its limited use and the 
changes it makes.

For not exporting the connection status on a destroy event I see no 
reason. The information is there and should be exported. Might also be 
interesting to have the EXPECTED or ASSURED flags.

Then there is this thing with the TCP RST. I think, that the event data 
should be accurate. If the status is returned (with patch 1), then it 
should have the SEEN_REPLY flag set. Another issue is that the 
accounting counters are not updated. IMHO this should be done as well 
(is not in my patches).
