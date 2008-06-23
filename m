From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 4/6] Introduce datatype and hwaddrlen param to MAC2STR
 plugin.
Date: Mon, 23 Jun 2008 16:42:50 +0200
Message-ID: <485FB66A.1090601@netfilter.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-5-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45600 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754687AbYFWOm6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:42:58 -0400
In-Reply-To: <1213878187-909-5-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch introduces a hwaddrlen and datatype parameters in
> MAC2STR configuration. This is a workaround differences between
> ULOG and NFLOG:
>  * NFLOG sends MAC address in userspace (dev_parse_header content)
>  * ULOG sends complete link header (skb_mac_header content)
> And they use the same field (raw.mac) for that. Database schema
> needs mac.saddr.str and/or mac.daddr.str fields. With datatype set
> 0 only mac.daddr is logged. Both fields are filled when datatype is
> set to 1.

Why not split KEY_RAW_MAC into two keys in the input plugins, eg.
KEY_RAW_SMAC and KEY_RAW_DMAC? Thus, we inconditionally dump the source
and the destination MAC if they are present.

I'm not a big fun of adding options that can confuse users.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
