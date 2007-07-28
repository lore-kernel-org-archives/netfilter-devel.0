From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: The module I write seems to have conflict with iptables
Date: Sat, 28 Jul 2007 19:35:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707281934120.15125@fbirervta.pbzchgretzou.qr>
References: <46ACC923.6050600@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Zheng Da <zhengda1936@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46ACC923.6050600@gmail.com>
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


On Jul 29 2007 19:06, Zheng Da wrote:
>
> I write a module based on netfilter.
> It is proposed to be used in the filter router, is hooked on FORWARD point, and
> has the lowest priority, NF_IP_PRI_LAST.
> It does the following things:
> When it finds TCP connection from the client to the server, it will pretend as
> the server to build the connection with the client. It blocks the SYN and ACK
> packets from the client, and sends a UDP packet to the server, which can force
> the server build the TCP connection with the client.

It is almost impossible to help without seeing code.



	Jan
-- 
