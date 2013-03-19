From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_conntrack: add include to fix sparse warning
Date: Tue, 19 Mar 2013 23:54:16 +0100
Message-ID: <20130319225416.GA3682@localhost>
References: <20130316100028.7c9655ef@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3CSWyY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:54:24 -0400
Content-Disposition: inline
In-Reply-To: <20130316100028.7c9655ef@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 16, 2013 at 10:00:28AM -0700, Stephen Hemminger wrote:
> Include header file to pickup prototype of nf_nat_seq_adjust_hook

Applied, thanks.
