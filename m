From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: owner-Match in 2.6.20-rc5 (fwd)
Date: Thu, 25 Jan 2007 21:57:20 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701252154030.26335@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0701252121190.26664@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@lists.netfilter.org, David Miller <davem@davemloft.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0701252121190.26664@blackhole.kfki.hu>
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


On Jan 25 2007 21:31, Jozsef Kadlecsik wrote:

>On Thu, 25 Jan 2007 20:16:17 +0100, Sebastian wrote
>>Am Donnerstag, den 25.01.2007, 10:23 +0100 schrieb Sebastian Claßen:
>>> The owner-Match seems not to match TCP-Packets any more. Can be tested
>>> by inserting the rule:
>>> iptables -I OUTPUT -m owner --uid-owner test-user -j LOG
>>> 
>>> Simply su to the specified user and using netcat (nc) to send UDP and
>>> TCP packets shows only log entried with PROTO=UDP but none with TCP.
>>
>> I've just found out where the problem is. In 2.6.20-rc1 changelog the
>> following thing was modified:
>> [TCP]: Don't set SKB owner in tcp_transmit_skb().
>>
>> That seems to break the owner-match for TCP packets. I was able to undo
>> the change with the attached one-line patch which fixed the problem for
>> me.
>
> The report [above] was posted on the netfilter user list. Isn't there any
> ill side effect by reverting the change?
>

As far as I know, the _pid_ part of the owner module was removed
because the sending process might not be the process who did the
write. (Is this right?)

If so, does not the same actually apply to the owner [EUID of the
process which sent it]?


	-`J'
-- 
