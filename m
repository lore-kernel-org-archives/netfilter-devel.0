From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: ICMP Land Attack
Date: Mon, 9 Apr 2007 18:46:00 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704091845240.21426@yvahk01.tjqt.qr>
References: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Manish Jain <manish.jain@globallogic.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
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


On Apr 9 2007 17:23, Manish Jain wrote:
>Hello,
>
>We are experiencing ICMP Land Attach (ICMP packet with [source ip = dest ip]
>&& [source mac == dest mac]).

If the source mac == the dest mac, then the evil sender is right at your
network, just one hop away. Kill him.


Jan
-- 
