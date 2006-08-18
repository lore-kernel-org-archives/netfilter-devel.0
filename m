From: Patrick McHardy <kaber@trash.net>
Subject: Re: lots of oopses
Date: Fri, 18 Aug 2006 20:23:29 +0200
Message-ID: <44E605A1.5000007@trash.net>
References: <44E49911.6080007@ufomechanic.net> <44E4A1AB.3000001@trash.net>
	<44E56D39.50806@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: l7-filter-developers@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44E56D39.50806@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>> BTW, what is ipt_vlan?
>>   
> 
> I think I posted it here a year ago, but I'll do so again if you want it.
> It matches on vlan-id.
> 
> It was said that strictly this is a layer 2 thing and not for iptables;
> I find it useful though;-
> which iptables rules should be applied may depend on vlan stuff, and
> sometimes it seems like there isn't enough mark to go around...
> 
> I like the iptables/ebtables seperation but sometimes it seems like they
> should be able to share each-others matches, like one big happy table
> with a few extra points of inspection. Anyway...

Agreed. It should be possible for ebtables to use all iptables matches
looking only at packet data, but not necessarily the other way around.
Unfortunately ebtables is in large parts a copy of iptables, with just
enough differences to prevent it from using x_tables.
