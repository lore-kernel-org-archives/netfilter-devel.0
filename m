From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 02 Jul 2007 20:20:06 +0200
Message-ID: <468941D6.7090306@trash.net>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>	<4688FC41.5070403@trash.net>
	<Pine.LNX.4.64.0707022005200.25153@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707022005200.25153@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Mon, 2 Jul 2007, Patrick McHardy wrote:
> 
>> We should really document that with window tracking and NAT you
>> must drop INVALID packets to avoid them getting delivered locally
>> and causing a RST.
> 
> 
> Indeed. There should be a big, fat warning about dropping in INPUT (and
> probably FORWARD). The question is where: Kconfig (NAT)? man iptables?
> both? ;)


The manpage I guess. Kconfig is not really the place for this IMO.

>>> make no more RSTs, only retransmisions from the 216.34.143.7. And yes, I
>>> have a patched kernel so I'm able to filter packets in a PREROUTING
>>> chain.
>>
>>
>> Dropping works without any patches.
> 
> 
> Yes, in INPUT. I discovered that such packets goes to INPUT shortly
> after I had written this mail. Before that I had put this in PREROUTING,
> which is not possible by default.


You can drop in PREROUTING/mangle for example. In the filter table
its not possible of course since there is no PREROUTING chain :)
