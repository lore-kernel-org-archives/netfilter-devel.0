From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [-stable-3.8.y 1/9] ipvs: ip_vs_sip_fill_param() BUG: bad check
 of return value
Date: Thu, 9 May 2013 01:53:02 +0200
Message-ID: <20130508235302.GA15397@localhost>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
 <20130508223642.GA6305@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	davem@davemloft.net
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab3EHXxJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 19:53:09 -0400
Content-Disposition: inline
In-Reply-To: <20130508223642.GA6305@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 08, 2013 at 03:36:42PM -0700, Greg KH wrote:
[...]
> This should also go into other stable kernel releases as well, right?

Yes, that's a good idea. I was going to send you specific batches per
branch though.
