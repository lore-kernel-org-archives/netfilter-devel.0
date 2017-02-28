From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Tue, 28 Feb 2017 11:47:25 +0100
Message-ID: <20170228104725.GB1517@salvia>
References: <20170228045359.GA21582@gmail.com>
 <20170228050041.GC21582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbdB1LFL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:05:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5688A1AAB07
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 11:47:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45C89DA725
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 11:47:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 011FEDA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 11:47:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170228050041.GC21582@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ken-ichirou,

On Tue, Feb 28, 2017 at 02:00:41PM +0900, Ken-ichirou MATSUZAWA wrote:
> From 9e8aa4ed079b526faf190b69a2c1032f22776602 Mon Sep 17 00:00:00 2001
> From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> Date: Tue, 28 Feb 2017 11:34:29 +0900
> Subject: [PATCH 2/2] conntrack: revert getobjopt_is_nat condition
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  src/conntrack/objopt.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
> index fb43d6c..1581480 100644
> --- a/src/conntrack/objopt.c
> +++ b/src/conntrack/objopt.c
> @@ -144,10 +144,8 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
>  
>  static int getobjopt_is_snat(const struct nf_conntrack *ct)
>  {
> -	if (!(test_bit(ATTR_STATUS, ct->head.set)))
> -		return 0;
> -
> -	if (!(ct->status & IPS_SRC_NAT_DONE))
> +	if (test_bit(ATTR_STATUS, ct->head.set) &&
> +	    !(ct->status & IPS_SRC_NAT_DONE))

However, if ATTR_STATUS is not set, we keep checking ahead. What are
you trying to fix?
