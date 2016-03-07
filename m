From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 19:50:00 +0100
Message-ID: <20160307184959.GC22851@sonyv>
References: <20160306222442.GA20945@sonyv>
 <20160307171408.GB29573@salvia>
 <20160307180445.GA22851@sonyv>
 <20160307182054.GA6823@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33966 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcCGSuG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:50:06 -0500
Received: by mail-wm0-f44.google.com with SMTP id p65so120563484wmp.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 10:50:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160307182054.GA6823@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 07:20:54PM +0100, Pablo Neira Ayuso wrote:
> 
> I think you can add these two to icmp_type_tbl in nft/src/proto.c, it
> would be just a two-liner to support ICMP_ROUTERADVERT and
> ICMP_ROUTERSOLICIT.
> 

Ok, thanks!

