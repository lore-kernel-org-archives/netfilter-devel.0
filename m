From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 2007-09-22
Date: Sat, 22 Sep 2007 17:47:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709221746210.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
 <46F53283.90204@trash.net> <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr>
 <46F53749.5070303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50849 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXIVPrj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:47:39 -0400
In-Reply-To: <46F53749.5070303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 22 2007 17:39, Patrick McHardy wrote:
>> Leaves monthday matching, which could probably be done with some more
>> static tables, but I'd have to dig up some old encyclopedia from 1972
>> and see how they did it.
>
> I guess that will be a very rarely used feature anyway, don't
> bother.

I checked, and it's only a formula (with static int[] table) that transforms
a date (e.g. 2007-09-02) into a weekday (Mo-Su). But since we are starting
with a UNIX time, it does not apply. (Especially since UNIX->weekday
transformation is faster than UNIX->day->weekday.)
