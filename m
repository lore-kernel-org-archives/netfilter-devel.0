From: Steven Barth <cyrus@openwrt.org>
Subject: Re: [nft PATCHv2 0/4] support for mini-gmp / embedded friendliness
Date: Wed, 07 Jan 2015 13:29:02 +0100
Message-ID: <54AD268E.8020702@openwrt.org>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org> <20150107122218.GA15735@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:58265 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbbAGM3K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:29:10 -0500
In-Reply-To: <20150107122218.GA15735@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On 07.01.2015 13:22, Pablo Neira Ayuso wrote:
>
> I think you mentioned to me already but
>
>   configure: error: --with-mini-gmp MUST be used with --disable-debug
>
> any reason to enforce this?

The problem here is that pr_debug expands to gmp_printf which is not 
part of mini-gmp and the little replacement mpz_printf I added only 
allows for formatting a single mpz_t (which is enough for all the 
non-debug cases).

So there are 3 options basically.
1. Try to make gmp_printf standalone and port it from libgmp to mini-gmp.
     This looked like a huge and complicated effort and would likely 
blow up stuff considerably again.
2. Replace pr_debug's gmp_printf with regular printf and rewrite all the 
debug-calls to mpz_get_str()
     and free() which sounds painful.
3. Simply disabling debugging with mini-gmp.
     Easy way out without obstructing things too much otherwise.
