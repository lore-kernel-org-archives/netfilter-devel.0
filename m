From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 0/8] Allow reuse of plugin instance (and misc fixes)
Date: Tue, 25 Mar 2008 11:03:33 +0100
Message-ID: <47E8CDF5.4010200@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35110 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752692AbYCYKDp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:03:45 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> This patchset starts with some cleaning:
>  - Add hook to list of fields in database for packet logging.
>  - Introduce RAWSTR type to avoid confusion in future developement.
>  - Fix indentation in ulogd_inppkt_NFLOG.c
> 
> Latest patches introduce a modification of plugin behaviour. It was not
> possible with existing code to reuse a plugin instance. For example, it
> is not possible to do :
> stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
> stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu2:LOGEMU

I'd appreciate a patch with a more realistic example that I can apply to
SVN.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
