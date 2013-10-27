From: WGH <wgh@torlan.ru>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 22:22:43 +0400
Message-ID: <526D59F3.9070805@torlan.ru>
References: <526C22B8.5030102@torlan.ru> <20131027153408.GA20634@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward3l.mail.yandex.net ([84.201.143.136]:49231 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3J0S2C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:28:02 -0400
In-Reply-To: <20131027153408.GA20634@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.10.2013 19:34, Phil Oester wrote:
> If this is a problem for you, then increase nf_conntrack_tcp_timeout_established
> to an insanely high value.  You do realize, of course, that the conntrack
> table has a finite number of entries.
It'll delay the problem, but not fix it. Besides, it'll worsen the
situtation that established timeout intended to fix - genuinely crashed
connections will linger for said insane value.
> Keepalives should be done in the application, not in the firewall. 
Why not, actually? It isn't strictly keep-alive in application sense,
but rather a way that NAT may use to detect broken connections. It
addresses breakage caused by NAT itself, while keep-alives issued by
application will address other problems (like physical connection loss),
if necessary.
