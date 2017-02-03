From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Concurrent iptables-restore calls clobberring each other
Date: Sat, 4 Feb 2017 00:47:10 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1702040040050.2578@erq.vanv.qr>
References: <CAB3ewxODtiHoKQChouTcYX7uZxHvHobxxCMLtOH_Uvkco9XaGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Shaun Crampton <shaun@cantab.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:36922 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752872AbdBCXrM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 18:47:12 -0500
In-Reply-To: <CAB3ewxODtiHoKQChouTcYX7uZxHvHobxxCMLtOH_Uvkco9XaGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2017-02-03 21:37, Shaun Crampton wrote:
>
>I'm trying to diagnose an incompatibility between my application
>(Project Calico's Felix daemon) and another (Kuberenetes' kube-proxy).
>Both are (ab)using iptables-restore to do high-speed bulk updates to
>iptables and they're both using --noflush so they can use
>iptables-restore to edit only some chains.  Mostly, this works great
>and it's many times faster than using individual iptables commands.
[...]
>My understanding is that each iptables-restore call actually does a
>read-modify-write of the whole table

This is by design; the RMW cycle in principle also affects the "slower"
iptables - which is why it is slower, because it does only one rule per cycle.
