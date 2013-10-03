From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 2/3] libxtables: Port libarptc mangle
 target into libxtables
Date: Thu, 03 Oct 2013 15:08:13 +0300
Message-ID: <524D5E2D.5090203@linux.intel.com>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1380793977-9730-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20131003103229.GB15413@localhost> <20131003103606.GA15817@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62687 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab3JCMIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:08:18 -0400
In-Reply-To: <20131003103606.GA15817@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok the command below gets parsed properly with the later patches I sent.

> We need a follow up fix for this:
>
> xtables-arp  -A  OUTPUT  -o  eth1  --h-length  6  -j mangle --mangle-mac-s 01:00:5e:00:01:01
> xtables-arp v1.4.19.1: Extension mangle uses invalid ID 49

However there is now an issue in the netlink message.

I see where is the bug I have a fix for it.

Tomasz
