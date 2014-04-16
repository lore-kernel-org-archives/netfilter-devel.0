From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] set-elem: fix a memory leak
Date: Wed, 16 Apr 2014 20:09:42 +0200
Message-ID: <20140416180942.GB5144@localhost>
References: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
 <8df9d8df7c8a2c0fa13763fcae5e57f04a4d0362.1397556694.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50379 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaDPSJr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:09:47 -0400
Content-Disposition: inline
In-Reply-To: <8df9d8df7c8a2c0fa13763fcae5e57f04a4d0362.1397556694.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 12:13:47PM +0200, Ana Rey wrote:
> Valgrind reports the following memory leak:
> 
> valgrind  --leak-check=full ./nft-parsing-test -f jsonfiles/63-set.json
> ==7131== HEAP SUMMARY:
> ==7131==     in use at exit: 2 bytes in 1 blocks
> ==7131==   total heap usage: 155 allocs, 154 frees, 6,497 bytes allocated
> ==7131==
> ==7131== 2 bytes in 1 blocks are definitely lost in loss record 1 of 1
> ==7131==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
> ==7131==    by 0x590B829: strdup (strdup.c:42)
> ==7131==    by 0x4E4341A: nft_data_reg_json_parse (data_reg.c:55)
> ==7131==    by 0x4E4093A: nft_jansson_data_reg_parse (jansson.c:231)
> ==7131==    by 0x4E40A1B: nft_jansson_et_elem_parse (jansson.c:257)
> ==7131==    by 0x4E3CECA: nft_jansson_parse_set (set.c:398)
> ==7131==    by 0x4E3EC65: nft_ruleset_do_parse (ruleset.c:263)
> ==7131==    by 0x401479: test_json (nft-parsing-test.c:129)
> ==7131==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
> ==7131==    by 0x400EBB: main (nft-parsing-test.c:332)

Also applied, thanks Ana.
