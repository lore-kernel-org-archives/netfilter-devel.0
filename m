From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 15:00:22 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101450530.3029@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
	<45A4D7D9.6030208@ufomechanic.net>
	<Pine.LNX.4.61.0701101312040.3029@yvahk01.tjqt.qr>
	<45A4E265.2060600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A4E265.2060600@trash.net>
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


On Jan 10 2007 13:56, Patrick McHardy wrote:
>> 
>> -t mangle -A POSTROUTING -s 10.0.0.0 -j CLASSIFY --set-class 1:16
>> -t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:17
>> 
>> which will cause TCP traffic to 10.0.0.0 become 1:17 rather than the intended
>> 1:16. Using an extra chain with ACCEPT solves it, with RETURN: no.
>
>It does if you use a subchain as Amin suggested, and it allows you to
>do additional mangling.

Well the problem with RETURN is that you may run into another MARK or 
CLASSIFY (see above) which is not intended. You actually resurfaced an 
idea of mine, namely... consider this:

 -s IP -j MARK --set-mark 17
 -p tcp -j MARK --set-mark 18

to make them not overlap, one could use

 -p tcp -m mark --mark 0 -j MARK --set-mark 18

But unfortunately, there is no "classify" match for the CLASSIFY case. 
What now? You don't really want to matrixify all possibilities - 
consider:

 -s IP1 -j MARK --set-mark 17 --term
 -d IP2 -j MARK --set-mark 18 --term
 -p tcp --dport 22 -j MARK --set-mark 19 --term
 -p tcp -j MARK --set-mark 20 --term

then you would need to matrixify it where '--term' is not available

  -s    -d  tcp?  22?  action
  ip1  ip2    y    y  MARK 17
  ip1  ip2    y    n  MARK 17
  ip1  ip2    n    y  MARK 17
  ip1  ip2    n    n  MARK 17
  ip1 !ip2  ...   ..  MARK 17
 !ip1
 .
 .

leading to

 -s IP1 ! -d IP2 -j MARK --set-mark 17
 ! -s IP1 -d IP2 -j MARK --set-mark 18
 ! -s IP1 ! -d IP2 -p tcp --dport 22 -j MARK --set-mark 19
 ! -s IP1 ! -d IP2 -p tcp ! --dport 22 -j MARK --set-mark 20

well, this obviously becomes ugly quickly.
Phew, I hope I did not mix up anything.


	-`J'
-- 
