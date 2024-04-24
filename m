Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1C5140363
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713989287; cv=none; b=cG0caAzt8h5u6nYDwDUjKt0biGJP3OeWEW1f3fYwCfbJgnvfShzdtSMRJDGfKkZakrXWxNyzgioVxWOes0hVuGzLTpWdk2n/9IAgPJUJ37J3oyTbvuGwyzd+CJccsDu9a42xdxCmTytbDXRQ8tgf5ZDBWMkVe0CryamM0eQvcBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713989287; c=relaxed/simple;
	bh=lJbZGb0jlz2Q5BMo89WXveuO0puUJzLXR56RJCcc/i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSbn2V8xy2FkZT6JDIlJiqqx1gSPJsvGgQs5Ysj0GZFiuwIZwwTLPbKFK4oMU8iUE5DCS9tVs8ptmub+s1DB521f5+PwjcTP7N98dAkvlg49s0sVkT2alUaVsWzAfC96MGt1SHJl8ogGYwnUNukgb17sUvgMLIIxkL4KEI0SRLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 24 Apr 2024 22:08:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/7] A bunch of JSON printer/parser fixes
Message-ID: <ZilmoE1LAAMErFbU@calendula>
References: <20240309113527.8723-1-phil@nwl.cc>
 <ZilmMzQIAyvvuFqo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZilmMzQIAyvvuFqo@calendula>

On Wed, Apr 24, 2024 at 10:06:14PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Sat, Mar 09, 2024 at 12:35:20PM +0100, Phil Sutter wrote:
> > Fix the following flaws in JSON input/output code:
> > 
> > * Patch 3:
> >   Wrong ordering of 'nft -j list ruleset' preventing a following restore
> >   of the dump. Code assumed dumping objects before chains was fine in
> >   all cases, when actually verdict maps may reference chains already.
> >   Dump like nft_cmd_expand() does when expanding nested syntax for
> >   kernel submission (chains first, objects second, finally rules).
> > 
> > * Patch 5:
> >   Maps may contain concatenated "targets". Both printer and parser were
> >   entirely ignorant of that fact.
> > 
> > * Patch 6:
> >   Synproxy objects were "mostly" supported, some hooks missing to
> >   cover for named ones.
> > 
> > Patch 4 applies the new ordering to all stored json-nft dumps. Patch 7
> > adds new dumps which are now parseable given the fixes above.
> > 
> > Patches 1 and 2 are fallout fixes to initially make the whole shell
> > testsuite pass on my testing system.
> > 
> > Bugs still present after this series:
> > 
> > * Nested chains remain entirely unsupported
> > * Maps specifying interval "targets" (i.e., set->data->flags contains
> >   EXPR_F_INTERVAL bit) will be printed like regular ones and the parser
> >   then rejects them.
> 
> I am seeing memleaks when running tests after this series, please see
> attachment for reference.

It could actually be related to:

0ac39384fd9e json: Accept more than two operands in binary expressions

I did not bisect yet.

> Command `./../../src/nft -j list ruleset` failed
> >>>>
> 
> =================================================================
> ==84914==ERROR: LeakSanitizer: detected memory leaks
> 
> Direct leak of 40 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c3b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c3b)
>     #2 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #10 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #11 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #12 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #13 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #14 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #15 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #16 0x7fad73a90f1d in do_command src/rule.c:2624
>     #17 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #18 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #19 0x55c43466d377 in main src/main.c:533
>     #20 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Direct leak of 40 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c3b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c3b)
>     #2 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #6 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #7 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #8 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #9 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #10 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #11 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #12 0x7fad73a90f1d in do_command src/rule.c:2624
>     #13 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #14 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #15 0x55c43466d377 in main src/main.c:533
>     #16 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Direct leak of 40 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c3b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c3b)
>     #2 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #6 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #7 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #8 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #9 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #10 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #11 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #12 0x7fad73a90f1d in do_command src/rule.c:2624
>     #13 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #14 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #15 0x55c43466d377 in main src/main.c:533
>     #16 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Direct leak of 40 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c3b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c3b)
>     #2 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #10 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #11 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #12 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #13 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #14 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #15 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #16 0x7fad73a90f1d in do_command src/rule.c:2624
>     #17 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #18 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #19 0x55c43466d377 in main src/main.c:533
>     #20 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 256 byte(s) in 2 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74bdeaac  (/lib/x86_64-linux-gnu/libjansson.so.4+0x3aac)
>     #2 0x7ffd4687548f  ([stack]+0x1c48f)
> 
> Indirect leak of 250 byte(s) in 4 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74bdecda  (/lib/x86_64-linux-gnu/libjansson.so.4+0x3cda)
> 
> Indirect leak of 144 byte(s) in 2 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be396b in json_object (/lib/x86_64-linux-gnu/libjansson.so.4+0x896b)
>     #2 0x7ffd4687548f  ([stack]+0x1c48f)
> 
> Indirect leak of 128 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74bdeaac  (/lib/x86_64-linux-gnu/libjansson.so.4+0x3aac)
>     #2 0x7ffd46875a9f  ([stack]+0x1ca9f)
> 
> Indirect leak of 72 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be396b in json_object (/lib/x86_64-linux-gnu/libjansson.so.4+0x896b)
>     #2 0x7ffd46875a9f  ([stack]+0x1ca9f)
> 
> Indirect leak of 64 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c6b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c6b)
>     #2 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #10 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #11 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #12 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #13 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #14 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #15 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #16 0x7fad73a90f1d in do_command src/rule.c:2624
>     #17 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #18 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #19 0x55c43466d377 in main src/main.c:533
>     #20 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 64 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c6b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c6b)
>     #2 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #10 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #11 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #12 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #13 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #14 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #15 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #16 0x7fad73a90f1d in do_command src/rule.c:2624
>     #17 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #18 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #19 0x55c43466d377 in main src/main.c:533
>     #20 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 64 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c6b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c6b)
>     #2 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #3 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #4 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #5 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #6 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #7 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #8 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #9 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #10 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #11 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #12 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #13 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #14 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #15 0x7fad73a90f1d in do_command src/rule.c:2624
>     #16 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #17 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #18 0x55c43466d377 in main src/main.c:533
>     #19 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 64 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c6b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c6b)
>     #2 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #6 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #7 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #8 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #9 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #10 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #11 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #12 0x7fad73a90f1d in do_command src/rule.c:2624
>     #13 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #14 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #15 0x55c43466d377 in main src/main.c:533
>     #16 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 64 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c6b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c6b)
>     #2 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #3 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #6 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #7 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #8 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #9 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #10 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #11 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #12 0x7fad73a90f1d in do_command src/rule.c:2624
>     #13 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #14 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #15 0x55c43466d377 in main src/main.c:533
>     #16 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 64 byte(s) in 2 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3ed4 in json_stringn_nocheck (/lib/x86_64-linux-gnu/libjansson.so.4+0x8ed4)
> 
> Indirect leak of 40 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be3c3b in json_array (/lib/x86_64-linux-gnu/libjansson.so.4+0x8c3b)
>     #2 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #3 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #4 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #5 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #6 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #7 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #8 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #9 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #10 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #11 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #12 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #13 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #14 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #15 0x7fad73a90f1d in do_command src/rule.c:2624
>     #16 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #17 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #18 0x55c43466d377 in main src/main.c:533
>     #19 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 24 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be431d in json_integer (/lib/x86_64-linux-gnu/libjansson.so.4+0x931d)
>     #2 0x7fad73abe8dc in datatype_json src/json.c:975
>     #3 0x7fad73abf15a in constant_expr_json src/json.c:1003
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #10 0x7fad73ab83e7 in __binop_expr_json src/json.c:549
>     #11 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #12 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #13 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #14 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #15 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #16 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #17 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #18 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #19 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #20 0x7fad73a90f1d in do_command src/rule.c:2624
>     #21 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #22 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #23 0x55c43466d377 in main src/main.c:533
>     #24 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 24 byte(s) in 1 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be431d in json_integer (/lib/x86_64-linux-gnu/libjansson.so.4+0x931d)
>     #2 0x7fad73abe8dc in datatype_json src/json.c:975
>     #3 0x7fad73abf15a in constant_expr_json src/json.c:1003
>     #4 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #5 0x7fad73ab84aa in __binop_expr_json src/json.c:552
>     #6 0x7fad73ab8483 in __binop_expr_json src/json.c:550
>     #7 0x7fad73ab8571 in binop_expr_json src/json.c:559
>     #8 0x7fad73aaff68 in expr_print_json src/json.c:53
>     #9 0x7fad73ac1b55 in ct_stmt_json src/json.c:1248
>     #10 0x7fad73ab09a6 in stmt_print_json src/json.c:96
>     #11 0x7fad73ab3410 in rule_print_json src/json.c:248
>     #12 0x7fad73ac7ff8 in table_print_json_full src/json.c:1741
>     #13 0x7fad73ac8537 in do_list_ruleset_json src/json.c:1763
>     #14 0x7fad73acbcc0 in do_command_list_json src/json.c:1986
>     #15 0x7fad73a8e84f in do_command_list src/rule.c:2354
>     #16 0x7fad73a90f1d in do_command src/rule.c:2624
>     #17 0x7fad7399e2f4 in nft_netlink src/libnftables.c:42
>     #18 0x7fad739a488c in nft_run_cmd_from_buffer src/libnftables.c:598
>     #19 0x55c43466d377 in main src/main.c:533
>     #20 0x7fad72a46249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
> 
> Indirect leak of 8 byte(s) in 2 object(s) allocated from:
>     #0 0x7fad744b89cf in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
>     #1 0x7fad74be0fb4  (/lib/x86_64-linux-gnu/libjansson.so.4+0x5fb4)
> 
> SUMMARY: AddressSanitizer: 1490 byte(s) leaked in 26 allocation(s).
> <<<<

