From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: tests/test-script.sh missing from 1.0.1 tar.bz2?
Date: Sat, 26 Apr 2014 14:13:10 +0200
Message-ID: <20140426121310.GA24825@localhost>
References: <20140424112343.20161e0f@voldemort.scrye.com>
 <20140425085505.GB4113@localhost>
 <20140425101415.7af65532@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbaDZMNT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Apr 2014 08:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20140425101415.7af65532@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 25, 2014 at 10:14:15AM -0600, Kevin Fenzi wrote:
> On Fri, 25 Apr 2014 10:55:05 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Thu, Apr 24, 2014 at 11:23:43AM -0600, Kevin Fenzi wrote:
> > > Greetings. 
> > > 
> > > Looks like somewhere along the way the tests/test-script.sh didn't
> > > get included in the
> > > http://ftp.netfilter.org/pub/libnftnl/libnftnl-1.0.1.tar.bz2
> > > release.
> > > 
> > > Something in 'make dist' dropping it?
> > 
> > Just pushed a patch to fix this, thanks.
> > 
> > http://git.netfilter.org/libnftnl/commit/?id=4e92a484c00a8c2e18d4e2b8a1912ac1b86b4089
> 
> Oops. Also the tests/jsonfiles/ and tests/xmlfiles/ are missing as
> well. 
> 
> Sorry for not noticing those at the same time. ;( 

No problem:

http://git.netfilter.org/libnftnl/commit/?id=a0f495765b0196b898478631a4571dbfd6e68727

Thanks.
