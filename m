From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: netfilter performance question
Date: Sat, 02 Apr 2005 11:04:59 +0000
Message-ID: <1112439899.3430.5.camel@localhost.localdomain>
References: <20050322122438.C70026@imperator.sieradz.info>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcin Szczepaniak <szczepan@sieradz.info>
In-Reply-To: <20050322122438.C70026@imperator.sieradz.info>
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

Op di, 22-03-2005 te 12:42 +0000, schreef Marcin Szczepaniak:
> I've tested two configurations of kernel (i am using 2.6 kernel tree):
> first - no netfilter enabled - my device was able to bridge 70 Mbit of 
> traffic.
> second - netfilter compiled in, but no rules applied - traffic is only 20 
> Mbit :( Adding some test rules has minor affect to traffic. Simply 
> existence of netfiler makes maximal possible traffic to be equal one third 
> of that when only routing exists in kernel.

Are you using connection tracking? Then try to minimize the overload of
it, see
http://ebtables.sourceforge.net/brnf-faq.html#quiz1

> Then I found ebtables. As much simplier than netfilter it should be also 
> much faster. But there is no way to use only ebtables. Netfilter must be 
> enabled in .config if you want use ebtables.

Ebtables with simple rules won't be faster than iptables with simple
rules and connection tracking disabled.

cheers,
Bart
