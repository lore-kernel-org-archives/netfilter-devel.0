From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 07:24:58 -0800
Message-ID: <20081124152458.GA20442@linuxace.com>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Shane Goulden <shane@matrixau.net>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:54600
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752379AbYKXPbj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:31:39 -0500
Content-Disposition: inline
In-Reply-To: <492A9DD9.1090307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2008 at 01:28:09PM +0100, Patrick McHardy wrote:
> Rusty Russell wrote:
>> On Monday 24 November 2008 10:43:19 Shane Goulden wrote:
>>> 2.6.18-92.1.10.el5xen
>>>
>>> FTP is working. Is there a way to easily silence the messages?
>>
>> Not that I am aware of.  Perhaps that printk (still there in latest 
>> kernels) should be downgraded to a DEBUG?
>>
> Its strange that FTP is apparently working since we drop those packets.
> I'm not sure about downgrading that message, its there to inform the
> user of an exceptional action (dropping of packets within conntrack).
>
> Shane, how do you trigger those messages?

I've seen these messages when something other than FTP is utilizing
port 21.  Perhaps we should have a bit in the conntrack helper which
stops looking on future packets if it doesn't see FTP traffic in the
beginning of the session?

Phil
