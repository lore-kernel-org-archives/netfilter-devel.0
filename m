From: Marcin Szczepaniak <szczepan@sieradz.info>
Subject: netfilter performance question
Date: Tue, 22 Mar 2005 12:42:53 +0000 (GMT)
Message-ID: <20050322122438.C70026@imperator.sieradz.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@lists.netfilter.org
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

Hi !

I am working on ethernet bridge device based on embedded linux and ADM5120 
chip. I want basic firewall funcionality in my kernel, but i dont need 
most of netfilter advanced features. Simply filtering based on source and 
dst ip address, source and dst port number and protocol type is everything 
what i need.

I've tested two configurations of kernel (i am using 2.6 kernel tree):
first - no netfilter enabled - my device was able to bridge 70 Mbit of 
traffic.
second - netfilter compiled in, but no rules applied - traffic is only 20 
Mbit :( Adding some test rules has minor affect to traffic. Simply 
existence of netfiler makes maximal possible traffic to be equal one third 
of that when only routing exists in kernel.

Then I found ebtables. As much simplier than netfilter it should be also 
much faster. But there is no way to use only ebtables. Netfilter must be 
enabled in .config if you want use ebtables.

So i have two questions:

1. Is it possible to simplify netfilter somehow ? I need only very basic
    filtering (no statefull inspection, only IP header based packet
    filtering) ? I need it to be much faster and much simplier than it is
    now. Maybe there is any 'light' version of netfiler ?

2. Is it possible to use only ebtables, without netfilter ?
