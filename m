From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_request_find_match
Date: Tue, 9 Jan 2007 22:44:10 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701092213200.4779@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
	<4587D227.1000003@trash.net>
	<Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr>
	<4587E91A.2020903@trash.net>
	<Pine.LNX.4.61.0612191623490.10396@yvahk01.tjqt.qr>
	<4588F175.8060109@trash.net>
	<Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
	<4588FF92.9050607@trash.net>
	<Pine.LNX.4.61.0612232254110.10087@yvahk01.tjqt.qr>
	<45A37211.2010000@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A37211.2010000@trash.net>
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


On Jan 9 2007 11:44, Patrick McHardy wrote:
>> 
>> Yup, on the spot!
>> http://jengelh.hopto.org/f/chaostables/chaostables-0.1.tar.bz2
[-0.4.tar.bz2]
>> (Contains a target, but still something that could use 
>> xt_request_find_module.)
>
>That looks a bit silly, you combine matches and targets through
>code instead of through the ruleset.

xt_portscan consolidates multiple rules (at least 23 when done with 
rules only) into one. Instead of calling tcp_match() 23 times as part of 
-p tcp, it's done exactly once. By using ".proto = IPPROTO_TCP" in 
xt_portscan.c, the user is forced to specify -p tcp when doing `iptables 
-m portscan`. This means that xt_portscan_match() will always get a TCP 
packet, so we can save additional checks. Plus, we do not lose, for 
example, the offset check from tcp_match(), since -p tcp was specified.

Because of how 'portscan' works, the packet and connection mark 
inherently need to be changed - as part of a match, yes. (At least it's 
documented behavior!) I did not feel like adding another mark into 
struct sk_buff or struct ip_conntrack.

As far as xt_CHAOS goes, it is designed to work with all types of IP 
traffic, TCP, UDP, ICMP, and so on. (Read: I wanted it that way.) Doing 
just "if(ipproto == IPPROTO_TCP)" in xt_chaos_target() would leave out 
the offset check[*] from tcp_match(). To not duplicate code, xt_tcpudp 
is looked up and used.

[*] Is the offset check even meaningful?


I hope this makes the reason a bit clearer.
Thank you for your input.

Jan
-- 
