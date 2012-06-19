From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Journey of a network packet through linux 2.6 network stack
Date: Tue, 19 Jun 2012 13:42:11 +0200
Message-ID: <20120619114211.GE445@1984>
References: <hau7egzm.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernelnewbies@kernelnewbies.org, netfilter-devel@vger.kernel.org
To: AFT <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60217 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2FSLmW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:42:22 -0400
Content-Disposition: inline
In-Reply-To: <hau7egzm.fsf@s1.test.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 19, 2012 at 04:25:01PM +0600, AFT wrote:
> 
> Hi,
> 
> A document with this heading can be found for 2.4 network stack. But i
> have not found any document regarding 2.6 network stack.
> 
> When i was searching netfilter mailing list archive, i got the following
> post :
> 
> http://lists.netfilter.org/pipermail/netfilter/2007-august/069583.html
> 
> in this post author mentioned about a document named after this. but
> does not gave any link to that document.
> 
> so i'm wondering if any similar document can be found?

You've got Linux Networking internals.

http://shop.oreilly.com/product/9780596002558.do

It's pretty think, but it provides some panoramic. As kernel code
evolves quite quickly, you may find that some things have changed, but
it's a good base to start with if you're looking for an alternative to
reading pure code.
