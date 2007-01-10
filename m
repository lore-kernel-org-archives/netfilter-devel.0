From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 12:21:56 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101213080.3029@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701100917340.2014@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0701100917340.2014@blackhole.kfki.hu>
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


On Jan 10 2007 09:21, Jozsef Kadlecsik wrote:
> On Tue, 9 Jan 2007, Jan Engelhardt wrote:
>> 
>> Uhm, considering what you just said I think we don't even need
>> --terminate, but just e.g.
>> 
>> -N markme
>> -A markme -j LOG
>> -A markme -j MARK --mark 117
>> -A markme -j ACCEPT
>> -t mangle -A POSTROUTING -m matchSomething -j markme
>> 
>> What do you think?
>
> The question is, how many chains you have to define just for the
> MARK + ACCEPT

One per mark target.

> actions and wether you accept it as a solution.

I happened to see shadowing CLASSIFY rules in the corporate
fw, so I thought "dude, you need to terminate here". Since
corp uses fwbuilder, I don't care as much if it takes a lot
of rules to implement MARK-and-terminate. However, in a
different project of my own[1], I really want to keep rules
to a minimum, even if it's a little contrary to netfilter
practice.

Perhaps I'll write the --terminate thing up just for the
fun of it, unless someone else does it before me.

[1] http://lists.netfilter.org/pipermail/netfilter-devel/2007-January/026537.html


Jan
-- 
