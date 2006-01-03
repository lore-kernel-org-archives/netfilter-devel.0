From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Tue, 3 Jan 2006 12:38:54 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601031238420.28743@yvahk01.tjqt.qr>
References: <4393895D.1020106@trash.net> <20051205004548.GC5617@eychenne.org>
	<439393C9.5020001@trash.net> <439513E1.3060407@milivojevic.org>
	<43951DBF.8050001@trash.net>
	<Pine.LNX.4.61.0601030804260.23554@yvahk01.tjqt.qr>
	<43BA5C79.9060304@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43BA5C79.9060304@trash.net>
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


>> On the way to restrict TCPMSS to -t mangle, the -m state
>> could also be obsoleted in favor of -m conntrack.
>
> I'm not going to restrict TCPMSS to mangle - but I'm
> considering adding a warning. I also don't see a reason
> to deprecate the state match, its totally trivial code
> and needs a lot less memory than the conntrack match.
>
But it's duplicate code, in terms of functionality.
