From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 5/6] Port of NFCT plugin to new libnetfilter_conntrack
 API.
Date: Sat, 05 Apr 2008 17:45:37 +0200
Message-ID: <47F79EA1.7090401@netfilter.org>
References: <12065717514081-git-send-email-eric@inl.fr> <1206571752607-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34410 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752224AbYDEPps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:45:48 -0400
In-Reply-To: <1206571752607-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch is a port to the new libnetfilter_conntrack API of the NFCT
> plugin. To be able to send IP addresses to the IP2STR and IP2BIN module
> oob.family and oob.protocol keys have been added.

Applied, thanks. A patch on top of it to break lines at 80 columns would
be great.

> There is only a single function which is marked as deprecated. This is
> nfct_dump_conntrack_table_reset_counters. This function is used to dump
> periodically counters. By default, this feature is not used. IMHO we could
> suppress this code and use conntrackd for similar tasks.

As the counters are 32 bits, we can store 64 bits counters in userspace
and periodically dump-and-reset the counters. Thus, we ensure that the
probability of an overflow is low while using little memory in kernel
space. We think that we should fix this in ulogd.

The problem that I see, not directly related with this, is that if ulogd
does this counter-and-reset, it may break other existing application
polling to obtain the counters. Probably we need a netlink event to
notify to all processes that the counters have been reset.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
