From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCP/UDP checksum in hardware
Date: Fri, 16 Mar 2007 13:35:25 +0100
Message-ID: <45FA8F0D.9000201@trash.net>
References: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>	
	<45EAFEF7.7050404@trash.net>	
	<c4357ccd0703050149p508d3b2ej80cbdeaccbdbd3b5@mail.gmail.com>	
	<45EC5C3F.6060401@trash.net>
	<c4357ccd0703080215p659147bdhefb023d93ae889fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Alexander Sirotkin <demiourgos@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <c4357ccd0703080215p659147bdhefb023d93ae889fd@mail.gmail.com>
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

Alexander Sirotkin wrote:
> On 3/5/07, Patrick McHardy <kaber@trash.net> wrote:
> 
>> > BTW, while we are on the subject, the overhead of netfilter itself,
>> > i.e. the difference in CPU utilization of kernel with and without
>> > netfilter on the above platform is more than 5%. Is there anybody hear
>> > willing to discuss this ?
>>
>> Is this with netfilter modules (like iptables, conntrack, NAT, ...)
>> loaded or just by enabling netfilter in the configuration?
>>
> Just netfilter, no modules.
> Strangely enough, this only happens with bridge configuration. With
> router configuration the difference in CPU utilization is minor,
> however with bridge it is huge - about 25% on my system.


The bridge-netfilter code includes a number of hooks of its own,
additionally it passes all packets though all IP netfilter hooks
and duplicates quite a bit of the IP layer handling. I'm not very
surprised that its efficiency sucks, although 25% really is a lot.
If you could get profiles we could see if there are possibly some
simple optimizations.

If you don't need IP netfilter on bridged packets you could also
simply disable it through /proc/sys/net/bridge/bridge-nf-call-*.
