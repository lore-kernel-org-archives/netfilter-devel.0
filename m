From: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 21:57:32 +0000
Message-ID: <20150212215732.40f544f0@bother.homenet>
References: <20150212102553.0bd25767@bother.homenet>
	<20150212105145.5e0177c0@bother.homenet>
	<20150212110931.6db17d7c@bother.homenet>
	<20150212113643.GA13795@breakpoint.cc>
	<20150212115202.GD22887@breakpoint.cc>
	<20150212170412.2317d1e3@bother.homenet>
	<20150212170931.GF22887@breakpoint.cc>
	<20150212213410.5a91da77@bother.homenet>
	<20150212214030.GH22887@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout4.wanadoo.co.uk ([80.12.242.68]:41405 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbBLV5b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 16:57:31 -0500
In-Reply-To: <20150212214030.GH22887@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Feb 2015 22:40:30 +0100
Florian Westphal <fw@strlen.de> wrote:
[snip]
> Thats what I meant -- line 404 is ONLY executed if the table doesn't
> exist, so we need to assign it in case we have a table and we want
> to increase the upper limit of the _existing_ table.

Ah yes, I missed line 391 and the subsequent assignments to t.  Easily
done - one rarely comes across goto outside the kernel.  (Not that there
is anything wrong with goto when used as C's version of finally, once
you get used to it.)

Chris
