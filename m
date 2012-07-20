From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Problem with iptables accounting in Ubuntu Precise 12.04 LTS
Date: Sat, 21 Jul 2012 00:18:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207210014250.2166@frira.zrqbmnf.qr>
References: <CAHHzA4XF-f9LMTAmFpC65u0ikFd-9Sd76A0q+Qr5E9Xbr5eVEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: John Tran <njhtran@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:52522 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab2GTWSb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:18:31 -0400
In-Reply-To: <CAHHzA4XF-f9LMTAmFpC65u0ikFd-9Sd76A0q+Qr5E9Xbr5eVEQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-07-20 19:44, John Tran wrote:

>I'm trying to get iptables accounting working on Ubuntu 12.04 LTS
>amd64 yet not having much luck.  Here is what I'm getting and I hope
>someone can provide some insight to my problems:

>root@ubuntu-mbp:~# iptaccount -a
>
>libxt_ACCOUNT_cl userspace accounting tool v1.3
>
>get_table_names failed: Can't get table names from kernel. Out of
>memory, MINBUFISZE too small?

iptaccount requires that xt_ACCOUNT.ko be loaded, but the original 
authors did not add any autoloading facility.
