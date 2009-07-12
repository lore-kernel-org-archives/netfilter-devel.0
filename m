From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: TPROXY / DIVERT
Date: Mon, 13 Jul 2009 10:22:53 +1200
Message-ID: <f5c0fcbe39b48cd430b31abeb0d0c046@mail.treenet.co.nz>
References: <4A543BB2.5080906@treenet.co.nz> <4A572C20.8020807@treenet.co.nz> <20090712171702.GA1668@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:44255
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZGLWW4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:22:56 -0400
In-Reply-To: <20090712171702.GA1668@sch.bme.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 12 Jul 2009 19:17:02 +0200, KOVACS Krisztian <hidden@sch.bme.hu>
wrote:
> Hi,
> 
> On Fri, Jul 10, 2009 at 11:55:12PM +1200, Amos Jeffries wrote:
>> Amos Jeffries wrote:
>> >TPROXY is turning out alright for most of our users. The iptables and 
>> >kernel changes seem to work perfectly. Thanks a lot guys.
>> >
>> >We are just working our way through how it needs to fit into various 
>> >other network toolchains and re-documenting.
>> >
>> >
>> >Two netfilter relevant questions have arisen:
>> >
>> >The old one: How long until IPv6 TPROXY support is available?
>> >
>> >
>> >The new one: How to configure TPROXY on a bridge?
>> >
>> 
>> Alright Nevermind the bridge Q. has been resolved now.
> 
> Cool. What was the problem?

Broken NIC drivers on the test machine. :(

> 
>> The IPv6 Q. is still open. hint, hint :)
> 
> As far as I know noone is working on this. Theoretically, shouldn't be
too
> complicated, though.
> 
> I'll try to look into this once I find the time.

I keep hearing that, but don't have anywhere near the knowledge level or
time to follow up myself. Thank you for anything you can do towards this.
There seem to be a fair number of people seeking it.

AYJ
