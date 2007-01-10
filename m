From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Thu, 11 Jan 2007 00:01:04 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701102358130.28885@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
	<45A4D7D9.6030208@ufomechanic.net>
	<Pine.LNX.4.61.0701101312040.3029@yvahk01.tjqt.qr>
	<45A4E265.2060600@trash.net>
	<Pine.LNX.4.61.0701101450530.3029@yvahk01.tjqt.qr>
	<45A4F581.6040002@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <45A4F581.6040002@ufomechanic.net>
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


On Jan 10 2007 14:17, Amin Azez wrote:
>
>If you only call one level deep, and --goto the subchain, then RETURN is
>the same as terminate-with-policy-action, surely?	

Yes indeed. But what if... you were to match two conditions, i.e.
if(src != 10.1.2.3 && src != 192.168.0.1) { classify; }
You could not just jump out of it, you'd need RETURN n.

>-j RETURN [n] to return multiple levels is on _my_ todo list.

Seems like it.

>I also consider -j RETURN NAME to return back until it finds NAME'd
>chain in the call stack. (it's ugly because it presumes that a the
>returned-from chain will always be called from a known chain).

What if there is no such chain in the return addresses?


	-`J'
-- 
