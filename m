From: Patrick McHardy <kaber@trash.net>
Subject: Re: do not nat gre packets
Date: Mon, 25 Feb 2008 13:08:37 +0100
Message-ID: <47C2AFC5.7060408@trash.net>
References: <47c1bfc1.0637560a.59d2.ffffbd8b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Friedrich Euler <friedrich.euler@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:37581 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYBYMIm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:08:42 -0500
In-Reply-To: <47c1bfc1.0637560a.59d2.ffffbd8b@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Friedrich Euler wrote:
> I am currently using iptables version 1.2.7a and encountered the following
> issue. When using a GRE (over ipsec) tunnel without the optional GRE key
> field, Netfilter cannot find a unique tupel for all GRE packets. This makes
> the connection tracking fail. The source code shows only a GRE over PPTP
> implementation. My understanding is that I need to extend the iptables
> implementation of version 1.2.7a to enable the connection tracking. Is this
> true? Was this fixed in a version following 1.2.7a? 
>   
> I would appreciate any information on this. 


Without the gre key there is no way to distinguish two gre tunnels
between the same pair of hosts, so the connection tracking helper
behaves similar to ip_conntrack_proto_generic. It does not fail,
it simply doesn't work with multiple tunnels with equal endpoints.
