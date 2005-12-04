From: Patrick McHardy <kaber@trash.net>
Subject: Re: SNAT from multiple interfaces with the same IP?
Date: Sun, 04 Dec 2005 16:31:59 +0100
Message-ID: <43930BEF.9000602@trash.net>
References: <4392E148.7010102@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <4392E148.7010102@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Hi,
> 
> some time ago, I read that netfilter is unable to perform SNAT
> for identical ranges on different interfaces.
> 
> Scenario:
> 
> eth0: 192.168.0.1/16
> eth1: 192.168.0.1/16
> eth2: 10.2.0.1/8
> 
> iptables -t nat -A POSTROUTING -i eth0 -s 192.168.0.0/16 -j SNAT 
> --to-source 10.0.0.0-10.0.255.255
> iptables -t nat -A POSTROUTING -i eth1 -s 192.168.0.0/16 -j SNAT 
> --to-source 10.1.0.0-10.1.255.255
> 
> Will that work or is connection tracking unable to differentiate
> between the 192.168/16 subnets on eth0 and eth1? My problem is
> that although the ranges on eth0 and eth1 are sparsely populated,
> some IPs exist in both networks. Communication between the networks
> on eth0 and eth1 is not necessary, I just want them to be able to
> communicate with the outside (on eth2).

I don't see why it wouldn't work, but you can't use -i in POSTROUTING
directly, you need to mark the packets or just SNAT unconditionally.
