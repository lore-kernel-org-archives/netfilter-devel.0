From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: use NFPROTO_* constants in NF_HOOK callsites
Date: Sun, 19 Oct 2008 14:46:34 +0200
Message-ID: <48FB2C2A.4010209@netfilter.org>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net> <48F72BE8.80602@netfilter.org> <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0810171043520.30268@fbirervta.pbzchgretzou.qr> <48FA0B19.4030300@trash.net> <alpine.LNX.1.10.0810181519520.27947@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34730 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751735AbYJSMrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Oct 2008 08:47:51 -0400
In-Reply-To: <alpine.LNX.1.10.0810181519520.27947@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2008-10-18 12:13, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> commit cc3e81cbbc8a6977cfe614286de16020f9efa3c6
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Fri Oct 17 10:02:30 2008 -0400
>>>
>>> netfilter: use NFPROTO_* constants in NF_HOOK callsites
>> This is missing arp, the only place that would qualify as bugfix.
>> Please resubmit and add a changelog that explains that is actually
>> fixes something.
> 
> I just did that! Or did you already delete the mail and
> marc is down?
> http://marc.info/?l=netfilter-devel&m=122412130603479&w=2

I think that Patrick means that you have to merge both patches and
include the changelog that *explicitly* states that this is not just a
cleanup but a bugfix, otherwise it won't get into 2.6.27.

BTW, include the Reported-by tag. Ingo Molnar recently told us to do so
in all of our patches. I don't care about credits but this is supposed
to be "good practise" to encourage testers.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
