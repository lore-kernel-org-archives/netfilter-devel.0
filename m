From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: nfacct version dependency
Date: Wed, 08 May 2013 09:10:50 +0200
Message-ID: <1475239.ZWarQo59dL@storm>
References: <3347028.Gq033PXqRA@storm> <20130507190444.GA16455@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:37794 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3EHHK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 03:10:57 -0400
In-Reply-To: <20130507190444.GA16455@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tuesday, 7. May 2013 21:04:44 Pablo Neira Ayuso wrote:
> > nfacct currently requires "libnetfilter_acct >= 1.0.2"
> > which has not been released yet.
> 
> http://www.netfilter.org/projects/libnetfilter_acct/downloads.html
> http://www.netfilter.org/projects/libnetfilter_acct/files/libnetfilter_acc
> t-1.0.2.tar.bz2

hmm, that's odd, I'm pretty sure I've updated the git tree yesterday
and the commits for this weren't there. Anyway, thanks Pablo!
There was even a release announcement message for this...

The mailinglist archive linked on the project page seems down:
http://www.netfilter.org/projects/libnetfilter_acct/mailinglists.html
In fact it seems unavailable for the other projects, too.

Thomas

