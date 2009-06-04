From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Thu, 4 Jun 2009 16:55:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906041653420.13894@fbirervta.pbzchgretzou.qr>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu> <4A27CD5A.6040303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44256 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZFDOzd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:55:33 -0400
In-Reply-To: <4A27CD5A.6040303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-06-04 15:34, Patrick McHardy wrote:
> Laszlo Attila Toth wrote:
>> +++ b/include/linux/netfilter/xt_socket.h
>> @@ -0,0 +1,8 @@
>> +#ifndef _XT_SOCKET_H_match
>> +#define _XT_SOCKET_H_match
>> +
>> +struct xt_socket_match_info1 {
>> +	__u8 transparent;
>> +};
>
> Please use a bitmask.

enum {
	XT_SOCKET_TRANSPARENT = 1 << 0,
};

struct xt_socket_mtinfo1 {
	__u8 flags;
};
