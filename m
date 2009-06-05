From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 5 Jun 2009 12:43:54 +0200
Message-ID: <20090605104354.GA4184@mail.eitzenberger.org>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de> <4A28EA6F.1080109@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Florian Westphal <fwestphal@astaro.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFEKtI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:49:08 -0400
Content-Disposition: inline
In-Reply-To: <4A28EA6F.1080109@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> Does this guarantee that packets with NAT handlings go to the same queue?

Yes, this is guaranteed by the way the hashing is done.  And in fact
it's very much necessary for applications like Snort e. g.

 /holger

