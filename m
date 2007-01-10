From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 13:16:01 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101312040.3029@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
	<45A4D7D9.6030208@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <45A4D7D9.6030208@ufomechanic.net>
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


On Jan 10 2007 12:11, Amin Azez wrote:
>
>It's not just mark and terminate, but mark and return.
>It can be managed with --goto and -j RETURN and a subchain.

That is not the issue here. We _do_ want to terminate. Consider this faulty
(shadowing) ruleset:

-t mangle -A POSTROUTING -s 10.0.0.0 -j CLASSIFY --set-class 1:16
-t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:17

which will cause TCP traffic to 10.0.0.0 become 1:17 rather than the intended
1:16. Using an extra chain with ACCEPT solves it, with RETURN: no.

(Have a look at
http://sourceforge.net/tracker/index.php?func=detail&aid=1618381&group_id=5314&atid=105314
for the motivation to 'fix' CLASSIFY and friends)

>-N markme
>-A markme -j LOG
>-A markme -j MARK --mark 117
>-A markme -j RETURN
>-t mangle -A checkthings -m matchSometing --goto markme
>
>The design of the iptables-xml schema supports this for multiple-target
>rules.

13:15 ichi:/home/jengelh # iptables -I INPUT -j MARK -j RETURN
iptables v1.3.7: multiple -j flags not allowed

-A POSTROUTING -p tcp -m tcp --dport 999 -j MARK --set-mark 0x11 -j RETURN
COMMIT
# Completed on Wed Jan 10 13:16:01 2007

File x.ipt saved
13:16 ichi:/dev/shm # iptables-restore <x.ipt 
iptables-restore v1.3.7: multiple -j flags not allowed


Sorry, but if iptables-restore can't do it, I doubt xml will.


	-`J'
-- 
