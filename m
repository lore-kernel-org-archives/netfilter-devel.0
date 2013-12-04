From: Florian Westphal <fw@strlen.de>
Subject: Re: [nftables PATCH] netlink: do not SIGSEGV when socket() fails
Date: Wed, 4 Dec 2013 21:30:30 +0100
Message-ID: <20131204203030.GE2767@breakpoint.cc>
References: <CAOkSjBjay9HZ9Lz2b8Amf=BQLsZac_YCpM+J_KnVxaLy1cg+tg@mail.gmail.com>
 <1386187281-24493-1-git-send-email-shawn@churchofgit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Shawn Landden <shawn@churchofgit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33936 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab3LDUae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:30:34 -0500
Content-Disposition: inline
In-Reply-To: <1386187281-24493-1-git-send-email-shawn@churchofgit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shawn Landden <shawn@churchofgit.com> wrote:
> +	if (nf_sock == NULL) {
> +		fprintf(fdopen(STDERR_FILENO, "a"),
> +			"Could not open AF_NETLINK socket: %s\n",
> +			strerror(errno));

Why this fdopen() [ which can fail ] construct?
