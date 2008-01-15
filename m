From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] generic CONNTRACK target
Date: Tue, 15 Jan 2008 07:40:01 +0100
Message-ID: <478C5541.9050809@trash.net>
References: <478B8B74.3070903@netfilter.org> <478B8DF1.3060503@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62614 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYAOGkH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:40:07 -0500
In-Reply-To: <478B8DF1.3060503@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> Attached an untested RFC patch [...]
> 
> I forgot to attach the patch...


This doesn't seem to actually consolidate any code, just put
it all in one file and dispatch based on the desired operation.
Whats the advantage over the existing modules?

Another issue is that it merges all conntrack-related targets
existing today, but as soon as we're going to add something
new we're going to run into compatibility issues again and it
will be easier to add a new module. I don't think the trouble
is worth it as long as we have to suffer our crappy userspace
interface.

