From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: ulogd extension
Date: Sun, 1 Nov 2009 11:36:12 +0100
Message-ID: <20091101103612.GB11601@piche.inl.fr>
References: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
 <20091030222312.GA11601@piche.inl.fr>
 <30defc5b0910301611i1cbd6993h2846a5b7167f023b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Fred Leeflang <fredl@dutchie.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47561 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZKAKgR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:36:17 -0500
Content-Disposition: inline
In-Reply-To: <30defc5b0910301611i1cbd6993h2846a5b7167f023b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 31, 2009 at 12:11:05AM +0100, Fred Leeflang wrote:
> Yes I was looking at those although I looked at the ulogd 1 source and
> only very briefly at ulogd 2, looking at those actually gave somebody
> else in #vuurmuur the idea to check into this way. It's far easier for

Hi Fred,

I'd suggest to look only for ulogd2 if possible. The architecture is
very different, and I think adding a plugin will be far easier.

> us to make such an extension and require ulogd to run and parse
> packets for us than it is to parse a syslog text file. So if I were to
> write an extension that would do what we want it to do, could that
> extension be part of the builltin extensions of ulogd[1|2] ? I'm more
> than happy to hack something together and let the list have a look at
> it.

If the plugin is generic, it should not be a problem. Ulogd2 has 3 types
of plugins: input, filter, and output. So, from what you are telling,
I suppose it would be an input plugin ?

BTW, I don't know if it can help you, but I have written an input plugin
(UNIXSOCK) which allows to send data to ulogd2 through a unix socket,
with a script to read pcap files.
I was about to send the patches.

Regards,
Pierre
