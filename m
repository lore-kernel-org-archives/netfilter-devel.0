From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12 netfilter: local packets marked as invalid
Date: Fri, 08 Jul 2005 16:32:54 +0200
Message-ID: <42CE8E96.1040905@trash.net>
References: <42CE86B5.2080705@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel Drake <dsd@gentoo.org>
In-Reply-To: <42CE86B5.2080705@gentoo.org>
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

Daniel Drake wrote:
> When retrying the telnet test, this appears in the logs:
> 
> Jul  8 14:53:04 dsd inv IN=lo OUT=
> MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=127.0.0.1 DST=127.0.0.1
> LEN=40 TOS=0x10 PREC=0x00 TTL=64 ID=15 DF PROTO=TCP SPT=80 DPT=58950 WINDOW=0
> RES=0x00 ACK RST URGP=0
> 
> Does this mean that the kernel thinks its own ACK RST packet is invalid?

I think I know what happens. In 2.6.12 we started dropping the conntrack
reference when a packet leaves IP, so packets on loopback are tracked
twice (LOCAL_OUT/PRE_ROUTING). TCP connection tracking destroys a
conntrack entry when the only reply is an RST. So when the packet is
tracked for the second time in PRE_ROUTING, the conntrack entry can't
be found anymore and the packet is considered invalid.

You could confirm this theory by logging invalid packets in LOCAL_OUT
and in PRE_ROUTING - only PRE_ROUTING should trigger. I'm going to
think about a solution meanwhile.

Regards
Patrick
