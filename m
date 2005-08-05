From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables 1.3.1 crashes on iptables-restore
Date: Fri, 05 Aug 2005 11:08:45 +0100
Message-ID: <42F33AAD.8060201@ufomechanic.net>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>
	<42F24151.1090702@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42F24151.1090702@ufomechanic.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I'm now on iptables 1.3.3 because 1.3.1 with pablo's opt_merge patch
results in access of unallocated memory, 1.3.3 does not.

1.3.3 still hangs but does not segfault.
1.3.3 with simple rule sets has a clean valgrind report but this sort of
stuff for layer7

==30940== 8729 bytes in 115 blocks are definitely lost in loss record 6 of 7
==30940==    at 0x1B903D1C: malloc (vg_replace_malloc.c:131)
==30940==    by 0x1BC56C33: pre_process (libipt_layer7.c:142)
==30940==    by 0x1BC5702F: parse_layer7_protocol (libipt_layer7.c:267)
==30940==    by 0x1BC57142: parse (libipt_layer7.c:281)
==30940==
==30940==
==30940== 58880 bytes in 115 blocks are definitely lost in loss record 7
of 7
==30940==    at 0x1B903D1C: malloc (vg_replace_malloc.c:131)
==30940==    by 0x1BC56D8D: readl7dir (libipt_layer7.c:171)
==30940==    by 0x1BC56F9A: parse_layer7_protocol (libipt_layer7.c:234)
==30940==    by 0x1BC57142: parse (libipt_layer7.c:281)


So I will use that as my clues from now on, but it looks like iptables
1.3.3 is "clean" and layer7 needs looking at.

Sam
