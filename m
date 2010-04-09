From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 finding.
Date: Fri, 09 Apr 2010 06:50:41 +0200
Message-ID: <1270788641.2458.15.camel@edumazet-laptop>
References: <4BBEA97A.5020303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43401 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0DIEur (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:50:47 -0400
Received: by bwz1 with SMTP id 1so2254819bwz.21
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Apr 2010 21:50:45 -0700 (PDT)
In-Reply-To: <4BBEA97A.5020303@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 09 avril 2010 =C3=A0 12:13 +0800, Changli Gao a =C3=A9crit =
:
> use hash table to speed up entry finding.
>=20
> If verdicts aren't received in order, list isn't efficient, and hash
> table is better.
>=20
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

You might add in Changelog that this would be the first flex_array use
in kernel.

> =20
> +static inline struct list_head *nfqnl_head_get(struct nfqnl_instance=
 *queue,
> +					       unsigned int id)
> +{
> +	return flex_array_get(queue->fa, id % queue->queue_htblsiz);
> +}
> +

A divide is expensive on many arches, yet in 2010.

When a divide by always the same unsigned int is performed, its good to
use a reciprocal divide.

See include/linux/reciprocal_div.h

I dont see flex_array use being useful if you preallocate all its slots=
=2E

flex_array_get()/fa_element_to_part_nr() are a monster if you ask me,
with many divides. You could submit patches to flex_array to use
reciprocal divide, and fa_element_to_part_nr() should be inlined, so
that flex_array_get() becomes a leaf function.

vmalloc() is way faster in my opinion. If not, vmalloc() should be
fixed.

ffffffff811b7174 <fa_element_to_part_nr>:
ffffffff811b7174:	55                   	push   %rbp
ffffffff811b7175:	48 63 3f             	movslq (%rdi),%rdi
ffffffff811b7178:	b8 00 10 00 00       	mov    $0x1000,%eax
ffffffff811b717d:	31 d2                	xor    %edx,%edx
ffffffff811b717f:	89 f6                	mov    %esi,%esi
ffffffff811b7181:	48 89 e5             	mov    %rsp,%rbp
ffffffff811b7184:	c9                   	leaveq=20
ffffffff811b7185:	48 f7 f7             	div    %rdi
ffffffff811b7188:	31 d2                	xor    %edx,%edx
ffffffff811b718a:	48 89 c1             	mov    %rax,%rcx
ffffffff811b718d:	48 89 f0             	mov    %rsi,%rax
ffffffff811b7190:	48 f7 f1             	div    %rcx
ffffffff811b7193:	c3                   	retq  =20

ffffffff811b7194 <flex_array_get>:
ffffffff811b7194:	55                   	push   %rbp
ffffffff811b7195:	48 89 e5             	mov    %rsp,%rbp
ffffffff811b7198:	41 54                	push   %r12
ffffffff811b719a:	41 89 f4             	mov    %esi,%r12d
ffffffff811b719d:	53                   	push   %rbx
ffffffff811b719e:	48 89 fb             	mov    %rdi,%rbx
ffffffff811b71a1:	e8 ce ff ff ff       	callq  ffffffff811b7174 <fa_ele=
ment_to_part_nr>
ffffffff811b71a6:	8b 53 04             	mov    0x4(%rbx),%edx
ffffffff811b71a9:	41 39 d4             	cmp    %edx,%r12d
ffffffff811b71ac:	73 35                	jae    ffffffff811b71e3 <flex_a=
rray_get+0x4f>
ffffffff811b71ae:	8b 0b                	mov    (%rbx),%ecx
ffffffff811b71b0:	0f af d1             	imul   %ecx,%edx
ffffffff811b71b3:	81 fa f8 0f 00 00    	cmp    $0xff8,%edx
ffffffff811b71b9:	77 2f                	ja     ffffffff811b71ea <flex_a=
rray_get+0x56>
ffffffff811b71bb:	48 83 c3 08          	add    $0x8,%rbx
ffffffff811b71bf:	48 63 f9             	movslq %ecx,%rdi
ffffffff811b71c2:	b8 00 10 00 00       	mov    $0x1000,%eax
ffffffff811b71c7:	31 d2                	xor    %edx,%edx
ffffffff811b71c9:	48 f7 f7             	div    %rdi
ffffffff811b71cc:	45 89 e4             	mov    %r12d,%r12d
ffffffff811b71cf:	31 d2                	xor    %edx,%edx
ffffffff811b71d1:	48 89 c6             	mov    %rax,%rsi
ffffffff811b71d4:	4c 89 e0             	mov    %r12,%rax
ffffffff811b71d7:	48 f7 f6             	div    %rsi
ffffffff811b71da:	0f af ca             	imul   %edx,%ecx
ffffffff811b71dd:	48 8d 04 0b          	lea    (%rbx,%rcx,1),%rax
ffffffff811b71e1:	eb 02                	jmp    ffffffff811b71e5 <flex_a=
rray_get+0x51>
ffffffff811b71e3:	31 c0                	xor    %eax,%eax
ffffffff811b71e5:	5b                   	pop    %rbx
ffffffff811b71e6:	41 5c                	pop    %r12
ffffffff811b71e8:	c9                   	leaveq=20
ffffffff811b71e9:	c3                   	retq  =20
ffffffff811b71ea:	48 98                	cltq  =20
ffffffff811b71ec:	48 8b 5c c3 08       	mov    0x8(%rbx,%rax,8),%rbx
ffffffff811b71f1:	48 85 db             	test   %rbx,%rbx
ffffffff811b71f4:	75 c9                	jne    ffffffff811b71bf <flex_a=
rray_get+0x2b>
ffffffff811b71f6:	eb eb                	jmp    ffffffff811b71e3 <flex_a=
rray_get+0x4f>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
