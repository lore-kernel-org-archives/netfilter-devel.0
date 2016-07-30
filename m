From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_dup4: remove redundant checksum
 recalculation
Date: Sat, 30 Jul 2016 15:13:17 +0200
Message-ID: <20160730131317.GA29291@breakpoint.cc>
References: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41696 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbcG3NNZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2016 09:13:25 -0400
Content-Disposition: inline
In-Reply-To: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> IP header checksum will be recalculated at ip_local_out, so

Thats only called for local packets.

> there's no need to calculated it here, remove it. Also update
> code comments to illustrate it, and delete the misleading
> comments about checksum recalculation.

I think current code is right, we have to do this checksum
fixup here.
