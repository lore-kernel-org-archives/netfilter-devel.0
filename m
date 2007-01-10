From: Amin Azez <azez@ufomechanic.net>
Subject: Re: MARK targets all non-terminating
Date: Wed, 10 Jan 2007 12:13:16 +0000
Message-ID: <45A4D85C.9080405@ufomechanic.net>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>	<459AA3B2.4010008@shorewall.net>	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>	<Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
	<Pine.LNX.4.61.0701082235280.23737@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
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

* Jan Engelhardt wrote, On 08/01/07 21:42:

> That makes sense. Thanks for the hint, I think I can
> complete it now.
> 
> 
> [ Gah, I just dislike it that you can actually *filter*
>   packets in the "mangle" and "nat" tables. This leads to
>   things like users doing just that (nat especially because
>   it only gets the first packet in a connection. To me, it
>   looks like mangle-input and filter-input could just be
>   consolidated into one table, same going for
>   mangle-forward/filter-forward.
> 
>   http://www.imagestream.com/~josh/PacketFlow-new.png ]


Yes please!

Sam	
