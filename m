From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ip{,6}tables-save misleading return code
Date: Thu, 17 Oct 2013 10:39:27 +0200
Message-ID: <20131017083927.GA8330@localhost>
References: <20131014203816.CC16360191@smtp.hushmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: mancha <mancha1@hush.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55933 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3JQIje (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:39:34 -0400
Content-Disposition: inline
In-Reply-To: <20131014203816.CC16360191@smtp.hushmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Oct 14, 2013 at 08:38:16PM +0000, mancha wrote:
> Hello, this came up on freenode's #netfilter today.
> 
> ip{,6}tables-save(8), when run as an unprivileged user (who
> doesn't have access to /proc/net/ip{,6}_tables_names), displays
> no output and returns 0 because of a Boolean inversion.
> 
> luser@myhost:~$ iptables-save; echo $? 
> 0
> 
> The patch below changes the return to 1 if fopen() fails.
> Additionally, one could add "if (errno == EACCESS)" conditioned
> error messages.

Need your Signed-off-by tag / full name to take this patch, please,
let me know. No need to resend, I'll amend it. Thanks.
