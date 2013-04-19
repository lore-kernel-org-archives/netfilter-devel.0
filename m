From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Fri, 19 Apr 2013 09:50:49 +0300
Message-ID: <5170E949.9060109@linux.intel.com>
References: <516EA684.9040209@linux.intel.com> <516EA900.3080607@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>
To: Victor Julien <lists@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab3DSGuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:50:52 -0400
In-Reply-To: <516EA900.3080607@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Victor,

> Not sure if it would fit the scope of this library, but as a frontend
> developer I would love to have easy access to some sort of "supported
> features" call.
>
> In Vuurmuur I currently parse /proc/net/ip_tables_names to see what
> tables are supported, /proc/net/ip_tables_matches to see what matches
> are supported, etc.
>
> This still isn't enough, because it won't tell me if the SNAT target
> will actually support the --random option, so I end up creating a lot of
> test rules at startup, just to figure this stuff out.
>
> Then there is also the case of a mismatch between kernel and userland. I
> remember one case where the Ubuntu kernel would support a module, but
> the shipped iptables wouldn't.
>
> Not sure if all of this is relevant to nftables and I don't have a
> proposed solution, but just wanted to bring it up for consideration.

This is a good idea, since indeed not all features might be supported from
one kernel configuration/version to another. However, nftables does not
expose anything through proc-fs currently. And it does not tell anything
about what are supported features anywhere, afaik.

We should first think how to fix this from kernel side, for the library 
itself it
should be trivial afterwards. There are issues like as long as modules are
not loaded you don't know for instance which expressions are supported...

Maybe kernel guys have good ideas how to fix this?


Tomasz
