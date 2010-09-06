From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulogd2: Fix length handling in PCAP output
Date: Mon, 06 Sep 2010 14:07:52 +0200
Message-ID: <4C84D998.3010801@netfilter.org>
References: <20100905162857.GA9778@pitr.home.jan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Andres <jandres@gmx.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41694 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0IFMIA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:08:00 -0400
In-Reply-To: <20100905162857.GA9778@pitr.home.jan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/09/10 18:29, Jan Andres wrote:
> Currently, the PCAP output plugin uses ip.totlen to determine both the
> "len" and "caplen" pcap header fields, as well as the amount of packet
> data written to the file. There are two issues with this:
> 
> - For obvious reasons it doesn't work for IPv6.
> 
> - AFAICT, in case of an incompletely captured packet (--nflog-range)
>   it will attempt to write out the whole packet, not just the part
>   captured.
> 
> This patch changes the behavior to:
> 
> - Use raw.pktlen to set the "caplen" field, and the amount of data
>   written.
> 
> - Determine the "len" (original length) field from ip.totlen or
>   ip6.payload_len if possible, default to the same value as "caplen"
>   otherwise.
> 
> Signed-off-by: Jan Andres <jandres@gmx.net>

Applied, thanks Jan.
