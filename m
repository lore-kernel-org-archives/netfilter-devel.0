From: Dung Nguyen Anh <dnguyenanh@yahoo.com>
Subject: how to handle both ipv4 and ipv6 in libipq
Date: Tue, 3 Aug 2004 00:42:47 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040803074247.93560.qmail@web41507.mail.yahoo.com>
References: <20040803070402.31635.3641.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040803070402.31635.3641.Mailman@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all,

I want use lipipq to capture ipv4 and ipv6 packets by
libipq, but the libipq is only support one.
So I modify the following:
- add 2 fd sockets in ipq_handle to support ipv4
(NETLINK_FIREWALL) and ipv6 (NETLINK_IP6_FW)
- In ipq_create_handle(), create both 2 sockets and
binding them.
- in ipq_netlink_recvfrom() select on 2 fds, if have
packet comming, then process at proper file
descriptor. the current fd will be keep in structure
to support for ipq_set_verdict()

I write the program to capture and display info of
packets receiving, it run ok both ipv4/ipv6 packets.

But, in some cases, I want when to get a ipv4 packet I
need reinject a ipv6 packet (instead of ipv4 packet).
If I use verdict to put ipv6 packet to kernel at ipv4
queue, then it is not go through more, may it is drop
because in-proper queue

I am newbie for make target in netfilter, so I woud
like to know how-to reinject a ipv6 to queue6 when I
am standing ipv4 queue?
or what's mechanism in netfilter can help me to do
following:
- capture all ipv4/ipv6
- reinject any type of packet (ipv6/ipv4)

I appreciate your help.




		
__________________________________
Do you Yahoo!?
Yahoo! Mail - You care about security. So do we.
http://promotions.yahoo.com/new_mail
