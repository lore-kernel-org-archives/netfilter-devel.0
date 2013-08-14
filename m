From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] xml: expr: fix mem leak in the expr parser
Date: Wed, 14 Aug 2013 11:17:56 +0200
Message-ID: <20130814091756.GA5771@localhost>
References: <20130812123335.25249.17288.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53927 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab3HNJSH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:18:07 -0400
Content-Disposition: inline
In-Reply-To: <20130812123335.25249.17288.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Aug 12, 2013 at 02:33:35PM +0200, Arturo Borrero Gonzalez wrote:
> There was several mem leaks as reported by valgrind:
> 
> ==23503== 3 bytes in 1 blocks are definitely lost in loss record 1 of 44
> ==23503==    at 0x4C28BED: malloc (vg_replace_malloc.c:263)
> ==23503==    by 0x56F1B41: strdup (strdup.c:43)
> ==23503==    by 0x4E3BE62: nft_rule_expr_exthdr_xml_parse (exthdr.c:212)
> ==23503==    by 0x4E3909A: nft_mxml_expr_parse (mxml.c:49)
> ==23503==    by 0x4E368CC: nft_rule_parse (rule.c:581)
> ==23503==    by 0x401462: main (nft-parsing-test.c:255)
> 
> So, once those string are used, do a free.

I have fixed this in a different way. Most callers don't seem to need
the string duplication, therefore, I decided to remove it. We save the
many free invocations that your patch needed. We save some lines of
code.

Regards.
