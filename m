From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: OUTPUT DNAT AND FILTERING - scenario
Date: Fri, 23 Feb 2007 14:04:02 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0702231403340.9736@yvahk01.tjqt.qr>
References: <885896af0702210255s3f0485a5t7420a55e1b8cea45@mail.gmail.com>
	<1172188871.544.69.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Giacomo <delleceste@gmail.com>,
	netfilter devel <netfilter-devel@lists.netfilter.org>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1172188871.544.69.camel@henriknordstrom.net>
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


On Feb 23 2007 01:01, Henrik Nordstrom wrote:
>ons 2007-02-21 klockan 11:55 +0100 skrev Giacomo:
>
>> Finally, my question is very simple:
>> why doues iptables apply the FILTER rules AFTER the OUTPUT DNAT and not
>> before, when the packet still has the original destination address?

Why would you need to? If you want to match on the original addresses use
 -m conntrack --ctorigsrc or --ctorigdst

>Because this is the way iptables is designed.
>
>Simplified packet flow:
>
>mangle -> nat DNAT -> [routing] -> filter -> nat SNAT -> mangle
>
>To deal with this cleanly within the filter table there is the conntrack
>match allowing you to filter based on connection details rather than the
>packet details.
>
>Regards
>Henrik
>

Jan
-- 
ft: http://freshmeat.net/p/chaostables/
