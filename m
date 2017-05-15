From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: synproxy: fix conntrackd interaction
Date: Mon, 15 May 2017 19:55:49 +0200
Message-ID: <20170515175549.GA6393@salvia>
References: <20170515165238.GA3999@salvia>
 <fbaa0cbd-a13d-46e3-a796-023439433dda@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
        brouer@redhat.com
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55234 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933241AbdEORzy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 13:55:54 -0400
Content-Disposition: inline
In-Reply-To: <fbaa0cbd-a13d-46e3-a796-023439433dda@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 15, 2017 at 07:49:18PM +0200, Eric Leblond wrote:
>    Hello,
>    Le 15 mai 2017 6:52 PM, Pablo Neira Ayuso <pablo@netfilter.org> a
>    écrit :
> 
>      On Thu, May 11, 2017 at 06:56:38PM +0200, Eric Leblond wrote:
>      > This patch fixes the creation of connection tracking entry from
>      > netlink when synproxy is used. It was missing the addition of
>      > the synproxy extension.
>      >
>      > This was causing kernel crashes when a conntrack entry created by
>      > conntrackd was used after the switch of traffic from active node
>      > to the passive node.
>      Applied, thanks Eric.
> 
>    Thanks Pablo !
>    Will you push it to stable as it is causing a crash on older kernel
>    like 3.16?

Does this compile cleanly as is?

If so, I can just request -stable maintainer to take it as soon as
this hits upstream.
