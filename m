From: Patrick McHardy <kaber@trash.net>
Subject: Re: statistic match support in iptables snapshots
Date: Thu, 31 Aug 2006 17:38:54 +0200
Message-ID: <44F7028E.1040103@trash.net>
References: <BAY103-F24A7DE4B639CB7E3909BCB23F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F24A7DE4B639CB7E3909BCB23F0@phx.gbl>
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

Marco Berizzi wrote:
> Patrick McHardy wrote:
> 
>> Marco Berizzi wrote:
>> > Sorry for breaking you again: is not possible
>> > having multiple counters with 'nth mode'?
>>
>> No, why is that useful? You can just use multiple matches.
> 
> 
> ok, it's clear.
> 
> Just the last question. I have tried to insert a couple of
> rules with an out of range packet number and the kernel has
> eaten them:
> 
> iptables -A FORWARD -m statistic --mode nth --every 2 --packet 0 -j ACCEPT
> iptables -A FORWARD -m statistic --mode nth --every 2 --packet 1 -j ACCEPT
> iptables -A FORWARD -m statistic --mode nth --every 2 --packet 2 -j ACCEPT
> iptables -A FORWARD -m statistic --mode nth --every 2 --packet 20 -j ACCEPT


Mhh thats more something for userspace to catch in my opinion,
I'll add a check there.
