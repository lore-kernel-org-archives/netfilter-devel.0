From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] payload: reorder case in a switch for consistency
Date: Tue, 30 Jun 2015 02:03:32 +0200
Message-ID: <20150630000332.GA6502@salvia>
References: <20150626085441.GB10981@acer.localdomain>
 <1435312521-8184-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38189 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbbF2X6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 19:58:03 -0400
Content-Disposition: inline
In-Reply-To: <1435312521-8184-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 11:55:21AM +0200, Eric Leblond wrote:
> As pointed out by Patrick McHardy the order in the inet switch
> in payload_gen_dependency was not consistent.

Applied, thanks.

