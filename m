From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Make ip6tables, iptables and iptables-xml
 use xtables_globals
Date: Wed, 11 Feb 2009 18:30:04 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111829320.27325@fbirervta.pbzchgretzou.qr>
References: <1234236724.20903.34.camel@dogo.mojatatu.com>  <alpine.LSU.2.00.0902111620080.20223@fbirervta.pbzchgretzou.qr> <1234372693.20903.114.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47751 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbZBKRaG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:30:06 -0500
In-Reply-To: <1234372693.20903.114.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-11 18:18, jamal wrote:
>On Wed, 2009-02-11 at 16:22 +0100, Jan Engelhardt wrote:
>> On Tuesday 2009-02-10 04:32, jamal wrote:
>
>> -ldl does not belong to iptables_xml, this must be added
>> to libxtables_la_LIBADD instead (see 5c3e076 in my tree)
>> 
>
>Ok. Shall i send an addendum patch?

Since this patch, too, has already been applied, I took care of it.

>> That said, libxtables does not even make use of _globals->program_name,
>> so I am terribly confused.
>
>I was planning to send one huge patch which gets rid of program_name,
>program_version and xtables_program_name at the end.

Just don't make it too huge :)
