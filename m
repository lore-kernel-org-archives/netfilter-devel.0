From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables next-3.14 merged into master
Date: Tue, 18 Feb 2014 01:29:13 +0000
Message-ID: <20140218012913.GC12893@macbook.localnet>
References: <20140217194156.GC11041@macbook.localnet>
 <CAOkSjBiwM0zX6q51rE9ysiJ9B1YFNB=tYJNwctjvgKjgoLUt9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54609 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaBRB3R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:29:17 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiwM0zX6q51rE9ysiJ9B1YFNB=tYJNwctjvgKjgoLUt9Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 10:22:33PM +0100, Arturo Borrero Gonzalez wrote:
> On 17 February 2014 20:41, Patrick McHardy <kaber@trash.net> wrote:
> > Just a heads up, I've merged the next-3.14 branch into master, which is
> > where things will be happening from now on. Please make sure to switch
> > branches if you're on next-3.14.
> 
> Something weird happened:
> 
> [...]
> 413eded src: proto: fixed a rreply symbol
> b621a41 src: proto: fixed a rreply symbol
> [...]
> 
> The first one with no content.

That was my mistake while adding that patch. The second one should be fine.
