From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] chain: fix segfault in 'device' XML parsing
Date: Tue, 13 Oct 2015 12:07:04 +0200
Message-ID: <20151013100704.GA2261@salvia>
References: <20151013073910.19469.65757.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39842 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbbJMKAB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 06:00:01 -0400
Content-Disposition: inline
In-Reply-To: <20151013073910.19469.65757.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 13, 2015 at 09:39:10AM +0200, Arturo Borrero Gonzalez wrote:
> Reported by valgrind:
> [...]
> ==14065== Process terminating with default action of signal 11 (SIGSEGV)
> ==14065==  Access not within mapped region at address 0x0
> ==14065==    at 0x4C2C022: strlen (vg_replace_strmem.c:454)
> ==14065==    by 0x4E41A93: nftnl_chain_set_str (chain.c:259)
> ==14065==    by 0x4E427F7: nftnl_mxml_chain_parse (chain.c:770)
> ==14065==    by 0x4E48F96: nftnl_ruleset_parse_chains (ruleset.c:314)
> ==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse_ruleset (ruleset.c:625)
> ==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse_cmd (ruleset.c:668)
> ==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse (ruleset.c:706)
> ==14065==    by 0x4E4959A: nftnl_ruleset_do_parse (ruleset.c:734)
> ==14065==    by 0x4013C9: test_xml (nft-parsing-test.c:166)
> ==14065==    by 0x4016F4: execute_test (nft-parsing-test.c:214)
> ==14065==    by 0x400EBA: main (nft-parsing-test.c:330)
> [...]
> 
> While at it, fix a bit the coding style.

Applied, thanks Arturo.
