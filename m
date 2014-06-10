From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Changed type of chain.priority from unsigned int to int.
Date: Tue, 10 Jun 2014 12:52:22 +0200
Message-ID: <20140610105222.GA9163@localhost>
References: <1402349972-18658-1-git-send-email-hendrik@os-t.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hendrik Schwartke <hendrik@os-t.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaFJKwa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:52:30 -0400
Content-Disposition: inline
In-Reply-To: <1402349972-18658-1-git-send-email-hendrik@os-t.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 09, 2014 at 11:39:32PM +0200, Hendrik Schwartke wrote:
> This removes a bug that displays strange hook priorities
> like "type route hook output priority 4294967146".

Applied, thanks.
