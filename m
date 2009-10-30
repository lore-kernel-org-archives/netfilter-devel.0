From: Pierre Chifflier <chifflier@inl.fr>
Subject: Re: ulogd extension
Date: Fri, 30 Oct 2009 23:23:12 +0100
Message-ID: <20091030222312.GA11601@piche.inl.fr>
References: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Fred Leeflang <fredl@dutchie.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39336 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981AbZJ3WXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:23:19 -0400
Content-Disposition: inline
In-Reply-To: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 30, 2009 at 09:17:26PM +0100, Fred Leeflang wrote:
> Hi,
> 
> For vuurmuur I would like to write an ulogd extension that writes out
> a log somewhat comparable to syslog. Currently vuurmuur parses syslog
> line generated with the LOG target, we are considering changing this
> to having ulogd do this for us through the ULOG target and said
> extension. What's the best way to go about doing this to keep the
> extension maintainable?
> 

Hi Fred,

Have you looked at the SYSLOG or LOGEMU output plugins ? Writing a
similar plugin should be fairly easy.
Writing external plugins is not supported. It's very easy, yet Pablo
prefers [1] to keep things in mainline when possible, which is of course
a good thing [2].

Pierre

[1] http://marc.info/?t=123996560400005&r=1&w=2
[2] external plugins would require us to create, document, and
maintain a stable API, for ex. Not that it can't be done, but I'm not
sure it was part of the original plans :)
