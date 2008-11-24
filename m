From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 17:08:36 +0100
Message-ID: <492AD184.1050403@trash.net>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net> <20081124152458.GA20442@linuxace.com> <492AC919.7070005@trash.net> <alpine.LNX.1.10.0811241653370.15363@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Shane Goulden <shane@matrixau.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34116 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYKXQIq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:08:46 -0500
In-Reply-To: <alpine.LNX.1.10.0811241653370.15363@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-11-24 16:32, Patrick McHardy wrote:
>>> I've seen these messages when something other than FTP is utilizing
>>> port 21.  Perhaps we should have a bit in the conntrack helper which
>>> stops looking on future packets if it doesn't see FTP traffic in the
>>> beginning of the session?
>> That would make sense, but I can't see a good way to make this
>> decision except maybe when we seen non-ascii characters. But
>> even that will fail with different encodings. Do you have a
>> good idea?
> 
> Well, each packet (or rather, every new line) should be a "123 " code,
> followed by whatever text plus a newline.

Right, that should work. If someone wants to cook up a patch,
I have no objections :)

