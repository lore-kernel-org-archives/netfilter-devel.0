From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 20070915
Date: Wed, 19 Sep 2007 16:32:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709191615490.10201@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
	<46EE86FA.10604@trash.net>
	<Pine.LNX.4.64.0709171616070.4516@fbirervta.pbzchgretzou.qr>
	<46EFA035.6060409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46EFA035.6060409@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 18 2007 11:53, Patrick McHardy wrote:
>
>Mhh .. but do we have to handle this in the kernel? Instead
>of:
>
>+	if (info->time_start < info->time_stop) {
>+		...
>+	} else {
>+		...
>+	}
>
>you could switch the times in userspace and use inversion.
>But its not important, if you prefer this way thats also
>fine with me.

The issue is that the user can specify inversion twice
(for both --timestamp and --timestop), or is allowed to
specify confusing inversions, like

	iptables ! --timestop 17:00 --timestart 16:00

>All of this looks pretty complicated/expansive. I wonder whether
>we could omit a few of these calculations (like day, month, ..)
>if the user isn't matching on them.

Yup, will shuffle.
