From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Is my program is correct to print packet data part at IP layer?
Date: Sun, 02 Jan 2005 10:59:02 +1100
Message-ID: <1104623942.17292.6.camel@localhost.localdomain>
References: <20041231121303.59844.qmail@web52204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: linux lover <linux_lover2004@yahoo.com>
In-Reply-To: <20041231121303.59844.qmail@web52204.mail.yahoo.com>
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

On Fri, 2004-12-31 at 04:13 -0800, linux lover wrote:
> Respected sir,
>             I request you to please check my program
> and reply me whether it is the correct way of getting
> packets data part at IP layer? I am using netfilter
> and dumping its output to unsigned string. I just want
> to know the results return by following program is
> correct or wrong?

Hi,

	The data field may not be linear; it will be in pieces for many
packets.  Also, skb->data will point at the IP header, not the data
within the packet.  I recommend looking at ip_conntrack_ftp which has to
look inside TCP packets, for example.

Good luck!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
