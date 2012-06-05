From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd: build fixes
Date: Tue, 5 Jun 2012 19:01:59 +0200
Message-ID: <20120605170159.GB25654@1984>
References: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2FERCD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:02:03 -0400
Content-Disposition: inline
In-Reply-To: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 05, 2012 at 10:41:00AM +0200, Jan Engelhardt wrote:
> 
> The following changes since commit 5dc52c43c4d9e0e8a6813cdcd8e1d12a9f1e3fe8:
> 
>   build: use pkglibdir instead of pkglibexecdir for automake (2012-05-18 02:50:11 +0200)
> 
> are available in the git repository at:
>   git://git.inai.de/ulogd master
> 
> Jan Engelhardt (3):
>       sqlite: resolve compiler warnings
>       nfacct: resolve build failure
>       pcap: resolve unreliable detection

This is pretty convenient. Thanks a lot Jan.

Let's see if I find the time to release ulogd 2.0 by end of this week.
