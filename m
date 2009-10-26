From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Mon, 26 Oct 2009 10:03:01 +0100
Message-ID: <200910261003.01234.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:56131 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZJZJC6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:02:58 -0400
In-Reply-To: <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan,

On Friday, 23. October 2009 17:48:04 you wrote:
> >I'm wondering if this is the best approach to support big endian
> > machines with all those #ifdefs?
> 
> The second is ok, though I dunno why he did not chose to do the
> same in the first. Hence:

Thanks for the fix! What about the left shift operations f.e. in 
ipt_acc_handle_get_data()? The original patch touched those, too.

Cheers,
Thomas
