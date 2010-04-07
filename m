From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
	lookup by id
Date: Wed, 7 Apr 2010 21:30:42 +0800
Message-ID: <y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59826 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab0DGNbF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:31:05 -0400
Received: by pwj9 with SMTP id 9so913402pwj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 06:31:03 -0700 (PDT)
In-Reply-To: <4BBC711E.7050602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 7, 2010 at 7:48 PM, Patrick McHardy <kaber@trash.net> wrote=
:
> Changli Gao wrote:
>
> This doesn't compile:
>
> net/netfilter/nfnetlink_queue.c:57: error: field 'idr' has incomplete=
 type
> net/netfilter/nfnetlink_queue.c: In function 'instance_create':
> net/netfilter/nfnetlink_queue.c:112: error: implicit declaration of
> function 'idr_init'
> net/netfilter/nfnetlink_queue.c: In function 'instance_destroy_rcu':
> net/netfilter/nfnetlink_queue.c:143: error: implicit declaration of
> function 'idr_destroy'
> net/netfilter/nfnetlink_queue.c: In function 'find_dequeue_entry':
> net/netfilter/nfnetlink_queue.c:170: error: implicit declaration of
> function 'idr_find'
> net/netfilter/nfnetlink_queue.c:170: warning: assignment makes pointe=
r
> from integer without a cast
> net/netfilter/nfnetlink_queue.c:172: error: implicit declaration of
> function 'idr_remove'
> net/netfilter/nfnetlink_queue.c: In function 'nfqnl_flush':
> net/netfilter/nfnetlink_queue.c:188: error: implicit declaration of
> function 'idr_get_next'
> net/netfilter/nfnetlink_queue.c:188: warning: assignment makes pointe=
r
> from integer without a cast
> net/netfilter/nfnetlink_queue.c: In function 'nfqnl_build_packet_mess=
age':
> net/netfilter/nfnetlink_queue.c:253: error: implicit declaration of
> function 'idr_pre_get'
> net/netfilter/nfnetlink_queue.c:254: error: implicit declaration of
> function 'idr_get_new'

I cooked this patch aginst linux-next. And I have noticed net-next
wasn't synced with linux-next yet.

>
> I'm interested in how this affects performance for the vast majority
> of users, which process messages in order. A simple hash table looks
> like a better choice here since we know the maximum number of entries
> in advance and also could have the user specify the desired hash size=
=2E
>

If there aren't much packets queued, the packet ids will be around 0,
and idr isn't much slower.

>
> You probably shouldn't be making the entry visible before the message
> is successfully built and sent.

I wanted to keep the changeset small. But it seems wrong.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
