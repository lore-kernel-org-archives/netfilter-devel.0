From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] ruleset: fix a leak when we use the set lists
Date: Fri, 13 Feb 2015 16:57:28 +0100
Message-ID: <20150213155728.GA6287@salvia>
References: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
 <1423689142-6300-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbbBMPyL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2015 10:54:11 -0500
Content-Disposition: inline
In-Reply-To: <1423689142-6300-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 11, 2015 at 10:12:22PM +0100, Alvaro Neira Ayuso wrote:
> ==18632== 285 (16 direct, 269 indirect) bytes in 1 blocks are definitely lost in
> loss record 6 of 6
> ==18632==    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
> ==18632==    by 0x5043822: nft_set_list_alloc (set.c:977)
> ==18632==    by 0x5045483: nft_ruleset_json_parse (ruleset.c:442)
> ==18632==    by 0x50458BE: nft_ruleset_do_parse (ruleset.c:696)
> ==18632==    by 0x408AEC: do_command (rule.c:1317)
> ==18632==    by 0x406B05: nft_run (main.c:194)
> ==18632==    by 0x40667C: main (main.c:360)

Also applied. I found more leaks, just pushed a patch to fix them
