From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Defragmentation question
Date: Sun, 12 Sep 2004 23:18:25 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409122313040.28735@filer.marasystems.com>
References: <BAY10-F49ZndN8dtdCV0001bf58@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sergio C <sergnut@hotmail.com>
In-Reply-To: <BAY10-F49ZndN8dtdCV0001bf58@hotmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 10 Sep 2004, Sergio C wrote:

> I thought about the possibility that an intruder uses IP fragmentation for 
> evade the sensors, for example, the SYN scan sensor could be evaded if the 
> fragmentation cuts the TCP header, same with ICMP header and ICMP flooding 
> sensor, etc... I was doing some tests with fragroute and hping2 to see what 
> happens if an intruder try to fragment their packets. The results are that 
> all the sensors continue working without problems. And my question is... Does 
> netfilter apply some kind of defragmentation before NF_IP_LOCAL_OUT?

If you have conntrack loaded then there is a defragmentor very early in 
NF_IP_LOCAL_OUT and NF_IP_PRE_ROUTING, part of conntrack.

If you have not loaded conntrack neftiler leaves fragments alone, 
processing them exacly as seen.

Regards
Henrik
