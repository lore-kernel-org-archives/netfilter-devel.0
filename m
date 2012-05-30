From: jay patel <jaypatel150@gmail.com>
Subject: netfilter bridging and enqueue_to_backlog
Date: Wed, 30 May 2012 08:46:29 -0600
Message-ID: <CAADX0Ry5tg54324VM_eDXRHxSOxrwoVA0_N+YZbuJ3c3PTN25Q@mail.gmail.com>
References: <CAADX0RzKAijpiU7_MpUfziyhzD+CTb6oxgXeqb==XoNSVMKk7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44555 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2E3Oq3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 May 2012 10:46:29 -0400
Received: by pbbrp8 with SMTP id rp8so50626pbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 30 May 2012 07:46:29 -0700 (PDT)
In-Reply-To: <CAADX0RzKAijpiU7_MpUfziyhzD+CTb6oxgXeqb==XoNSVMKk7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

We are trying to move an skb from cpu 0 to cpu1 using enqueue to backlog. We
have gotten this to work when bridging is turned off. However, with bridging
turned on it is proving to be a little more difficult.

After bridging is turned on, we try to do an enqueue_to_backlog in the
netfilter/core.c/nf_iterate function. We do this after pre routing is
completed for NF_BR_PRE_ROUTING and NF_INET_PRE_ROUTING hooks.

However, it seems after the enqueue_to_backlog happens, the packet is
dropped at some point (it seems the packet is processed as a local in packet
after it moves to cpu 1, and thus is dropped by the kernel). We see that in
__netif_receive_skb, that the skb->dev,skb->protocol (along with some other
fields in the skb are changed) when the skb is processed on cpu1. We can see
that in br_nf_pre_routing function call there are some modifications to some
of the same fields mentioned.

So our question is what needs to happen to the skb in order for the skb to
process as normal when it is put on cpu1? Is this possible with bridging
turned on?

Thanks,
~Jay
