From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Remove redundant TCP header checks from xt_TCPOPTSTRIP
Date: Mon, 10 Jun 2013 20:15:16 +0200
Message-ID: <20130610181516.GA3757@localhost>
References: <20130610035948.GA2742@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3FJSPU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:15:20 -0400
Content-Disposition: inline
In-Reply-To: <20130610035948.GA2742@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 09, 2013 at 11:59:48PM -0400, Phil Oester wrote:
> In commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
> packet boundary"), a check for short TCP header or malformed packet was added.
> This check is unnecessary, as these packets are already handled in the tcp_error
> function of nf_conntrack_proto_tcp.c (see /* Not whole TCP header or malformed
> packet */).

We cannot assume nf_conntrack is loaded. We have to support stateless
setups as well.

> In addition, there was an error in the check which was added (len
> is being calculated incorrectly).  In my testing, ALL packets are being dropped
> by the TCPOPTSTRIP target at present.  Revert the unnecessary/incorrect checks.

Then, we have to fix the wrong calculation. I cannot reproduce this
here.
