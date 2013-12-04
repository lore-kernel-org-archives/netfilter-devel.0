From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: fixed memory leaks in nft_xtables_config_load
Date: Wed, 4 Dec 2013 12:21:22 +0100
Message-ID: <20131204112122.GB12266@localhost>
References: <1385981088-2984-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40698 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab3LDLV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:21:27 -0500
Content-Disposition: inline
In-Reply-To: <1385981088-2984-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 02, 2013 at 11:44:48AM +0100, Ana Rey wrote:
> Those errors are shown with the valgrind tool:
> 
> valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80
> 
> ==7377==
> ==7377== 16 bytes in 1 blocks are definitely lost in loss record 2 of 14
> ==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
> ==7377==    by 0x5955B02: nft_table_list_alloc (table.c:425)
> ==7377==    by 0x4186EB: nft_xtables_config_load (nft.c:2427)
> ==7377==    by 0x4189E6: nft_rule_append (nft.c:991)
> ==7377==    by 0x413A7D: add_entry.isra.6 (xtables.c:424)
> ==7377==    by 0x41524A: do_commandx (xtables.c:1176)
> ==7377==    by 0x4134DC: xtables_main (xtables-standalone.c:72)
> ==7377==    by 0x5B87994: (below main) (libc-start.c:260)
> ==7377==
> ==7377== 16 bytes in 1 blocks are definitely lost in loss record 3 of 14
> ==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
> ==7377==    by 0x5956A32: nft_chain_list_alloc (chain.c:888)
> ==7377==    by 0x4186F3: nft_xtables_config_load (nft.c:2428)
> ==7377==    by 0x4189E6: nft_rule_append (nft.c:991)
> ==7377==    by 0x413A7D: add_entry.isra.6 (xtables.c:424)
> ==7377==    by 0x41524A: do_commandx (xtables.c:1176)
> ==7377==    by 0x4134DC: xtables_main (xtables-standalone.c:72)
> ==7377==    by 0x5B87994: (below main) (libc-start.c:260)
> 
> Fix these leaks and consolidate error handling in the exit path of
> nft_xtables_config_load

Applied, thanks Ana.
