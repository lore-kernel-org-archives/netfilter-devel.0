From: Florian Westphal <fw@strlen.de>
Subject: Re: Bug: nft cannot identify elements in set correctly
Date: Mon, 11 Aug 2014 11:32:17 +0200
Message-ID: <20140811093217.GB14182@breakpoint.cc>
References: <1407748711-21183-1-git-send-email-ycnian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Yanchuan Nian <ycnian@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaHKJcT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:32:19 -0400
Content-Disposition: inline
In-Reply-To: <1407748711-21183-1-git-send-email-ycnian@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yanchuan Nian <ycnian@gmail.com> wrote:
> [root@localhost ~]# nft add set ip filter servicelist {type inet_service \;}
> [root@localhost ~]# nft add element ip filter servicelist {ftp,ssh}
> <cmdline>:1:35-37: Error: syntax error, unexpected string, expecting '{'
> add element ip filter servicelist ftp ssh

Missing escape ("\{"), see echo foo{bar,baz}

> [root@localhost ~]# nft add element ip filter servicelist {ftp, ssh}
> 
> There must be a space between ftp and ssh, otherwise bison ignores "{".

The { got removed by your shell before passing the arguments to nft.
