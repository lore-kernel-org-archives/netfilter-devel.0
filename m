From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Subject: Re: MAC Filtering
Date: Wed, 5 Jan 2005 17:12:18 +0100
Message-ID: <200501051712.18817.erwin.vandevelde@gmail.com>
References: <200501051425.36450.erwin.vandevelde@gmail.com>
	<17648.213.236.112.75.1104937880.squirrel@213.236.112.75>
Reply-To: erwin.vandevelde@gmail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <17648.213.236.112.75.1104937880.squirrel@213.236.112.75>
Content-Disposition: inline
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

Hi,

I don't want to bridge, I only said I have to when using ebtables. I need MAC 
filtering without bridging... I'm fully aware of the fact that iptables works 
on layer 3 and that MAC is layer 2, however if it can filter on source MAC 
addresses, why can't it filter on destination MAC addresses?

Best regards,
Erwin


> If you bridge, you cannot use iptables. Ip tables operates on layer 3
> (routed) and the destination MAC is always the MAC of the firewall.
> Ebtables operates on layer 2 (switched) and can filter traffic based on
> source and destination MAC address.
>
> So I think ebtables is exactly what you need.
>
> HTH,
> Martijn Lievaart
