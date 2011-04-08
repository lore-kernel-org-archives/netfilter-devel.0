From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Fri, 8 Apr 2011 21:54:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46577 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab1DHTyn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:54:43 -0400
In-Reply-To: <4D9F41BA.1060509@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-04-08 19:11, Ed W wrote:
>Starting "shorewall"
>- using busybox modprobe + released iptables = several minutes...
>- module-init-tools + released iptables = 12s
>- module-init-tools + your commit = 7.7s
>- module-init-tools + patching out modprobe completely = 4.9s
>
>So, whilst your patch has a huge positive benefit, I'm still seeing a
>substantial amount of cpu going to useless modprobing.

Which is only natural, because the kernel loads stuff. If you have
a problem with time (why so?) you should <*> the xtables modules,
and just leave iptables in its origin state.

>Of the rest of my 4.9s, 97% of that is waiting for iptables and tc to do
>stuff.  I need to profile further to see where the delays are though

Just how often are you calling iptables, anyway?
