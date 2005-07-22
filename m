From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: (Probably) it's a bug
Date: Fri, 22 Jul 2005 15:15:20 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507221514440.28569@yvahk01.tjqt.qr>
References: <20050721194841Z1186111-31917+1237@kps8.test.onet.pl>
	<Pine.LNX.4.62.0507221443060.9072@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Marek Sirdak <marek@nevision.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0507221443060.9072@bizon.gios.gov.pl>
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

>> Dear Netfilter developers:
>> 
>> I'm using iptables to protect my company network. My Kernel version is
>> 2.6.12 and iptables 1.3.2. Today I noticed that iptables cannot control
>> broadcast traffic. For example I'm using DHCPd (version 3.0.2).
>
> Hm.. isc-dhcpd uses af_packet:
>
> Symbol: PACKET [=y]
> "The Packet protocol is used by applications which communicate
> directly with network devices without an intermediate network
> protocol implemented in the kernel, e.g. tcpdump.  If you want them
> to work, choose Y.

Interesting because I once failed to get DHCP because the Request packets hit 
the default DROP policy...



Jan Engelhardt
-- 
