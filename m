From: Max Kellermann <max@duempel.org>
Subject: Re: conntrackd: questions about the new alarm implementation
Date: Mon, 21 Jan 2008 14:33:13 +0100
Message-ID: <20080121133313.GA32375@swift.blarg.de>
References: <20080121062059.GA3995@swift.blarg.de> <47949645.3040307@netfilter.org> <20080121130520.GB29741@swift.blarg.de> <47949BAF.6020203@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50101 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752699AbYAUNdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:33:14 -0500
Content-Disposition: inline
In-Reply-To: <47949BAF.6020203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/21 14:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Sure. Current approach gives good results to my benchmarks and I can
> make peace since it's not linear anymore ;).

It's still linear.  add_alarm() is still O(n), or better: it is
O(n/2048) which is mathematically the same as O(n).  But you made
everything else O(n*2048) = O(n), which is why I dislike this
optimization - you optimized for one artificial test case, penalizing
the majority of conntrackd users who don't have 25.000 connections.

Max

