From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: don't call
 nfnetlink_set_err() if nfnetlink_send() fails
Date: Thu, 2 Mar 2017 19:29:47 +0100
Message-ID: <20170302182947.GA10168@gmail.com>
References: <1488466189-22844-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33575 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdCBUJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 15:09:45 -0500
Received: by mail-lf0-f48.google.com with SMTP id a6so38816073lfa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Mar 2017 12:09:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488466189-22844-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 03:49:49PM +0100, Pablo Neira Ayuso wrote:
> The underlying nlmsg_multicast() already sets sk->sk_err for us to
> notify socket overruns, so we should not do anything with this return
> value. So we just call nfnetlink_set_err() if:
> 
> 1) We fail to allocate the netlink message.
> 
> or
> 
> 2) We don't have enough space in the netlink message to place the attribute,
>    which means that we likely need to allocate a larger message.
> 
> Before this patch, the internal ESRCH netlink error code which is very
> misleading. Netlink semantics mandate that listeners hit ENOBUFS if the
> socket buffer overruns.
> 
> Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Alexander Alemayhu <alexander@alemayhu.com>

-- 
Mit freundlichen Grüßen

Alexander Alemayhu
