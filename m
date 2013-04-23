From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 14:55:40 +0300
Message-ID: <517676BC.3010107@linux.intel.com>
References: <516EA684.9040209@linux.intel.com> <20130419100531.GA3481@localhost> <517129D8.8000006@linux.intel.com> <20130419121127.GA29452@localhost> <1366671791.15660.36.camel@tiger2> <20130422235012.GA4875@localhost> <51765F2E.9000909@linux.intel.com> <20130423113112.GB3348@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9452 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab3DWLzo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:55:44 -0400
In-Reply-To: <20130423113112.GB3348@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> It's easy to support it.
> [...]
>
> Again, you say you need this driver thing, but you will not escape
> without explaining me why you need this.

We just don't use libnl/libmnl in connman.
As well as we currently support glib as the event loop but I know other 
app devs don't especially, they might use some others.
Which is why I propose these 2 features.

Br,

Tomasz
