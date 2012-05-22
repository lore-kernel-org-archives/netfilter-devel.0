From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] tests: add rateest match rules
Date: Tue, 22 May 2012 20:35:58 +0200
Message-ID: <20120522183558.GA28870@1984>
References: <1337252589-1363-1-git-send-email-fw@strlen.de>
 <1337252589-1363-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab2EVSgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 14:36:07 -0400
Content-Disposition: inline
In-Reply-To: <1337252589-1363-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 17, 2012 at 01:03:09PM +0200, Florian Westphal wrote:
> also, -p mobility gets us EINVAL from kernel, use -p ipv6-mh instead.

/etc/services in debian uses mobility-header instead mobility.

Better, use -p 135 and add some comment telling that this is IPv6
mobility until distributors agree.

http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml

IANA also seems to use mobility-header, btw.

Would you re-send me this patch, please?
