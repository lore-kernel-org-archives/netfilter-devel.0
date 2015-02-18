From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Wed, 18 Feb 2015 04:54:16 +0100
Message-ID: <20150218035416.GA4945@salvia>
References: <1424187335-5968-1-git-send-email-emunson@akamai.com>
 <20150217155331.GA3341@salvia>
 <alpine.DEB.2.10.1502172223580.16817@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, johunt@akamai.com,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Eric B Munson <emunson@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbbBRDuz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 22:50:55 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1502172223580.16817@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 17, 2015 at 10:35:40PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 17 Feb 2015, Pablo Neira Ayuso wrote:
> 
> > On Tue, Feb 17, 2015 at 10:35:35AM -0500, Eric B Munson wrote:
> > > It would be useful for userspace to query the size of an ipset.  This
> > > data is held for both the bitmask and hash types, however, it is not
> > > exposed to userspace.  This patch uses the otherwise unused attribute
> > > IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> > > exported to userspace.
> > 
> > Thanks for your patch.
> > 
> > I think Jozsef will need the userspace bits for his library and
> > utility.
> 
> Yes, that's missing from the patch. Also, I don't like any change which 
> affects the userspace but not expressed in new set type revision. Later on 
> the new revision makes much simpler to identify why the "Elements: is 
> missing from the listing of a set.

Please address Jozsef's feedback and resubmit. Thanks.
