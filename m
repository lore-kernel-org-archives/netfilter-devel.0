From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Tue, 17 Feb 2015 16:53:31 +0100
Message-ID: <20150217155331.GA3341@salvia>
References: <1424187335-5968-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	johunt@akamai.com
To: Eric B Munson <emunson@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbbBQPuP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 10:50:15 -0500
Content-Disposition: inline
In-Reply-To: <1424187335-5968-1-git-send-email-emunson@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 17, 2015 at 10:35:35AM -0500, Eric B Munson wrote:
> It would be useful for userspace to query the size of an ipset.  This
> data is held for both the bitmask and hash types, however, it is not
> exposed to userspace.  This patch uses the otherwise unused attribute
> IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> exported to userspace.

Thanks for your patch.

I think Jozsef will need the userspace bits for his library and
utility.

Jozsef?
