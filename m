From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libnfnetlink
Date: Wed, 11 Oct 2006 12:32:59 +0200
Message-ID: <452CC85B.4000105@trash.net>
References: <1159531818.451d0d2a31b47@www.domainfactory-webmail.de>
	<451D2B3B.7070604@trash.net> <4521185D.8040005@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Maik Hentsche <netfilter@mm-double.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4521185D.8040005@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> what do you think about the following solution?
> 
> 
>>	if (len < sizeof(struct nlmsgerr)
>>	    || len < sizeof(struct nlmsghdr))
> 
> 
> errno = EBADMSG;
> 
> 
>>[...]
>>	if (addrlen != sizeof(peer))
> 
> 
> errno = EINVAL;
> 
> 
>>		return -1;
>>
>>	if (peer.nl_pid != 0)
> 
> 
> errno = ENOMSG;

The above all seem fine.

> 
>>		return -1;
>>
>>	nlh = (struct nlmsghdr *)buf;
>>	if (nlh->nlmsg_flags & MSG_TRUNC || status > len)
> 
> 
> errno = ENOSPC;

ENOSPC is fine for MSG_TRUNC, but it is a msghdr flag, not nlmsg.
status > len implies serious recvmsg brokeness and it doesn't
really make sense to check for kernel bugs, so I'd remove it.
