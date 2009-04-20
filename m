From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 16:40:46 +0200
Message-ID: <49EC896E.5070402@trash.net>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbZDTOku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:40:50 -0400
In-Reply-To: <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Mon, 20 Apr 2009, Pablo Neira Ayuso wrote:
>> I wasn't refering to any iptables target. New ulogd2 includes support
>> for ctnetlink, which can do this. I know, that means the extra libraries
>> dependencies.
> 
> I see. Thanks the info, good to know that ulogd2 is capable of this.
> (Calling 'conntrack' for logging looked really ugly. :-)

In the kernel, we could log the information from the conntrack
entry, if any. That would allow to log the manips after they
have been set up.

Would Pablo's suggestion or the conntrack method work for you?
