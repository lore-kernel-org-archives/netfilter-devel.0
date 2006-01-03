From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: please fix TARPIT
Date: Tue, 3 Jan 2006 08:34:47 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601030833560.23554@yvahk01.tjqt.qr>
References: <20051221.221552.70499588.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051221.221552.70499588.davem@davemloft.net>
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


>Recently it was reported that the TARPIT target depends upon the
>sysctl_ip_default_ttl symbol which is not exported any longer.

How about just adding the EXPORT_SYMBOL back. And that all wrapped up in a 
nice POM patch. Problem gone. (For the short term.)



Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
| jengelh's site, http://jengelh.hopto.org/
