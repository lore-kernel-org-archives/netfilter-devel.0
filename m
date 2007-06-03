From: Andrew Beverley <andy@andybev.com>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 03 Jun 2007 18:00:22 +0100
Message-ID: <1180890022.6601.6.camel@andybev>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
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

On Sun, 2007-06-03 at 13:12 +0200, Jan Engelhardt wrote:
> Adds the connlimit match that has been in POM-NG for a long time.
> 
>     *	works with 2.6.22, xtables'ified and all that
> 
>     *	will request nf_conntrack_ipv4 upon load
> 	(otherwise it hotdrops every packet - a glitch that goes back
> 	to at least 2.6.20.2)

Excellent! This has been at the back of my mind for a while.

Is there any chance of getting UDP flows added as well as TCP
connections? I use connlimit for detecting p2p software, but some p2p
software now uses UDP instead.

Thanks,

Andy Beverley
