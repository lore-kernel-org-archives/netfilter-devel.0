From: Patrick McHardy <kaber@trash.net>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Tue, 28 Oct 2008 19:53:37 +0100
Message-ID: <49075FB1.7050803@trash.net>
References: <rlujt5-k63.ln1@tux.abusar.org.br> <49074E81.6010207@trash.net> <49075276.2686460a.0b00.ffff9f09@mx.google.com> <4907564D.5090103@trash.net> <alpine.LNX.1.10.0810281447540.9876@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44030 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYJ1Sxl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:53:41 -0400
In-Reply-To: <alpine.LNX.1.10.0810281447540.9876@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-10-28 14:13, Patrick McHardy wrote:
>>> 	The interesting is that this behaviour started at 2.6.25 kernel
>>> version, but
>>> I couldn't find anything that was changed between .24 and .25 to cause this.
>>> Very strange.
>> I have no idea why the log output is corrupted like this, but
>> some things you could try:
>>
>> - use serial console, which should at least avoid any corruption
>>  triggered by ringbuffer overflows. It many packets are logged
>>  it will slow down your system considerably though.
> 
> JFYI, if it was a ring issue, the start of the string would be
> overwritten, and not just random chars.

I know, but judging by the few things that look like valid
LOG fragments, there seems to be more corruption than just
the ring buffer going on, so it might be worth a try.
I'd try nfnetlink_log first though.

