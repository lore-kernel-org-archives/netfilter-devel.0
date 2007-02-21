From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: little question about output dnat
Date: Wed, 21 Feb 2007 17:04:27 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0702211704170.12039@yvahk01.tjqt.qr>
References: <885896af0702190149v543fb46j1ad63af880d5c012@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <885896af0702190149v543fb46j1ad63af880d5c012@mail.gmail.com>
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


On Feb 19 2007 10:49, Giacomo wrote:

> Just a little doubt originated by two contrasting documents on the web...
>
> IF i put an OUTPUT DNAT rule, i.e. i redirect the web traffic to port 80
> to the address of the proxy:8080,
> the FILTER rules are applied to the original address:port and not to the
> DNATTED address, right?
> Or are they applied both before and after the DNAT translation?

See http://imagestream.com/~josh/PacketFlow-new.png
