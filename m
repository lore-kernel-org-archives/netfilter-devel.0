From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 2/3] libxtables: Port libarptc mangle
 target into libxtables
Date: Thu, 03 Oct 2013 13:43:52 +0300
Message-ID: <524D4A68.4020505@linux.intel.com>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1380793977-9730-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20131003103229.GB15413@localhost> <20131003103606.GA15817@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3JCKnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:43:55 -0400
In-Reply-To: <20131003103606.GA15817@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> We need a follow up fix for this:
>
> xtables-arp  -A  OUTPUT  -o  eth1  --h-length  6  -j mangle --mangle-mac-s 01:00:5e:00:01:01
> xtables-arp v1.4.19.1: Extension mangle uses invalid ID 49

Will take a look at this.

Tomasz
