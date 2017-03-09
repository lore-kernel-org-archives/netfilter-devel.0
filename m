From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH iptables 1/2] iptables-translate: print nft command for
 each expand rules via dns names
Date: Thu, 9 Mar 2017 08:23:26 +0100
Message-ID: <20170309072326.GA32270@gmail.com>
References: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35049 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdCIHba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 02:31:30 -0500
Received: by mail-lf0-f42.google.com with SMTP id j90so24405616lfk.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Mar 2017 23:30:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 02:16:09PM +0100, Pablo Neira Ayuso wrote:
> After this patch:
> 
>  # iptables-translate -I INPUT -s yahoo.com
>  nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter
>  nft insert rule ip filter INPUT ip saddr 98.138.253.109 counter
>  nft insert rule ip filter INPUT ip saddr 98.139.183.24 counter
>
The first run returns similiar to above, but subsequent runs returns one
extra nft printed at the end.

# iptables-translate -I INPUT -s yahoo.com
nft insert rule ip filter INPUT ip saddr 98.139.183.24 counter 
nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter 
nft insert rule ip filter INPUT ip saddr 98.138.253.109 counter 
nft 
# git ll
48ad179bfdfd (libxtables: abolish AI_CANONNAME, 2017-03-08)
# git ll c6df55d6ebbe6102ac5136ae38813bea42d8c782
c6df55d6ebbe (iptables-translate: print nft command for each expand rules via dns names, 2017-03-08)

Thanks.
-- 
Mit freundlichen Grüßen

Alexander Alemayhu
