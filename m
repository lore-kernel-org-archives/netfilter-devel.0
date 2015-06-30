From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables 1/3] erec: fix buffer overflow
Date: Tue, 30 Jun 2015 02:03:00 +0200
Message-ID: <20150630000245.GA6449@salvia>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
 <1435132311-31452-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38161 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbbF2X5d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 19:57:33 -0400
Content-Disposition: inline
In-Reply-To: <1435132311-31452-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:51:49AM +0200, Eric Leblond wrote:
> A static array was used to read data and to write information in
> it without checking the limit of the array. The result was a buffer
> overflow when the line was longer than 1024.
> 
> This patch now uses a allocated buffer to avoid the problem.

Applied, thanks Eric.

I have replaced malloc and free by xmalloc and xfree respectively.
