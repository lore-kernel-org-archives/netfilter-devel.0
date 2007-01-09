From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Tue, 9 Jan 2007 23:09:24 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
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


On Jan 8 2007 22:42, Jan Engelhardt wrote:
>On Jan 8 2007 08:56, Jozsef Kadlecsik wrote:
>> On Sun, 7 Jan 2007, Jan Engelhardt wrote:
>>
>>> I was about to extend the kernel and iptables to support
>>> something along the lines of
>>> 
>>> iptables -t mangle -A POSTROUTING -j MARK --mark 117 --terminate
>>> 
>>> but then faced the problem of what verdict to return in xt_MARK when
>>> --terminate is given. NF_DROP? [...]
>>
>> Why should the processing be continued? If the packet is to be
>> marked then it's highly unlikley it should at the same time be
>> dropped. So in my opinion a simple NF_ACCEPT would be a perfect
>> return value.
>
>That makes sense. Thanks for the hint, I think I can
>complete it now.

Uhm, considering what you just said I think we don't even need
--terminate, but just e.g.

-N markme
-A markme -j LOG
-A markme -j MARK --mark 117
-A markme -j ACCEPT
-t mangle -A POSTROUTING -m matchSomething -j markme

What do you think?


	-`J'
-- 
