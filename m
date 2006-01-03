From: "David S. Miller" <davem@davemloft.net>
Subject: Re: please fix TARPIT
Date: Tue, 03 Jan 2006 12:29:48 -0800 (PST)
Message-ID: <20060103.122948.123600500.davem@davemloft.net>
References: <20051221.221552.70499588.davem@davemloft.net>
	<Pine.LNX.4.61.0601030833560.23554@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jengelh@linux01.gwdg.de
In-Reply-To: <Pine.LNX.4.61.0601030833560.23554@yvahk01.tjqt.qr>
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

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Tue, 3 Jan 2006 08:34:47 +0100 (MET)

> 
> >Recently it was reported that the TARPIT target depends upon the
> >sysctl_ip_default_ttl symbol which is not exported any longer.
> 
> How about just adding the EXPORT_SYMBOL back. And that all wrapped up in a 
> nice POM patch. Problem gone. (For the short term.)

The usage of that symbol is broken.  The fact that I went through
the trouble of explaining exactly how to fix the bug properly,
and yet this kind of suggestion still arises, deeply disturbs me.
