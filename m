Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563B8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhLIAlS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:41:18 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41988 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLIAlR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 19:41:17 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F9A7605BA;
        Thu,  9 Dec 2021 01:35:22 +0100 (CET)
Date:   Thu, 9 Dec 2021 01:37:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/6] libxtables: Add xtables_exit_tryhelp()
Message-ID: <YbFP1PI+NSUD238i@salvia>
References: <20211209002257.21467-1-phil@nwl.cc>
 <20211209002257.21467-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209002257.21467-4-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 09, 2021 at 01:22:54AM +0100, Phil Sutter wrote:
> This is just the exit_tryhelp() function which existed three times in
> identical form with a more suitable name.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/xtables.h    |  1 +
>  iptables/ip6tables.c | 19 ++++---------------
>  iptables/iptables.c  | 19 ++++---------------
>  iptables/xtables.c   | 21 +++++----------------
>  libxtables/xtables.c | 10 ++++++++++
>  5 files changed, 24 insertions(+), 46 deletions(-)
> 
> diff --git a/include/xtables.h b/include/xtables.h
> index ca674c2663eb4..fdf77d83199d0 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -501,6 +501,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
>  
>  extern struct xtables_globals *xt_params;
>  #define xtables_error (xt_params->exit_err)
> +extern void xtables_exit_tryhelp(int status) __attribute__((noreturn));

Probably add this to xshared.c instead of libxtables?
