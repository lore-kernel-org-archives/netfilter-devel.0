From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Use stdlib uint* instead of u_int*
Date: Tue, 17 Mar 2015 17:08:56 +0100
Message-ID: <20150317160856.GA5769@salvia>
References: <1426540063-17099-1-git-send-email-nwmcsween@gmail.com>
 <1426540063-17099-2-git-send-email-nwmcsween@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nathan McSween <nwmcsween@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50723 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbbCQQFI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 12:05:08 -0400
Content-Disposition: inline
In-Reply-To: <1426540063-17099-2-git-send-email-nwmcsween@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

git am report trailing whitespace errors when applying this patch:

libnfnetlink/.git/rebase-apply/patch:38:
trailing whitespace.
                                                   uint8_t, uint8_t, 
libnfnetlink/.git/rebase-apply/patch:300:
trailing whitespace.
 * nfnl_nfa_addattr16 - Add uint16_t attribute to struct nfattr 
libnfnetlink/.git/rebase-apply/patch:336:
trailing whitespace.
 * nfnl_nfa_addattr32 - Add uint32_t attribute to struct nfattr 
warning: 3 lines add whitespace errors.

Please, fix this and resend. Don't forget to include your
Signed-off-by: tag, thanks.
