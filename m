From: Jan Engelhardt <jengelh@inai.de>
Subject: Re[3]: [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Fri, 15 Jun 2012 15:04:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206151500260.12865@frira.zrqbmnf.qr>
References: <8oegugq.b2a4d43e41f924be4614ef9ef41297fa@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	fw@strlen.de
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:43590 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab2FONEp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:04:45 -0400
In-Reply-To: <8oegugq.b2a4d43e41f924be4614ef9ef41297fa@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-06-15 14:51, Hans Schillstrom wrote:
>
>As I wrote in my first mail IPv6 is a different story, you don't
>have any options there since you are not allowed to "re-frag" the
>packet

Here's another point I remember why we forced IP_DF: we want to keep
the packet as-is. The receiver of the cloned packet (often a logger)
has no way of autonomously knowing whether the packet was already
fragmented originally as it came into the cloner, or whether
fragmentation is a doing of the cloner.

Maybe should just add that as a comment for completeness of the
history. :)
