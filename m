From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] nfnetlink: add netns support
Date: Wed, 13 Jan 2010 14:42:00 +0100
Message-ID: <4B4DCDA8.5070108@trash.net>
References: <20100113122420.GA5790@x200> <4B4DC469.5000408@trash.net> <20100113132255.GA16975@x200> <4B4DCA2C.7020000@trash.net> <20100113133727.GC16975@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab0AMNmD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:42:03 -0500
In-Reply-To: <20100113133727.GC16975@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Wed, Jan 13, 2010 at 02:27:08PM +0100, Patrick McHardy wrote:
>> Alexey Dobriyan wrote:
>>> On Wed, Jan 13, 2010 at 02:02:33PM +0100, Patrick McHardy wrote:
>>>> Alexey Dobriyan wrote:
>>>>> +	struct sock		*nfnl;
>>>>> +	struct sock		*nfnl_stash;
>>>> Shouldn't this be contained in an ifdef(CONFIG_NETFILTER_NETLINK)
>>>> (_MODULE) ?
>>> No, otherwise you won't be able to start using, e. g., nfnetlink_log
>>> module on NETFILTER_NETLINK=n kernels without reboot.
>> You mean after enabling CONFIG_NETFILTER_NETLINK?
> 
> Yes, and it can't be directly enabled, because it's hidden option.
> 
>> That seems like a pretty poor argument, you have to do a reboot after
>> changing a lot of config options.
> 
> It's still a step back if I add #ifdef and a regression if you ask me.
> The price is only two pointers per-netns.

Yes, I don't mind much, but I still think this is not an argument
at all. Whether you have to reboot after changing your configuration
has never been "stable" and we don't consider it when making changes.
