Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E6CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 08:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD86E613DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 08:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243480AbhI2IM2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:12:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59872 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244580AbhI2IM1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Sep 2021 04:12:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id F292A63EC4;
        Wed, 29 Sep 2021 10:09:21 +0200 (CEST)
Date:   Wed, 29 Sep 2021 10:10:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Bernhard M. Wiedemann" <bwiedemann@suse.de>
Cc:     Larry Len Rainey <llrainey15@gmail.com>,
        Manfred Schwarb <manfred99@gmx.ch>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH] Fix typo in ipset-translate man page
Message-ID: <YVQfggOPewM2RFjg@salvia>
References: <20210929075543.28054-1-bwiedemann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210929075543.28054-1-bwiedemann@suse.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Sep 29, 2021 at 09:55:43AM +0200, Bernhard M. Wiedemann wrote:
> originally reported in
> https://lists.opensuse.org/archives/list/factory@lists.opensuse.org/thread/ZIXKNQHSSCQ4ZLEGYYKLAXQ4PQ5EYFGZ/
> by Larry Len Rainey

Applied, thanks.

> Signed-off-by: Bernhard M. Wiedemann <bwiedemann@suse.de>
> ---
>  src/ipset-translate.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ipset-translate.8 b/src/ipset-translate.8
> index bb4e737..55ce2a9 100644
> --- a/src/ipset-translate.8
> +++ b/src/ipset-translate.8
> @@ -33,7 +33,7 @@ to \fBnftables(8)\fP.
>  The only available command is:
>  
>  .IP \[bu] 2
> -ipset-translate restores < file.ipt
> +ipset-translate restore < file.ipt
>  
>  .SH USAGE
>  The \fBipset-translate\fP tool reads an IP sets file in the syntax produced by
> -- 
> 2.26.2
> 
