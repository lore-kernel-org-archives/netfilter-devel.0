From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Make ip6tables, iptables and iptables-xml
	use xtables_globals
Date: Wed, 11 Feb 2009 12:18:13 -0500
Message-ID: <1234372693.20903.114.camel@dogo.mojatatu.com>
References: <1234236724.20903.34.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111620080.20223@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:17952 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZBKRUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:20:09 -0500
Received: by ey-out-2122.google.com with SMTP id 25so35318eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:20:07 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902111620080.20223@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 16:22 +0100, Jan Engelhardt wrote:
> On Tuesday 2009-02-10 04:32, jamal wrote:

> -ldl does not belong to iptables_xml, this must be added
> to libxtables_la_LIBADD instead (see 5c3e076 in my tree)
> 

Ok. Shall i send an addendum patch?

> 
> This looks like it would print "ip6tables" even when you
> run ip6tables-restore, which is not what is wanted.

Good catch. I have actually fixed it in the patch i promised
on xtables_init_all() - it was easier to spot there. I will send
that patch later when i finish responding.

> That said, libxtables does not even make use of _globals->program_name,
> so I am terribly confused.

I was planning to send one huge patch which gets rid of program_name,
program_version and xtables_program_name at the end.

cheers,
jamal

