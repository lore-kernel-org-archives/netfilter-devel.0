From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 06/17] iptables: fix order of internal commands list
Date: Sun, 30 Sep 2012 23:09:08 +0200
Message-ID: <20120930210908.GA13681@1984>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
 <1349000540-17508-7-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55597 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2I3VJX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:09:23 -0400
Content-Disposition: inline
In-Reply-To: <1349000540-17508-7-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 30, 2012 at 12:22:09PM +0200, Jan Engelhardt wrote:
> Specifying -S on the command line would add 4096 (0x1000, 1<<12) to the
> cmd flags, but -S was in fact commands_v_options[13]. This led to a
> bogus option checking and an error message:
> 
> $ iptables -A foo -S
> iptables v1.4.14: Cannot use -E with -A

Are you fixing old bugs?

This works here:

# iptables -A foo -S
iptables v1.4.15: Cannot use -S with -A

Try `iptables -h' or 'iptables --help' for more information.

See:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commit;h=067a9baf6dc82babe466078ab3c05354c7741271

> References: http://bugs.debian.org/642173
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
