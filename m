From: Amin Azez <azez@ufomechanic.net>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 12:11:05 +0000
Message-ID: <45A4D7D9.6030208@ufomechanic.net>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>	<459AA3B2.4010008@shorewall.net>	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
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

* Jan Engelhardt wrote, On 09/01/07 22:09:

> Uhm, considering what you just said I think we don't even need
> --terminate, but just e.g.
> 
> -N markme
> -A markme -j LOG
> -A markme -j MARK --mark 117
> -A markme -j ACCEPT
> -t mangle -A POSTROUTING -m matchSomething -j markme
> 
> What do you think?
> 
> 
> 	-`J'

It's not just mark and terminate, but mark and return.
It can be managed with --goto and -j RETURN and a subchain.

-N markme
-A markme -j LOG
-A markme -j MARK --mark 117
-A markme -j RETURN
-t mangle -A checkthings -m matchSometing --goto markme

The design of the iptables-xml schema supports this for multiple-target
rules.

Things get a bit more complicated if you want round-tripping, the only
reason I haven't built it in to the xsltproc I submitted is because once
of our client applications still talks to iptables directly and expects
the full matches to be repeated for each target.

But if a chain-name prefix is used to indicate that it's contents are
mutiple targets for a single match then it will be easy to gather them
back into a single rule with multiple targets when re-generating the xml.

iptables rules aren't the most expressive but the system is flexible.

Sam
