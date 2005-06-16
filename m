From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: DNAT & SNAT delay
Date: Thu, 16 Jun 2005 15:48:42 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506161548280.27104@yvahk01.tjqt.qr>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAMMn0WexgHkOTUvbQ/69qyoKAAAAQAAAAjlR56nNTu0GJg7EDUtBYpwEAAAAA@hupie.com>
	<42AFD186.2070302@borsabg.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Ferry Huberts <ferry@Hupie.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Bangiev <martin.bangiev@borsabg.com>
In-Reply-To: <42AFD186.2070302@borsabg.com>
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


> Thanks guys
> I'm using 2.6 kernel and I did
> echo "0" > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
> everything works perfectly now:)

Does not that turn off UDP connection tracking at all?


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
