From: Patrick McHardy <kaber@trash.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 16:52:46 +0200
Message-ID: <426FA73E.3090605@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
	<426F64C8.1070601@trash.net> <426FA44A.2010008@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Juha Heljoranta <juha.heljoranta@evtek.fi>
In-Reply-To: <426FA44A.2010008@evtek.fi>
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

Juha Heljoranta wrote:
> Ideas how to identify sending process are indeed needed. How about
> adding sender information (pid) into skb?

Well, it seems the whole concept of associating sockets with processes
is flawed, a socket can be owned by any number of processes, and even a
single packet can be created by multiple processes. For outgoing packets
it would be possible to store the pid in the skb and handle the unlikely
case of a packet created by multiple processes somehow, but for incoming
packets we really don't know which process is going to receive a packet
until it calls recvmsg(). This is too late for filtering with netfilter
because multiple references (device, conntrack, ..) need to be dropped
earlier.

Regards
Patrick
