From: Dong Wei <dwei.zh@gmail.com>
Subject: Potential risk in xt_socket match
Date: Wed, 14 Nov 2012 18:48:36 +0800
Message-ID: <CALy-_URurqp6bU1gwYDEXQk97JCC0B6_uv+0tP7Gzq9AVk_0Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab2KNKsg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:48:36 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so293037pbc.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Nov 2012 02:48:36 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, All

When I read net/netfilter/xt_socket.c, I found maybe there will be a
potential risk in this match.

Linux-3.4.4
socket_match(...)
{
    ...snip...
    sk = nf_tproxy_get_sock_v4(...);
    if (sk != NULL) {
          do_some_check();
          xt_socket_put_sk(sk);
          if (wildcard || !transparent)
               sk = NULL;
    }
    pr_debug(...);
    return sk != NULL;
}

Assuming that, we got the tproxyed socket by nf_tproxy_get_sock_v4()
and we should do some more check for it. Before we call
do_some_check(), xt_socket give up CPU to let other process run. In
this period, sk maybe updated. This is common for SMP CPU. Other CPU
maybe try to destroy the sk structure if socket process is killed or
even socket APP crashed. The sk structure will not be  really freed,
because we hold the ref of the sk, but maybe some structure members is
cleaned up.

When xt_socket match run again, sk members are changed.

So, should we use socket lock which is similar to tcp_v4_rcv() to
protect the sk structure we got by nf_tproxy_get_sock_v4()?

Like this:
    if (sk != NULL) {
          bh_lock_sock_nested(sk);
          do_some_check();
          bh_unlock_sock(sk);
          xt_socket_put_sk(sk);
          if (wildcard || !transparent)
               sk = NULL;
    }

Anyone have idea about this issue?
