From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Tue, 27 Nov 2007 20:04:02 +0100
Message-ID: <474C6A22.9080202@trash.net>
References: <474C4B67.3000200@trash.net> <Pine.LNX.4.64.0711271942330.20371@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41368 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbXK0TEO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:04:14 -0500
In-Reply-To: <Pine.LNX.4.64.0711271942330.20371@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 27 2007 17:52, Patrick McHardy wrote:
>> I have a large number of pending patches for iptables for new
>> matches and targets. I'm not going apply patches for new things
>> unless they are at least in a -rc kernel, so we have a chance to
>> fix mistakes. So my question is whether we're ready to release
>> the current iptables -rc anytime soon (before/when 2.6.24 is
>> released) or whether we're more likely going to need until 2.6.25,
>> in which case I would apply them now.
>>
>> Any opinions?
> 
> Apply now, make an rc2 (maybe?),
> apply more gems (coming), target 2.6.25,
> be done :-)


I'm aiming for one release per kernel release to get new stuff
out in time for testing. Unfortunately we're already way behind,
so I'd prefer an earlier release than 2.6.25. My feeling is that
the current -rc works well, so if nobody is aware of any big
issues, I think we should release the current version in a few
weeks when 2.6.24 comes out.
