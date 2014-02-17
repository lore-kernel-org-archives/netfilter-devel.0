From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] ct: direction should be integer, not bitmask
Date: Tue, 18 Feb 2014 00:09:56 +0100
Message-ID: <20140217230956.GA20408@localhost>
References: <1392671107-6457-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42228 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaBQXKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:10:03 -0500
Content-Disposition: inline
In-Reply-To: <1392671107-6457-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 10:05:07PM +0100, Florian Westphal wrote:
> should always generate cmp op (its enum 0, 1 in kernel).
> 
> Note: 'original,reply' will no longer work after this patch.

This is also fixing the bytecode that is generated for:

nft add rule ip filter output ct direction reply counter

ip filter output 54 53
  [ ct load direction => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ counter pkts 0 bytes 0 ]

and the output:

ct direction & reply != original counter packets 0 bytes 0

which doesn't obviously work.

To this:

ip filter output 57 56
  [ ct load direction => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ counter pkts 0 bytes 0 ]

Feel free to push it. Thanks!

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
