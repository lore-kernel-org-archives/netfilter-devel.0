From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: remove messages print and boot/module
 load time
Date: Fri, 19 Jan 2018 14:06:04 +0100
Message-ID: <20180119130604.GB21673@breakpoint.cc>
References: <20180119124702.2650-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33988 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754951AbeASNIh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 08:08:37 -0500
Content-Disposition: inline
In-Reply-To: <20180119124702.2650-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Several reasons for this:
> 
> * Several modules maintain internal version numbers, that they print at
>   boot/module load time, that are not exposed to userspace, as a
>   primitive mechanism to make revision number control from the earlier
>   days of Netfilter.
> 
> * IPset shows the protocol version at boot/module load time, instead
>   display this via module description, as Jozsef suggested.
> 
> * Remove copyright notice at boot/module load time in two spots, the
>   Netfilter codebase is a collective development effort, if we would
>   have to display copyrights for each contributor at boot/module load
>   time for each extensions we have, we would probably fill up logs with
>   lots of useless information - from a technical standpoint.
> 
> So let's be consistent and remove them all.

Acked-by: Florian Westphal <fw@strlen.de>
