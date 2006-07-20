From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] pkttype match mismatches on locally generated packets
Date: Thu, 20 Jul 2006 18:20:35 +0200
Message-ID: <44BFAD53.4010704@trash.net>
References: <20060718010642.GA1203@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060718010642.GA1203@linuxace.com>
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

Phil Oester wrote:
> Locally generated broadcast and multicast packets have pkttype set to
> PACKET_LOOPBACK instead of PACKET_BROADCAST or PACKET_MULTICAST.  This
> causes the pkttype match to fail to match packets of either type.
> 
> The below patch remedies this by using the daddr as a hint as to
> broadcast|multicast.  While not pretty, this seems like the only way
> to solve the problem short of just noting this as a limitation of the match.
> 
> This resolves bug #484

Thanks Phil. I thought about just adding PACKET_LOOPBACK support to
userspace, but this way seems better, so applied.
