From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter ulog byte alignment problem
Date: Tue, 03 Jun 2008 15:04:35 +0200
Message-ID: <48454163.1060700@trash.net>
References: <1212426348.31217.30.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39651 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbYFCNEh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:04:37 -0400
In-Reply-To: <1212426348.31217.30.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> I am using libipulog on an XScale IXP422 processor (big endian ARM). I
> call ipulog_get_packet to decode the multipart message and then access
> the fields in the packet (ulog_packet_msg_t). Accessing fields 'mac' and
> 'payload' does not give me the right data. The data is actually there,
> but an access to the arrays ends up at a wrong location. Manually adding
> an offset leads to the correct position (e.g. pkt->payload[-66] instead
> of pkt->payload[0] for the first byte of the IP packet).
> 
> I tracked the issue down to a byte alignment problem in
> ulog_packet_msg_t (include/linux/netfilter_ipv4/ipt_ULOG.h). Setting
> attributes 'packed' or 'aligned' or using 'size_t' instead of 'unsigned
> char' for field 'mac_len' solved the problem. It seems necessary to help
> the compiler doing things right.
> 
> This patch requires applications to be recompiled against the new header
> file. Let me know what you think.

I'm afraid it might break compatibility on other architectures.
Are your userspace and kernel compiled using the same options?
Why would they lay out the structure differently?
