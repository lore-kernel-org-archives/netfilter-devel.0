From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC 2/3] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Tue, 08 Apr 2014 12:04:12 +0300
Message-ID: <5343BB8C.2030105@linux.intel.com>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1395911972-17259-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20140408080642.GA3904@localhost> <5343B153.30804@linux.intel.com> <20140408083418.GA5272@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaDHJEP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:04:15 -0400
In-Reply-To: <20140408083418.GA5272@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> +
> +       if (pkt->ops->pf != NFPROTO_BRIDGE)
>
> Do you really need this or is it just defensive?

Defensive, but useless. Will get rid of it.

Tomasz
