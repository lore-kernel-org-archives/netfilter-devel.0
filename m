From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: restore interface to index cache
Date: Mon, 6 Apr 2015 14:58:57 +0200
Message-ID: <20150406125857.GA13992@salvia>
References: <1428321991-10125-1-git-send-email-pablo@netfilter.org>
 <1428321991-10125-2-git-send-email-pablo@netfilter.org>
 <3C9F7A57-9442-4E37-952D-38A071E71B14@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47556 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbbDFMyt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 08:54:49 -0400
Content-Disposition: inline
In-Reply-To: <3C9F7A57-9442-4E37-952D-38A071E71B14@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 06, 2015 at 02:39:26PM +0200, Patrick McHardy wrote:
> Am 6. April 2015 14:06:31 MESZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> >+static int data_cb(const struct nlmsghdr *nlh, void *data)
> >+{
> >+	struct nlattr *tb[IFLA_MAX + 1] = {};
> >+	struct ifinfomsg *ifm = mnl_nlmsg_get_payload(nlh);
> >+	struct iface *iface;
> >+
> >+	iface = malloc(sizeof(struct iface));
> >+	if (iface == NULL)
> >+		memory_allocation_error();
> 
> Why not use x*alloc here?

Just changed this here, thanks.

BTW, not important but I'm still seeing netlink traffic here to
NETLINK_ROUTE.  Looking at the glibc code, it seems that getaddrinfo()
also internally retrieves the list of interfaces via netlink for each
call.
