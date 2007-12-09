From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnl netfilter log
Date: Sun, 09 Dec 2007 17:09:23 +0100
Message-ID: <475C1333.7010507@trash.net>
References: <475A2987.8030505@trash.net> <475ADF79.1030204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, Thomas Graf <tgraf@suug.ch>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56241 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXLIQJx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:09:53 -0500
In-Reply-To: <475ADF79.1030204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:

>> Somewhat related, there currently is a problem with message
>> reception since libnl uses a page-sized buffer for recvmsg(),
>> but netfilter can send messages up to 64k. I recall there
>> was some recvmsg buffer size probing some time ago, but it
>> seems to be gone. Should I reintroduce it, increase the size
>> to 64k or make it configurable?
> 
> If you reintroduce the probing I think that something similar to the
> libnfnetlink behaviour would be fine. But, indeed, I prefer to make it
> configurable.


Me too, and maybe have it switch to 64k automatically once a
nfnetlink queue or log socket is opened.
