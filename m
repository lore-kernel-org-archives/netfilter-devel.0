From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH nft] netlink_delinearize: add previous statement to rule_pp_ctx
Date: Thu, 17 Dec 2015 20:07:00 +0100
Message-ID: <CAAaDf4sYa2Jug5V0JhT73khGNcxhX+hZmB2JK3iD7MN0ApTc-A@mail.gmail.com>
References: <1450305535-18225-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33166 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbbLQTHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2015 14:07:03 -0500
Received: by mail-lf0-f52.google.com with SMTP id p203so58972596lfa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 11:07:01 -0800 (PST)
In-Reply-To: <1450305535-18225-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2015-12-16 23:38 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> 564b0e7c13f9 ("netlink_delinearize: postprocess expression before range
> merge") crashes nft when the previous statement is removed via
> payload_dependency_kill() as this pointer is not valid anymore.
>
> Move the pointer to the previous statement to rule_pp_ctx and invalid it
> when required.
>
> Reported-by: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/netlink_delinearize.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)

I have run the regression test suite and the problem seems to be fixed
with no side effects.

Tested-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
