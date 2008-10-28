From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Tue, 28 Oct 2008 14:50:25 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810281447540.9876@fbirervta.pbzchgretzou.qr>
References: <rlujt5-k63.ln1@tux.abusar.org.br> <49074E81.6010207@trash.net> <49075276.2686460a.0b00.ffff9f09@mx.google.com> <4907564D.5090103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54017 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbYJ1Su2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:50:28 -0400
In-Reply-To: <4907564D.5090103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-28 14:13, Patrick McHardy wrote:
>> 
>> 	The interesting is that this behaviour started at 2.6.25 kernel
>> version, but
>> I couldn't find anything that was changed between .24 and .25 to cause this.
>> Very strange.
>
> I have no idea why the log output is corrupted like this, but
> some things you could try:
>
> - use serial console, which should at least avoid any corruption
>  triggered by ringbuffer overflows. It many packets are logged
>  it will slow down your system considerably though.

JFYI, if it was a ring issue, the start of the string would be
overwritten, and not just random chars.
