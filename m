From: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
Subject: Re: problems with netlink_broadcast
Date: Wed, 14 Jan 2004 13:34:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4005376A.9070209@fokus.fraunhofer.de>
References: <4003DCD7.6040602@fokus.fraunhofer.de> <400424F7.9040508@trash.net> <400435F7.7070309@fokus.fraunhofer.de> <40052746.80400@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pablo neira <pablo@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Pablo,

> I think that you are trying to create a skbuff with no netlink header 
> because you set last parameter of NLMSG_PUT to 0.

NLMSG_PUT allocates a buffer of NLMSG_LENGTH(len), which according to its definition:

     #define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(sizeof(struct nlmsghdr)))

should create room for exactly one nlmsghdr in my case.

anyway, in one of the cases when I managed to make it work (as mentioned in my first email) the data could be received 
in user space.

> Anyway, if it doesn't work have a look at ip_queue.c and ipt_ULOG.c. It 
> could help you out.

I will check them in more detail.

cheers,
John.
