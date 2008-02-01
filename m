From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 29/30] NFCT: adapt to new libnetfilter_conntrack
Date: Fri, 01 Feb 2008 09:33:43 +0100
Message-ID: <87wspp9iu0.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190130.347773797@kruemel.intranet.astaro.de>
	<47A29837.2000709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYBAIeE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:34:04 -0500
In-Reply-To: <47A29837.2000709@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:55:35 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> I frankly prefer if you don't this "translator" and use the new API
> directly.

Generally speaking I don't like this further indirection introduced by
this patch too.  As I said in my introductory email I consider this
solution only a short-term solution.  Later patches will change that by
using libnl instead or at least get rid of that further indirection.

Thanks.

 /holger
