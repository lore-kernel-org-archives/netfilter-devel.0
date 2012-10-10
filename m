From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] autoconf/ulogd: fix broken libpcap AM_CONDITIONAL
Date: Wed, 10 Oct 2012 11:15:49 +0200
Message-ID: <20121010091549.GA15016@1984>
References: <1349810839-5958-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab2JJJP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:15:58 -0400
Content-Disposition: inline
In-Reply-To: <1349810839-5958-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 09, 2012 at 04:27:19PM -0300, Gustavo Zacarias wrote:
> The AM_CONDITIONAL lacks the opening bracket, hence it always evaluates
> as true, even if there's no libpcap found thus causing build breakage.

Applied, thanks.
