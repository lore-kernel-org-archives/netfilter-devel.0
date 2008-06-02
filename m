From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Mon, 02 Jun 2008 18:41:44 +0100
Message-ID: <484430D8.10106@gmx.ch>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751401AbYFBRlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:41:46 -0400
In-Reply-To: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> [NETFILTER] Accounting rework: ct_extend + 64bit counters
> 
> Initially netfilter has had 64bit counters for conntrack-based accounting, but
> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit counters are
> still required, for example for "connbytes" extension. However, 64bit counters
> waste a lot of memory and it was not possible to enable/disable it runtime.
[...]
> Patch against 2.6.26-rc4, it would be nice if it can be included
> in 2.6.27.

Just to notice: recently nf_ct_kill_acct() has been introduced which 
accounts packets on abnormal connection termination. This function has 
to be changed as well.

See:
http://git.kernel.org/?p=linux/kernel/git/kaber/nf-next-2.6.git;a=commit;h=8d38001bd4a51fd5571ca84a40a7cddeca1e472d
and
http://git.kernel.org/?p=linux/kernel/git/kaber/nf-next-2.6.git;a=commit;h=0943b274f3fa89f7dd5d8d435d81e2e929e13c3a
