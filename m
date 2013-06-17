From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Mon, 17 Jun 2013 15:41:24 +0300
Message-ID: <51BF03F4.4040300@linux.intel.com>
References: <20130617092600.2814.15883.stgit@localhost> <51BEE134.5010406@linux.intel.com> <20130617112917.GA3734@localhost> <CAFpD06SurkbCHH=54yPWwF06doyH5tnRbX4_ODA8Rj9g41QruA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3FQMl2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:41:28 -0400
In-Reply-To: <CAFpD06SurkbCHH=54yPWwF06doyH5tnRbX4_ODA8Rj9g41QruA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> I runned checkscript.pl with my patch, but i don't get any style issues.
> This is the output:
>
> ./scripts/checkpatch.pl --file /home/giuseppe/nft_chain_zero_counters.patch
> /home/giuseppe/nft_chain_zero_counters.patch:83: ERROR: trailing whitespace
> /home/giuseppe/nft_chain_zero_counters.patch:92: ERROR: trailing whitespace
> total: 2 errors, 0 warnings, 141 lines checked

It's due to --file option you used.

I get that:

WARNING: line over 80 characters
#56: FILE: iptables/nft.c:2884:
+        nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,

I ran it like: ./checkpatch.pl --no-tree <your patch>

--file option is for a plain source file, not a patch file.

Tomasz
