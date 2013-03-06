From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nftables] nftables: fix compilation when nf-netlink is
 a module
Date: Wed, 06 Mar 2013 12:20:33 +0100
Message-ID: <51372681.7010604@6wind.com>
References: <1362565597-2391-1-git-send-email-nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35557 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab3CFLUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:20:36 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so7147839wgb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Mar 2013 03:20:35 -0800 (PST)
In-Reply-To: <1362565597-2391-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 06/03/2013 11:26, Nicolas Dichtel a =C3=A9crit :
> nftables uses nfnl_[un]lock() and thus depends on CONFIG_NETFILTER_NE=
TLINK.
> It's not possible to have nftables built-in when CONFIG_NETFILTER_NET=
LINK is set
> to m.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
Please, forget this patch. It introduces a circular dependancy.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
