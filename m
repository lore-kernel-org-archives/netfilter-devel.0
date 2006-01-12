From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix undefined symbols
Date: Thu, 12 Jan 2006 06:58:46 +0100
Message-ID: <43C5F016.4070505@trash.net>
References: <43C525FE.8080607@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <43C525FE.8080607@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> with 2.5.15-git7 I get the following warning:
> 
> *** Warning: "compare_ether_addr" [net/ipv6/netfilter/ip6t_mac.ko] undefined!
> *** Warning: "compare_ether_addr" [net/bridge/netfilter/ebt_stp.ko] undefined!
> 
> The following patch fixes it.

Dave Miller already got patches for this queued.
