From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] socket: creating a struct mnl_socket from a
 pre-existing socket
Date: Mon, 22 Sep 2014 12:54:56 +0200
Message-ID: <20140922105456.GA6952@salvia>
References: <20140920060536.GA15209@gmail.com>
 <20140922102432.GA6074@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48021 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaIVKxu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:53:50 -0400
Content-Disposition: inline
In-Reply-To: <20140922102432.GA6074@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 22, 2014 at 12:24:32PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Sep 20, 2014 at 03:05:37PM +0900, Ken-ichirou MATSUZAWA wrote:
> > This patch defines a new function mnl_socket_fdopen() which
> > creates a struct mnl_socket object from a pre-existing netlink
> > socket obtained from other process. Now I think of the socket
> > is obtained from child process via send/recvmsg().
> 
> OK, you can also use this to send netlink messages using different
> domain/type sockets from the same process too, I'm going to attach
> this to the description.

I just noticed that, for your usecase, nl->addr is going to be left
unset. So getsockname() is also needed to set nl->addr if the socket
is of netlink type, otherwise, the portID zero should already tell us
that this is not a netlink socket, since this portID is reserved to
the kernel when netlink is used.

Could you address this and resend the patch including my comments in
the previous email? Thanks.

