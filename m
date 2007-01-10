From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 09:21:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701100917340.2014@blackhole.kfki.hu>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701092307590.4779@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

On Tue, 9 Jan 2007, Jan Engelhardt wrote:

>>> Why should the processing be continued? If the packet is to be
>>> marked then it's highly unlikley it should at the same time be
>>> dropped. So in my opinion a simple NF_ACCEPT would be a perfect
>>> return value.
>>
>> That makes sense. Thanks for the hint, I think I can
>> complete it now.
>
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

The question is, how many chains you have to define just for the MARK + 
ACCEPT actions and wether you accept it as a solution.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
