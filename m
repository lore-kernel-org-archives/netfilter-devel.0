From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: socket filter
Date: Thu, 19 Aug 2010 22:04:31 -0700
Message-ID: <20100819220431.381da765@nehalam>
References: <AANLkTi=_YJTBy5pPfgBAi-cNt=ock0UGGcdD=X94YtUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:33879 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab0HTFEd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:04:33 -0400
In-Reply-To: <AANLkTi=_YJTBy5pPfgBAi-cNt=ock0UGGcdD=X94YtUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Aug 2010 09:57:33 +0530
krunal patel <krunal.raj@gmail.com> wrote:

> Hi,
> 
> There are ioctl's for attaching bpf like filters to socket. I found it
> in kernel documentation.
>     setsockopt(sockfd, SOL_SOCKET, SO_ATTACH_FILTER, &Filter, sizeof(Filter));
> I doubt is can we attach filters in case of netlink socket.
> I am logging all packets using ULOG target and using ulogd.
> Is it possible to use same ioctl for netlink socket we create in ulogd?

You can use socket filters on netlink sockets since  2.6.26
