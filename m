From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH] libxtables: duplicated loopback address via
 host_to_ipaddr()
Date: Thu, 9 Mar 2017 08:32:56 +0100
Message-ID: <20170309073256.GB32270@gmail.com>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35626 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdCIHdH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 02:33:07 -0500
Received: by mail-lf0-f47.google.com with SMTP id j90so24429053lfk.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Mar 2017 23:32:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 03:33:04PM +0100, Pablo Neira Ayuso wrote:
> Originally reported as a iptables-translate problem, but this also
> affects iptables and ip6tables.
> 
>  $ iptables-translate -A INPUT -s localhost -j ACCEPT
> 
> gives duplicated rules:
> 
>  nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept
>  nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept
> 
> This handling sucks, but libc seem to need if we have 127.0.0.1 and ::1
> entries in /etc/hosts that are common in many distros.
> 
> For more info, see:
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=4980
> https://bugzilla.redhat.com/show_bug.cgi?id=496300
> 
> Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Was going to test it, but it does not apply.

Applying: libxtables: duplicated loopback address via host_to_ipaddr()
error: patch failed: libxtables/xtables.c:1375
error: libxtables/xtables.c: patch does not apply
Patch failed at 0001 libxtables: duplicated loopback address via host_to_ipaddr()
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

-- 
Mit freundlichen Grüßen

Alexander Alemayhu
