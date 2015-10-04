From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/1] netfilter: ftp: Check data size before copy them
 into FTP buffer
Date: Sun, 4 Oct 2015 23:38:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510042338260.19792@nerf40.vanv.qr>
References: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl> <20151004201620.GA30723@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Feng Gao <gfree.wind@outlook.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:38090 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbJDVjD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 17:39:03 -0400
In-Reply-To: <20151004201620.GA30723@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2015-10-04 22:16, Pablo Neira Ayuso wrote:

>On Tue, Sep 29, 2015 at 04:49:32PM +0800, Feng Gao wrote:
>> When TCP endpoint supports the windows scale option, the data size could
>> be more than 65536 easily. And there are some network interface features
>> which could aggregate multiple packets. So we need to check the datalen
>> before copy data into the FTP buffer.
>
>I don't think you can go over the maximum IPv4/IPv6 packet length with
>aggregation.

But there are jumbo frames known to IPv6, at least in principle. Dunno 
if GRO/TSO/.. do that, though.
