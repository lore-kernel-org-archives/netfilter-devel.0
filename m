From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables use of NFPROTO_UNSPEC as wildcard incomplete :-(
Date: Thu, 15 Jan 2009 16:52:57 +0100
Message-ID: <496F5BD9.2020703@trash.net>
References: <87k58yzy2v.fsf@cayenne.mti.ag> <alpine.LSU.2.00.0901140256180.22699@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christian von Roques <roques@mti.ag>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44840 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbZAOPw7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:52:59 -0500
In-Reply-To: <alpine.LSU.2.00.0901140256180.22699@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-01-13 22:38, Christian von Roques wrote:
>> I have a production server where I had to replace a failed on-board
>> Ethernet port with a 3c905 requiring a very new kernel (due to a
>> regression in the 3c905 driver, which was just recently fixed).  This
>> server requires netfilter/xt_MARK.c for IPv4.  Unfortunately your
>> changes to make NFPROTO_UNSPEC act like a protocol wildcard seem
>> incomplete.  -j MARK does not work anymore.  Replacing NFPROTO_UNSPEC
>> with NFPROTO_IPV4 in xt_MARK.c fixed my problem, but obviously
>> disabled the MARK target for all other protocols (which I fortunately
>> don't need).
>>
>> Is this a know problem?
>> Are you able to reproduce the problem?
>> The simplest command which used to fail was:
>> iptables -t mangle -A OUTPUT -j MARK --set-mark 0x14 
> 
> 
> This is probably the same as
> http://marc.info/?l=netfilter&m=123174116204956&w=2 and only
> manifests itself under the condition that kernel < 2.6.28 && iptables
> <= 1.4.0. Most people should-have (read it as a recommendation)
> upgraded their iptables long ago, really, since some distros just
> keep on shipping old stuff like almost forever.

I'm not sure what you mean, the problem that patch fixed affects
kernel == 2.6.28 and all iptables versions as long as you use
anything but revision 0.

Anyways, I'll send the patch to -stable shortly.
