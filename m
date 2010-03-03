From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Wed, 3 Mar 2010 19:14:29 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003031911550.23256@obet.zrqbmnf.qr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr>
 <4B8C16A4.9010807@netfilter.org> <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41927 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0CCSOa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:14:30 -0500
In-Reply-To: <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-03 18:42, Jan Engelhardt wrote:
>
>If they are align-safe, what's this? :-)
>
>18:41 ares:/home/jengelh # conntrack -L
>Bus error
>18:41 ares:/home/jengelh # file `which conntrack`
>/usr/sbin/conntrack: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required,
>version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4,
>not stripped

(gdb) r -L
Starting program: /home/jengelh/code/conntrack-tools/src/conntrack -L

Program received signal SIGBUS, Bus error.
0xf7fa0c24 in __parse_counters (attr=0xffff9a0c, ct=0x301c8, dir=0)
    at parse.c:319
319                                     = __be64_to_cpu(*(u_int64_t *)
(gdb) l
314                                     = ntohl(*(u_int32_t *)
315                                             NFA_DATA(tb[CTA_COUNTERS32_PACKETS-1]));
316
317                     if (tb[CTA_COUNTERS_PACKETS-1])
318                             ct->counters[dir].packets
319                                     = __be64_to_cpu(*(u_int64_t *)
320                                             NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]));
321
322                     switch(dir) {
323                     case __DIR_ORIG:
(gdb) p NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]) 
$1 = (void *) 0xffff9a14

.......................^ There's the problem

(gdb) bt
#0  0xf7fa0c24 in __parse_counters (attr=0xffff9a0c, ct=0x301c8, dir=0)
    at parse.c:319
#1  0xf7fa14dc in __parse_conntrack (nlh=0xffff9980, cda=0xffff9878, 
    ct=0x301c8) at parse.c:494
#2  0xf7f9ec7c in __callback (nlh=0xffff9980, nfa=0xffff9878, data=0x301b8)
    at callback.c:30
#3  0xf7f7e4a8 in nfnl_step () from /usr/lib/libnfnetlink.so.0
#4  0xf7f7e6b4 in nfnl_process () from /usr/lib/libnfnetlink.so.0
#5  0xf7f7fc80 in nfnl_catch () from /usr/lib/libnfnetlink.so.0
#6  0xf7f9db04 in nfct_query (h=0x30150, qt=NFCT_Q_DUMP, data=0xffffd190)
    at api.c:801
#7  0x00015048 in main (argc=2, argv=0xffffd2d4) at conntrack.c:1275
