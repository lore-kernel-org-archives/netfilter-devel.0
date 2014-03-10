From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables 0/3] ebtables patchset
Date: Mon, 10 Mar 2014 12:50:07 +0200
Message-ID: <531D98DF.5070507@linux.intel.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27428 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaCJKuJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:50:09 -0400
In-Reply-To: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo and Giuseppe,

> As you can see, a minor issue have to be fixed when printing rules.
> I have no idea how to handle --logical-in/out interfaces currently,
> so please let me know if you have an idea or an advice.

As far as I know, there is nothing in nftables's side to differentiate
between interfaces origin, right? (like a proper hw tight 'eth0' vs a 
bridge 'br0')
Unless I miss something, it has no real meaning in nftables to support 
such differentiation,
but for the sake of ebtables compat layer we might need a solution here.

Any idea how this issue could be fixed?

Br,

Tomasz
