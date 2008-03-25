From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 16:22:46 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803251607450.9368@fbirervta.pbzchgretzou.qr>
References: <925A849792280C4E80C5461017A4B8A226A01E@mail733.InfraSupportEtc.com> <47E90307.2060802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Greg Scott <GregScott@InfraSupportEtc.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52200 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYCYPWr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:22:47 -0400
In-Reply-To: <47E90307.2060802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-03-25 14:49, Patrick McHardy wrote:
> Greg Scott wrote:
>>
>>  It could be something in the order of execution changed.  I'm using
>>  RedHat kernels right now and I know they tweak the kernels a little bit.
>>  But surely the RedHat guys would not change something this fundamental?
>
> No, that was us :) Bridge-netfilter used to defer the IPv4 OUTPUT

Do you have the commit id at hand? Was it
2bf540b73ed5b304e84bb4d4c390d49d1cfa0ef8?

> and POSTROUTING hook until the outgoing bridge port was determined
> by the bridge code. This "feature" was removed because it broke
> all kinds of things, now the order matches the layering and IPv4
> hooks are always processed entirely before bridging.

Now the order is .. non-consistent.
On a pure bridge forward (-i br -o br), as I have determined,
ebtables-nat-POSTROUTING comes _before_ the IPv4 hooks.

