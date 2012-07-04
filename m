From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue build fix
Date: Wed, 4 Jul 2012 19:56:43 +0200
Message-ID: <20120704175643.GB9808@1984>
References: <1341018474-1274-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45415 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab2GDR4q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:56:46 -0400
Content-Disposition: inline
In-Reply-To: <1341018474-1274-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 30, 2012 at 03:07:53AM +0200, Jan Engelhardt wrote:
> 
> This was a fun one... I knew it pays off to build the openSUSE distro
> packages with `./configure --includedir=SomethingNonStandard`
> throughout! :)

this seems to be a pretty old left-over in libnetfilter_queue. I'm
surprised nobody noticed so far.

> The following changes since commit 7bd9edfe7849d8d1bc35f9ac28e949409da0bf10:
> 
>   build: remove unused lines in Makefile.am (2012-06-24 14:58:28 +0200)
> 
> are available in the git repository at:
>   git://git.inai.de/libnetfilter_queue master

pulled, thanks.
