From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 13:58:48 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151357410.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com> <20080515093413.GC3442@khasse.inl.fr> <alpine.LNX.1.10.0805151156450.16151@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0805151214530.1358@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Leblond <eric@inl.fr>, Anton <anton.vazir@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43230 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYEOL6t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 07:58:49 -0400
In-Reply-To: <Pine.LNX.4.64.0805151214530.1358@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-05-15 13:18, Krzysztof Oledzki wrote:

>
>
> On Thu, 15 May 2008, Jan Engelhardt wrote:
>
>>
>> On Thursday 2008-05-15 11:34, Eric Leblond wrote:
>> >
>> > One other thing to look at may be :
>> > http://www.netfilter.org/projects/patch-o-matic/pom-external.html#pom-external-IPMARK
>>
>> That variant is as old as POM and broken.
>
> The second statement is not true as it shoudl work with all 2.6.x kernels and
> both iptables-1.3 and iptables-1.4.

It will definitely not work for 32-bit userland+64-bit kernel due to a size
mismatch. But since it is fixed in Xtables-addons, no further action is needed.
