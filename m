From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: code to display contents for iptables -L not getting invoked |
 Its      a test module
Date: Thu, 11 Feb 2010 21:46:14 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002112143310.27738@obet.zrqbmnf.qr>
References: <62174.152.14.247.142.1265919307.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35017 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab0BKUqQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:46:16 -0500
In-Reply-To: <62174.152.14.247.142.1265919307.squirrel@webmail.ncsu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 21:15, Balaji Venkatamohan wrote:
>
>I developed a match extension and successfully compiled the code into the
>extensions directory. I was also able to insert the desired rule and got
>the expected performance/output. Everything seems to work fine except that
>when I issue iptables -L, it shows under the desired chain that a rule is
>present but it doesn't print the contents under the function _mt_print()
>function of libxt_*.c file. I am getting the message that 'unknown match
><matchname>'.
>
>Can anyone tell me where I am going wrong?

Is it perhaps possible that you called iptables -L without making
available the location of your module? (in case it's not in the
standard search patch) If you only compiled Xt-a, but not install
anything, then something like

 XTABLES_LIBDIR=$my/extensions:$standardpath iptables {-A|-L} ...

is needed. This needs to be present at both insert time as well
as when you run with -L.

The standard path depends on distro, each seems to want to roll
their own cookiecoloring (/usr/libexec/iptables, /usr/lib64/iptables,
/lib64/iptables are some examples...)
