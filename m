From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [stable] bridge: netfilter: Fix dropping packets that moving
 through bridge interface
Date: Tue, 17 Jan 2017 13:53:03 +0100
Message-ID: <20170117125303.GA31649@kroah.com>
References: <e7fd1864-91dc-ca2d-8ce5-4cb7b589f1f5@gmail.com>
 <20170116200854.GA25408@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artur Molchanov <arturmolchanov@gmail.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAQNS3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 08:18:29 -0500
Content-Disposition: inline
In-Reply-To: <20170116200854.GA25408@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 09:08:54PM +0100, Pablo Neira Ayuso wrote:
> Cc'ing Greg.
> 
> On Mon, Jan 16, 2017 at 09:44:10PM +0300, Artur Molchanov wrote:
> > commit 14221cc45caad2fcab3a8543234bb7eda9b540d5 upstream.
> > 
> > Please apply this commit to fix bug that makes impossible to use local
> > Docker containers with bridge network.
> > 
> > Cc: <stable@vger.kernel.org> # 4.9.x
> 
> Greg, please, cherry-pick this commit to -stable 4.9.x.

Now done, thanks.

greg k-h
