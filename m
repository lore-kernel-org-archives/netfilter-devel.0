From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 16:32:41 +0100
Message-ID: <492AC919.7070005@trash.net>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net> <20081124152458.GA20442@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Shane Goulden <shane@matrixau.net>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33371 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYKXPcx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:32:53 -0500
In-Reply-To: <20081124152458.GA20442@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Mon, Nov 24, 2008 at 01:28:09PM +0100, Patrick McHardy wrote:
>> Rusty Russell wrote:
>>> On Monday 24 November 2008 10:43:19 Shane Goulden wrote:
>>>> 2.6.18-92.1.10.el5xen
>>>>
>>>> FTP is working. Is there a way to easily silence the messages?
>>> Not that I am aware of.  Perhaps that printk (still there in latest 
>>> kernels) should be downgraded to a DEBUG?
>>>
>> Its strange that FTP is apparently working since we drop those packets.
>> I'm not sure about downgrading that message, its there to inform the
>> user of an exceptional action (dropping of packets within conntrack).
>>
>> Shane, how do you trigger those messages?
> 
> I've seen these messages when something other than FTP is utilizing
> port 21.  Perhaps we should have a bit in the conntrack helper which
> stops looking on future packets if it doesn't see FTP traffic in the
> beginning of the session?

That would make sense, but I can't see a good way to make this
decision except maybe when we seen non-ascii characters. But
even that will fail with different encodings. Do you have a
good idea?


