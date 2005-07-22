From: Patrick McHardy <kaber@trash.net>
Subject: Re: (Probably) it's a bug
Date: Fri, 22 Jul 2005 19:56:56 +0200
Message-ID: <42E13368.8020707@trash.net>
References: <20050721194841Z1186111-31917+1237@kps8.test.onet.pl>	<Pine.LNX.4.62.0507221443060.9072@bizon.gios.gov.pl>
	<Pine.LNX.4.61.0507221514440.28569@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marek Sirdak <marek@nevision.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507221514440.28569@yvahk01.tjqt.qr>
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

Jan Engelhardt schrieb:
>>>Dear Netfilter developers:
>>>
>>>I'm using iptables to protect my company network. My Kernel version is
>>>2.6.12 and iptables 1.3.2. Today I noticed that iptables cannot control
>>>broadcast traffic. For example I'm using DHCPd (version 3.0.2).
>>
>>Hm.. isc-dhcpd uses af_packet:
>>
>>Symbol: PACKET [=y]
>>"The Packet protocol is used by applications which communicate
>>directly with network devices without an intermediate network
>>protocol implemented in the kernel, e.g. tcpdump.  If you want them
>>to work, choose Y.
> 
> Interesting because I once failed to get DHCP because the Request packets hit 
> the default DROP policy...

Some clients use AF_PACKET, others use raw sockets, others use regular
UDP sockets. Everything besides AF_PACKET can be filtered by netfilter.
