From: Patrick Schaaf <bof@bof.de>
Subject: Re: a question on ipip encapsulation
Date: Fri, 7 Feb 2003 14:08:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030207130802.GD31556@oknodo.bof.de>
References: <000801c2cea8$971ef050$3d00a8c0@chenwei>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ???? <buaacst@163.com>
Content-Disposition: inline
In-Reply-To: <000801c2cea8$971ef050$3d00a8c0@chenwei>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 07, 2003 at 08:58:15PM +0800, ???? wrote:
>     I want to implement  ipip encapsulation .

Why? There already is an implementation in the base network stack,
and it should work fine together with iptables.

>     I use skb_push for a new ip header at NF_IP_POST_ROUTING, and use skb_pull at NF_IP_PRE_ROUTING.
>     I could ping well, but when I use ftp, it will not work, just like stop.

With the ipip implementation in the kernel, you have an explicit network
device, which has an MTU setting, which is observed by the base network
stack. If you did nothing of that sort, that will be your problem.
A ping with large data size, should also give you a problem.

ALWAYS test with all realistic packet sizes, when modifying
packet processors, especially if you modify the length of the packets.

best regards
  Patrick
