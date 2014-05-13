From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] internal: fix SNPRINTF_BUFFER_SIZE macro
Date: Tue, 13 May 2014 17:24:29 +0200
Message-ID: <20140513152429.GA6907@localhost>
References: <20140513070735.16866.22056.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47698 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbaEMPYg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 11:24:36 -0400
Content-Disposition: inline
In-Reply-To: <20140513070735.16866.22056.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 13, 2014 at 09:08:15AM +0200, Arturo Borrero Gonzalez wrote:
> We need to store in 'offset' the complete amount of characters as returned
> from _snprintf. The value means how many characters long needs the buffer to be
> in order to store the corresponding string expansion.
> 
> Before this patch, in cases where the buffer is smaller than the
> expansion, then ret > len, and therefore ret = len.
> So when incrementing offset, we do it with a wrong value.
> 
> All previous versions of libnftnl are unable to handle this situations: small
> buffers (or long string expansion).
> 
> BTW, if a caller must reallocate a buffer to the returned value of snprintf, it
> should be ret + 1.
> 
> While at it, let's add a check to know if the last snprintf call failed.

Also applied, thanks.
