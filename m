From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] segfault bug in simple ruleset, regression?
Date: Wed, 9 Sep 2015 16:29:03 +0200
Message-ID: <20150909142903.GA3447@salvia>
References: <CAOkSjBhk00k9H98Nx0hdxvrf5b8vAP5ad=iiKrdB2v4rHimoMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33027 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbbIIOW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 10:22:28 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhk00k9H98Nx0hdxvrf5b8vAP5ad=iiKrdB2v4rHimoMw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2015 at 01:28:38PM +0200, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> with current HEAD of nftables [0663bfe ("mnl: rework netlink socket
> receive path for events")] and with current nf-next HEAD kernel
> [851345c ("netfilter: reduce sparse warnings")] i'm hitting a
> segfault.
> There seem to be a strcmp over a NULL string.
> 
> Unfortunately I can't try to solve this myself right now.
> 
> It can be reproduced with this simple file:
> 
> ========== 8< ==========
> flush ruleset
> table inet filter {
>         chain test0 {
>         }
> 
>         chain test1 {
>         }
> 
>         chain test2 {
>         }
> 
>         chain test {
>                 oif vmap {
>                         eth0 : jump test0,
>                         eth1 : jump test1,
>                         eth2 : jump test2
>                 }
>         }
> }
> ========== 8< ==========
> 
> loaded with:
>  % nft -f file

I cannot reproduce this here using this:

table inet filter {
        chain test0 {
        }

        chain test1 {
        }

        chain test2 {
        }

        chain test {
                oif vmap {
                        eth0 : jump test0,
                        wlan0 : jump test1,
                        lo : jump test2
                }
        }
}


See file attached. Are you sure you're using latest nft?

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="out.txt"

# valgrind nft -f file
==4151== Memcheck, a memory error detector
==4151== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
==4151== Using Valgrind-3.7.0 and LibVEX; rerun with -h for copyright info
==4151== Command: nft -f l
==4151== 
==4151== Conditional jump or move depends on uninitialised value(s)
==4151==    at 0x4017741: index (strchr.S:40)
==4151==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4151==    by 0x400756B: fillin_rpath (dl-load.c:495)
==4151==    by 0x4007CF9: _dl_init_paths (dl-load.c:872)
==4151==    by 0x4002BC9: dl_main (rtld.c:1348)
==4151==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4151==    by 0x4004A15: _dl_start (rtld.c:331)
==4151==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4151==    by 0x2: ???
==4151==    by 0x7FF0006FE: ???
==4151==    by 0x7FF000702: ???
==4151==    by 0x7FF000705: ???
==4151== 
==4151== Use of uninitialised value of size 8
==4151==    at 0x401774F: index (strchr.S:47)
==4151==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4151==    by 0x400756B: fillin_rpath (dl-load.c:495)
==4151==    by 0x4007CF9: _dl_init_paths (dl-load.c:872)
==4151==    by 0x4002BC9: dl_main (rtld.c:1348)
==4151==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4151==    by 0x4004A15: _dl_start (rtld.c:331)
==4151==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4151==    by 0x2: ???
==4151==    by 0x7FF0006FE: ???
==4151==    by 0x7FF000702: ???
==4151==    by 0x7FF000705: ???
==4151== 
==4151== Conditional jump or move depends on uninitialised value(s)
==4151==    at 0x40177B4: index (strchr.S:77)
==4151==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4151==    by 0x400800D: _dl_map_object (dl-load.c:2538)
==4151==    by 0x400137D: map_doit (rtld.c:626)
==4151==    by 0x400E8B3: _dl_catch_error (dl-error.c:187)
==4151==    by 0x4000B2E: do_preload (rtld.c:815)
==4151==    by 0x4004127: dl_main (rtld.c:1634)
==4151==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4151==    by 0x4004A15: _dl_start (rtld.c:331)
==4151==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4151==    by 0x2: ???
==4151==    by 0x7FF0006FE: ???
==4151== 
==4151== Use of uninitialised value of size 8
==4151==    at 0x401786D: index (strchr.S:135)
==4151==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4151==    by 0x400800D: _dl_map_object (dl-load.c:2538)
==4151==    by 0x400137D: map_doit (rtld.c:626)
==4151==    by 0x400E8B3: _dl_catch_error (dl-error.c:187)
==4151==    by 0x4000B2E: do_preload (rtld.c:815)
==4151==    by 0x4004127: dl_main (rtld.c:1634)
==4151==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4151==    by 0x4004A15: _dl_start (rtld.c:331)
==4151==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4151==    by 0x2: ???
==4151==    by 0x7FF0006FE: ???
==4151== 
==4151== Syscall param socketcall.sendmsg(msg.msg_iov[i]) points to uninitialised byte(s)
==4151==    at 0x58080B0: __sendmsg_nocancel (syscall-template.S:81)
==4151==    by 0x41A027: mnl_batch_talk (mnl.c:241)
==4151==    by 0x4064E7: nft_run (main.c:203)
==4151==    by 0x40601C: main (main.c:357)
==4151==  Address 0x5cfac27 is 71 bytes inside a block of size 200,703 alloc'd
==4151==    at 0x4C29BED: malloc (vg_replace_malloc.c:263)
==4151==    by 0x503F171: nftnl_batch_page_alloc.isra.0 (batch.c:36)
==4151==    by 0x503F1FF: nft_batch_alloc (batch.c:73)
==4151==    by 0x419D98: mnl_batch_init (mnl.c:135)
==4151==    by 0x4063EE: nft_run (main.c:185)
==4151==    by 0x40601C: main (main.c:357)
==4151== 
==4151== 
==4151== HEAP SUMMARY:
==4151==     in use at exit: 834 bytes in 3 blocks
==4151==   total heap usage: 123 allocs, 120 frees, 227,812 bytes allocated
==4151== 
==4151== LEAK SUMMARY:
==4151==    definitely lost: 2 bytes in 1 blocks
==4151==    indirectly lost: 0 bytes in 0 blocks
==4151==      possibly lost: 0 bytes in 0 blocks
==4151==    still reachable: 832 bytes in 2 blocks
==4151==         suppressed: 0 bytes in 0 blocks
==4151== Rerun with --leak-check=full to see details of leaked memory
==4151== 
==4151== For counts of detected and suppressed errors, rerun with: -v
==4151== Use --track-origins=yes to see where uninitialised values come from
==4151== ERROR SUMMARY: 5 errors from 5 contexts (suppressed: 0 from 0)

# valgrind nft -f file
==4154== Memcheck, a memory error detector
==4154== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
==4154== Using Valgrind-3.7.0 and LibVEX; rerun with -h for copyright info
==4154== Command: nft -f l
==4154== 
==4154== Conditional jump or move depends on uninitialised value(s)
==4154==    at 0x4017741: index (strchr.S:40)
==4154==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4154==    by 0x400756B: fillin_rpath (dl-load.c:495)
==4154==    by 0x4007CF9: _dl_init_paths (dl-load.c:872)
==4154==    by 0x4002BC9: dl_main (rtld.c:1348)
==4154==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4154==    by 0x4004A15: _dl_start (rtld.c:331)
==4154==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4154==    by 0x2: ???
==4154==    by 0x7FF0006FE: ???
==4154==    by 0x7FF000702: ???
==4154==    by 0x7FF000705: ???
==4154== 
==4154== Use of uninitialised value of size 8
==4154==    at 0x401774F: index (strchr.S:47)
==4154==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4154==    by 0x400756B: fillin_rpath (dl-load.c:495)
==4154==    by 0x4007CF9: _dl_init_paths (dl-load.c:872)
==4154==    by 0x4002BC9: dl_main (rtld.c:1348)
==4154==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4154==    by 0x4004A15: _dl_start (rtld.c:331)
==4154==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4154==    by 0x2: ???
==4154==    by 0x7FF0006FE: ???
==4154==    by 0x7FF000702: ???
==4154==    by 0x7FF000705: ???
==4154== 
==4154== Conditional jump or move depends on uninitialised value(s)
==4154==    at 0x40177B4: index (strchr.S:77)
==4154==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4154==    by 0x400800D: _dl_map_object (dl-load.c:2538)
==4154==    by 0x400137D: map_doit (rtld.c:626)
==4154==    by 0x400E8B3: _dl_catch_error (dl-error.c:187)
==4154==    by 0x4000B2E: do_preload (rtld.c:815)
==4154==    by 0x4004127: dl_main (rtld.c:1634)
==4154==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4154==    by 0x4004A15: _dl_start (rtld.c:331)
==4154==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4154==    by 0x2: ???
==4154==    by 0x7FF0006FE: ???
==4154== 
==4154== Use of uninitialised value of size 8
==4154==    at 0x401786D: index (strchr.S:135)
==4154==    by 0x40073DD: expand_dynamic_string_token (dl-load.c:425)
==4154==    by 0x400800D: _dl_map_object (dl-load.c:2538)
==4154==    by 0x400137D: map_doit (rtld.c:626)
==4154==    by 0x400E8B3: _dl_catch_error (dl-error.c:187)
==4154==    by 0x4000B2E: do_preload (rtld.c:815)
==4154==    by 0x4004127: dl_main (rtld.c:1634)
==4154==    by 0x40152B4: _dl_sysdep_start (dl-sysdep.c:249)
==4154==    by 0x4004A15: _dl_start (rtld.c:331)
==4154==    by 0x4001197: ??? (in /lib/x86_64-linux-gnu/ld-2.19.so)
==4154==    by 0x2: ???
==4154==    by 0x7FF0006FE: ???
==4154== 
==4154== Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
==4154==    at 0x5808113: __sendto_nocancel (syscall-template.S:81)
==4154==    by 0x4198B2: nft_mnl_talk (mnl.c:80)
==4154==    by 0x41AED3: mnl_nft_set_dump (mnl.c:772)
==4154==    by 0x41322B: netlink_list_sets (netlink.c:1248)
==4154==    by 0x407647: cache_update (rule.c:79)
==4154==    by 0x40E759: cmd_evaluate (evaluate.c:2081)
==4154==    by 0x424E05: nft_parse (parser_bison.y:566)
==4154==    by 0x4063AC: nft_run (main.c:231)
==4154==    by 0x40601C: main (main.c:357)
==4154==  Address 0x7feff956f is on thread 1's stack
==4154== 
==4154== Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
==4154==    at 0x5808113: __sendto_nocancel (syscall-template.S:81)
==4154==    by 0x4198B2: nft_mnl_talk (mnl.c:80)
==4154==    by 0x41B2C2: mnl_nft_setelem_get (mnl.c:904)
==4154==    by 0x41356A: netlink_get_setelems (netlink.c:1512)
==4154==    by 0x4076AC: cache_update (rule.c:87)
==4154==    by 0x40E759: cmd_evaluate (evaluate.c:2081)
==4154==    by 0x424E05: nft_parse (parser_bison.y:566)
==4154==    by 0x4063AC: nft_run (main.c:231)
==4154==    by 0x40601C: main (main.c:357)
==4154==  Address 0x7feff955f is on thread 1's stack
==4154== 
==4154== Syscall param socketcall.sendmsg(msg.msg_iov[i]) points to uninitialised byte(s)
==4154==    at 0x58080B0: __sendmsg_nocancel (syscall-template.S:81)
==4154==    by 0x41A027: mnl_batch_talk (mnl.c:241)
==4154==    by 0x4064E7: nft_run (main.c:203)
==4154==    by 0x40601C: main (main.c:357)
==4154==  Address 0x5cfd047 is 71 bytes inside a block of size 200,703 alloc'd
==4154==    at 0x4C29BED: malloc (vg_replace_malloc.c:263)
==4154==    by 0x503F171: nftnl_batch_page_alloc.isra.0 (batch.c:36)
==4154==    by 0x503F1FF: nft_batch_alloc (batch.c:73)
==4154==    by 0x419D98: mnl_batch_init (mnl.c:135)
==4154==    by 0x4063EE: nft_run (main.c:185)
==4154==    by 0x40601C: main (main.c:357)
==4154== 
==4154== 
==4154== HEAP SUMMARY:
==4154==     in use at exit: 834 bytes in 3 blocks
==4154==   total heap usage: 189 allocs, 186 frees, 232,448 bytes allocated
==4154== 
==4154== LEAK SUMMARY:
==4154==    definitely lost: 2 bytes in 1 blocks
==4154==    indirectly lost: 0 bytes in 0 blocks
==4154==      possibly lost: 0 bytes in 0 blocks
==4154==    still reachable: 832 bytes in 2 blocks
==4154==         suppressed: 0 bytes in 0 blocks
==4154== Rerun with --leak-check=full to see details of leaked memory
==4154== 
==4154== For counts of detected and suppressed errors, rerun with: -v
==4154== Use --track-origins=yes to see where uninitialised values come from
==4154== ERROR SUMMARY: 7 errors from 7 contexts (suppressed: 0 from 0)

--ReaqsoxgOBHFXBhH--
