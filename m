From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Iptables 1.4.11 can not be compiled with 2.6.39.1 kernel Debian
 Squeeze
Date: Tue, 7 Jun 2011 11:43:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106071142530.25037@frira.zrqbmnf.qr>
References: <4DEDF074.7070904@metu.edu.tr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40674 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1FGJnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:43:11 -0400
In-Reply-To: <4DEDF074.7070904@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-07 11:33, Lutfi ODUNCUOGLU wrote:

>Hello,
>
>I am just traying to compile iptables 1.4.11 under Debian Squeeze with
>kernel
>Linux test 2.6.39.1 #1 SMP Tue Jun 7 10:51:23 EEST 2011 x86_64 GNU/Linux
>
>I just did
>./configure
>make
>make install
>
>when I ls -la the /usr/local/sbin/iptables, the output is:
>
>
>lrwxrwxrwx 1 root staff 14 Jun  7 12:26 /usr/local/sbin/iptables ->
>iptables-multi
>
>But when I give the command
>
>/usr/local/sbin/iptables -V
>
>it returns me
>
>/usr/local/sbin/iptables: No such file or directory

This was later fixed in commit 71e402bbb3db7b54571f0e44354fd37706ff90aa.
