From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bug report: Segfault on nested sets with prefixes
Date: Mon, 7 Sep 2015 20:49:29 +0200
Message-ID: <20150907184929.GA17921@salvia>
References: <55EC9890.1080205@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Wilmer van der Gaast <wilmer@gaast.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59873 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbIGSnA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 14:43:00 -0400
Content-Disposition: inline
In-Reply-To: <55EC9890.1080205@gaast.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 06, 2015 at 08:48:32PM +0100, Wilmer van der Gaast wrote:
> Hello,
> 
> The following ruleset causes a segfault:
> 
> #! /usr/sbin/nft -f
> 
> flush table inet filter
> 				
> define test1 = {
> 	1.1.1.0/24,
> }
> 
> define test2 = {
> 	$test1,
> 	2.2.2.0/24,
> }
> 								
> table inet filter {
> 	chain input {
> 		type filter hook input priority 0;
> 		ip saddr $test2 counter;
> 	}
> }
> 
> Either removing the /24s to make them addresses instead of prefixes,
> or including test1 instead of test2, avoids the crash.
> 
> Backtrace from valgrind:
> 
> ==21601== Process terminating with default action of signal 11 (SIGSEGV)
> ==21601==  Access not within mapped region at address 0x1D
> ==21601==    at 0x54C2EB0: __gmpz_cmp (in
> /usr/lib/x86_64-linux-gnu/libgmp.so.10.2.0)
> ==21601==    by 0x416CFA: ei_lookup.isra.0 (segtree.c:121)
> ==21601==    by 0x417040: ei_insert (segtree.c:189)
> ==21601==    by 0x417040: set_to_segtree (segtree.c:339)
> ==21601==    by 0x417040: set_to_intervals (segtree.c:440)
> ==21601==    by 0x406652: do_add_set (rule.c:659)
> ==21601==    by 0x406978: do_add_table (rule.c:679)
> ==21601==    by 0x406978: do_command_add (rule.c:695)
> ==21601==    by 0x407AEB: do_command (rule.c:1024)
> ==21601==    by 0x4060A5: nft_netlink (main.c:194)
> ==21601==    by 0x4060A5: nft_run (main.c:235)
> ==21601==    by 0x405C17: main (main.c:360)
> 
> Is this the right place to report issues like this?

Please, file a bug into Netfilter's bugzilla:

https://bugzilla.netfilter.org/

we'll look into that as soon as possible, thanks.
