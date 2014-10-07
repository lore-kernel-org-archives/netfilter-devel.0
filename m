From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: kill nf_send_reset6() from
 include/net/netfilter/ipv6/nf_reject.h
Date: Tue, 07 Oct 2014 10:52:44 -0700
Message-ID: <1412704364.11091.145.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1412703950-1281-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60345 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaJGRws (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:52:48 -0400
Received: by mail-pd0-f171.google.com with SMTP id ft15so5450025pdb.30
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Oct 2014 10:52:48 -0700 (PDT)
In-Reply-To: <1412703950-1281-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2014-10-07 at 19:45 +0200, Pablo Neira Ayuso wrote:
> nf_send_reset6() now resides in net/ipv6/netfilter/nf_reject_ipv6.c
> 
> Fixes: c8d7b98 ("netfilter: move nf_send_resetX() code to nf_reject_ipvX modules")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/ipv6/nf_reject.h |  155 +-------------------------------
>  1 file changed, 1 insertion(+), 154 deletions(-)

LGTM ;)

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks Pablo.


