From: "msn" <msn@vtopia.co.kr>
Subject: Kernel Oops in the ip_conntrack_proto_gre.c
Date: Fri, 25 Jan 2008 17:46:54 +0900 (KST)
Message-ID: <4397.211.111.195.128.1201250814.squirrel@mail.vtopia.co.kr>
Reply-To: msn@vtopia.co.kr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.vtopia.co.kr ([211.111.194.2]:36030 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754953AbYAYJwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:52:23 -0500
Received: from localhost.localdomain (ns1 [127.0.0.1])
	by localhost.localdomain (8.12.8/8.12.8) with ESMTP id m0P8ksrr023655
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jan 2008 17:46:54 +0900
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, This is the stituations what i'm having right now. you can try that
way, it is dying all the time.

Kernel : 2.4.30
Patchs :
ip_conntrack_pptp.		v1.9
ip_conntrack_proto_gre.c	v1.2
ip_nat_pptp.c			v1.5
ip_nat_proto_gre.c		v1.2

A(CLIENT). 5 more pptp connections to 'B' with same address binding
           Yes, This is wrong way.
B(SERVER). Panic


Suspicion :

/* destroy the keymap entries associated with specified expect */
void ip_ct_gre_keymap_destroy(struct ip_conntrack_expect *exp)
{
        DEBUGP("entering for exp %p\n", exp);
        WRITE_LOCK(&ip_ct_gre_lock);
        if (exp->proto.gre.keymap_orig) {
                DEBUGP("removing %p from list\n",
exp->proto.gre.keymap_orig);
                list_del(&exp->proto.gre.keymap_orig->list);
<============  HERE IS THE POINT ALWAYS Oops
                kfree(exp->proto.gre.keymap_orig);
                exp->proto.gre.keymap_orig = NULL;
        }
        if (exp->proto.gre.keymap_reply) {
                DEBUGP("removing %p from list\n",
exp->proto.gre.keymap_reply);
                list_del(&exp->proto.gre.keymap_reply->list);
                kfree(exp->proto.gre.keymap_reply);
                exp->proto.gre.keymap_reply = NULL;
        }
        WRITE_UNLOCK(&ip_ct_gre_lock);
}

Messages :

Unable to handle kernel NULL pointer dereference at virtual address 000000cd
 printing eip:
c02c530c
*pde = 00000000
Oops: 0002
CPU:    1
EIP:    0010:[<c02c530c>]    Not tainted
EFLAGS: 00010286
eax: f46d79c0   ebx: f4627880   ecx: 00000000   edx: 000000c9
esi: f43a6980   edi: 00000000   ebp: 00000000   esp: f7755cac
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=f7755000)
Stack: c0358a91 f46d79c0 f46d79c0 f46d79c4 f46d79c0 f7c6f780 c02c18b6
f4627880
       00000004 f7c6f780 00000004 c19ef000 c0250658 f43a6980 00000004
f7755d48
       c19ef000 c025f3ef f7c6f780 f7755d48 00000004 00000000 c19ef000
f7755d14
Call Trace:    [<c02c18b6>] [<c0250658>] [<c025f3ef>] [<c0287d00>]
[<c0284a50>]
  [<c02860bc>] [<c0287d00>] [<c0284a50>] [<c0284a9f>] [<c021796a>]
[<c0260f13>]
  [<c0217a16>] [<c025efd6>] [<c0284a50>] [<c025f3c3>] [<c0284a50>]
[<c028497a>]
  [<c0284a50>] [<c0282fdd>] [<c02832b0>] [<c0254f77>] [<c01c1b6f>]
[<c01c1530>]
  [<c025522f>] [<c0121da6>] [<c0121dbf>] [<c010b109>] [<c0107000>]
[<c010d9a8>]
  [<c0107000>] [<c0107029>] [<c01070c2>] [<c011cf75>] [<c011d1e0>]

Code: 89 4a 04 89 11 c7 40 04 00 00 00 00 c7 00 00 00 00 00 8b 83
 <0>Kernel panic: Aiee, killing interrupt handler

Thanks in advance.

Cheers



