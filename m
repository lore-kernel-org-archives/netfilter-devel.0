From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC,PATCH] introduce new API for libnfnetlink
Date: Mon, 19 Jun 2006 01:26:58 +0200
Message-ID: <4495E142.5000209@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi!

I have been spending some time on libnfnetlink these days based on a 
previous patch that I sent some time ago [1]. Since the amount of 
changes would result in API breakages, that is something that I consider 
that we don't want, I decided to start some kind of version 2 of 
libnfnetlink, the major changes from the current version is:

- Uniform error handling via errno
- Use of new netlink ADD_MEMBERSHIP socket option to join multicast groups
- A new approach for challenge functions listen/talk, now they use the 
callbacks registered via register_callback()
- Single loop processing: nfnetlink_process()
- Iterators: more control for the programmer in the nfnetlink data 
processing
- addattr* simplification
- Documentation available

The patch is available at:

http://people.netfilter.org/pablo/libnfnetlink-newapi.patch

This is still a work in progress, it needs more testing. I have plans to 
do something similar for libnetfilter_conntrack in order to solve the 
existing limitations.

Comments welcome.

[1] http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3315

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
