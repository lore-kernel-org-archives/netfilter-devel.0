From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: conntrack segfault
Date: Wed, 24 Jun 2009 22:05:26 +0200
Message-ID: <20090624200526.GA14607@pest>
References: <h1q05h$o8h$1@ger.gmane.org>
 <h1q3tu$2vi$1@ger.gmane.org>
 <4A40F777.7010505@netfilter.org>
 <4A4108D6.901@birkenwald.de>
 <4A4159BE.7040807@birkenwald.de>
 <20090624105915.GA8675@schleppi.birkenwald.de>
 <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl>
 <alpine.LSU.2.00.0906241353160.16864@fbirervta.pbzchgretzou.qr>
 <4A42226A.4040502@birkenwald.de>
 <4A426932.1030607@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.svr02.mucip.net ([83.170.6.69]:38346 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762441AbZFXUF1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:05:27 -0400
Content-Disposition: inline
In-Reply-To: <4A426932.1030607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 24, 2009 at 07:58:10PM +0200, Pablo Neira Ayuso wrote:

> > The problem is, we currently run conntrack -L every minute. It segfaults
> > about 20 times a day, usually during the period with the highest number
> > of connections. Unless I can always run conntrack in valgrind/gdb
> > automatically and get a usable dump when it fails I have a hard time to
> > get any information from it.
> 
> Are you using latest version?

Yeah, pretty much.

libnfnetlink 0.0.41
libnetfilter_log 0.0.16
libnetfilter_conntrack 0.0.99
conntrack-tools 0.9.12

So the only thing that isn't up to date anymore (since two days) is
libnfnetlink. I can't see anything important in the changelog though.

The base system is a SLES 11 with vanilla kernel 2.6.27.23, so that's a
bit aged as well.

Bernhard
