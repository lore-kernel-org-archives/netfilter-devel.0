From: Amin Azez <azez@ufomechanic.net>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 14:17:37 +0000
Message-ID: <45A4F581.6040002@ufomechanic.net>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>	<459AA3B2.4010008@shorewall.net>	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>	<45A4D7D9.6030208@ufomechanic.net>	<Pine.LNX.4.61.0701101312040.3029@yvahk01.tjqt.qr>	<45A4E265.2060600@trash.net>
	<Pine.LNX.4.61.0701101450530.3029@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701101450530.3029@yvahk01.tjqt.qr>
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

* Jan Engelhardt wrote, On 10/01/07 14:00:
> On Jan 10 2007 13:56, Patrick McHardy wrote:
>>> -t mangle -A POSTROUTING -s 10.0.0.0 -j CLASSIFY --set-class 1:16
>>> -t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:17
>>>
>>> which will cause TCP traffic to 10.0.0.0 become 1:17 rather than the intended
>>> 1:16. Using an extra chain with ACCEPT solves it, with RETURN: no.
>> It does if you use a subchain as Amin suggested, and it allows you to
>> do additional mangling.
> 
> Well the problem with RETURN is that you may run into another MARK or 
> CLASSIFY (see above) which is not intended.

If you only call one level deep, and --goto the subchain, then RETURN is
the same as terminate-with-policy-action, surely?	

-j RETURN [n] to return multiple levels is on _my_ todo list.
I also consider -j RETURN NAME to return back until it finds NAME'd
chain in the call stack. (it's ugly because it presumes that a the
returned-from chain will always be called from a known chain).

These may not solve your problem, but --goto and 1 level deep might help
for now.

Sam
