From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: ulogd extension
Date: Fri, 6 Nov 2009 20:39:47 +0100
Message-ID: <20091106193946.GA3089@piche.inl.fr>
References: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
 <20091030222312.GA11601@piche.inl.fr>
 <30defc5b0910301611i1cbd6993h2846a5b7167f023b@mail.gmail.com>
 <20091101103612.GB11601@piche.inl.fr>
 <30defc5b0911010308r6aa0f62cl6f910148932b924e@mail.gmail.com>
 <30defc5b0911060736g1dae26f7g6148e8eb7e3d76d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pierre Chifflier <pchifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Fred Leeflang <fredl@dutchie.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55076 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZKFTjx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:39:53 -0500
Content-Disposition: inline
In-Reply-To: <30defc5b0911060736g1dae26f7g6148e8eb7e3d76d3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2009 at 04:36:58PM +0100, Fred Leeflang wrote:
> Pierre,
> 
> I've hacked support for creating nflog targets into vuurmuur. When experimenting
> with this I've found that it was real easy to have ulogd2's syslogemu
> output module write a syslog file that vuurmuur could use to do our
> syslog parsing. This may be
> more useful even than writing our own extension for ulogd2 as our project leader
> decided not to want to obsolete the log parsing daemon.
> 
> So, we could simply add a requirement to vuurmuur (or at least a recommended)
> of ulogd. Does ulogd1 also support nflog tgts? If not, when's ulogd2
> scheduled to be
> released? Are any distro packagers working on it already?
> 

Hi Fred,

AFAICT ulogd1 does not support NFLOG, only ulogd2. For the release date,
I have no idea, though as it is in beta stage it should not be long.
On the packages, I have working packages for Debian. In fact, I will
upload them in experimental as soon as I have some time.

Regards,
Pierre
