From: =?UTF-8?Q?st=c3=a9phane_bryant?= <stephane.ml.bryant@gmail.com>
Subject: Re: [PATCH nf-next v3 2/3] netfilter: bridge: pass L2 header and VLAN
 as netlink attributes in queues to userspace
Date: Sat, 5 Mar 2016 19:32:18 +0100
Message-ID: <56DB2632.1020308@gmail.com>
References: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455959230-3680-2-git-send-email-stephane.ml.bryant@gmail.com>
 <20160229124032.GA15467@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36530 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcCESc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 13:32:27 -0500
Received: by mail-wm0-f65.google.com with SMTP id l68so4035349wml.3
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Mar 2016 10:32:27 -0800 (PST)
In-Reply-To: <20160229124032.GA15467@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> 
> Stephane, I'm very looking forward to having this update pushed
> mainstream.
> 
> However, this I think it would be good if you can translate this to
> use nested attributes.
> 
> See nla_nest_start() and nla_nest_end(). Then, add a new vlan
> attributes for this:
> 
>         enum nfqnl_vlan_attr {
>                 NFQA_VLAN_UNSPEC,
>                 NFQA_VLAN_PROTO,
>                 NFQA_VLAN_TCI,
>                 __NFQA_VLAN_MAX,
>         };
>         #define NFQA_VLAN_MAX   (__NFQA_VLAN_MAX + 1)
> 
> Using structure to encapsulate netlink data is highly discouraged. I
> know we're doing this already in old attribute but that we cannot
> change since it's part of the ABI. But I would like that we start
> doing this the right way for new attributes.

Apologies for the delay -- i missed the email. I will try to get this
done within 3 weeks.


