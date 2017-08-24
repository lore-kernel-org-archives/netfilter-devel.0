From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: check for seqadj ext existence before
 adding it in nf_nat_setup_info
Date: Thu, 24 Aug 2017 16:10:44 +0200
Message-ID: <20170824141044.GA2369@salvia>
References: <941d1a239dcfb3e47b42f8f717ada3029b3adabb.1502331744.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, fgao@ikuai8.com
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:57552 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHXOLM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 10:11:12 -0400
Content-Disposition: inline
In-Reply-To: <941d1a239dcfb3e47b42f8f717ada3029b3adabb.1502331744.git.lucien.xin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 10, 2017 at 10:22:24AM +0800, Xin Long wrote:
> Commit 4440a2ab3b9f ("netfilter: synproxy: Check oom when adding synproxy
> and seqadj ct extensions") wanted to drop the packet when it fails to add
> seqadj ext due to no memory by checking if nfct_seqadj_ext_add returns
> NULL.
> 
> But that nfct_seqadj_ext_add returns NULL can also happen when seqadj ext
> already exists in a nf_conn. It will cause that userspace protocol doesn't
> work when both dnat and snat are configured.
> 
> Li Shuang found this issue in the case:
> 
> Topo:
>    ftp client                   router                  ftp server
>   10.167.131.2  <-> 10.167.131.254  10.167.141.254 <-> 10.167.141.1
> 
> Rules:
>   # iptables -t nat -A PREROUTING -i eth1 -p tcp -m tcp --dport 21 -j \
>     DNAT --to-destination 10.167.141.1
>   # iptables -t nat -A POSTROUTING -o eth2 -p tcp -m tcp --dport 21 -j \
>     SNAT --to-source 10.167.141.254
> 
> In router, when both dnat and snat are added, nf_nat_setup_info will be
> called twice. The packet can be dropped at the 2nd time for DNAT due to
> seqadj ext is already added at the 1st time for SNAT.
> 
> This patch is to fix it by checking for seqadj ext existence before adding
> it, so that the packet will not be dropped if seqadj ext already exists.

Applied, thanks.

> Note that as Florian mentioned, as a long term, we should review ext_add()
> behaviour, it's better to return a pointer to the existing ext instead.

That seems very reasonable to me, it would be good to see if a change
like that simplifies things.
