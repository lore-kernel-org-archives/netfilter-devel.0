From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Fri, 7 Nov 2008 04:06:09 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811070405070.27330@fbirervta.pbzchgretzou.qr>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr> <490B544B.50903@hp.com> <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rick Jones <rick.jones2@hp.com>, netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKGDGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:06:14 -0500
In-Reply-To: <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-05 19:25, Jesper Dangaard Brouer wrote:
> On Sat, 1 Nov 2008, Jan Engelhardt wrote:
>> On Friday 2008-10-31 19:54, Rick Jones wrote:
>> > >
>> > > iptables-save | grep ^- | wc -l
>> >
>> > Here is where I cop to being a luddite who prefers straight C to calling
>> > system() :)
>>
>> But there is no C library. And libiptc is so strongly internal that
>> it does not fall under libraries-to-use.
>
> I don't see why not to use libiptc.  Its been one of the most stable /
> less-changed through the years...
>
> I'm using libiptc quite extensivly in IPTables::libiptc Perl CPAN module.

Hm yeah. The API might be ok, but the source is ugly. Hence
the recent slew of patches. I'm still thinking how to pull
this off so that it gets even less ugly, less big (it is
essentially compiled twice), and then make it available
as a standard library.
