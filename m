From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 04 Dec 2007 16:57:37 +0100
Message-ID: <475578F1.8060600@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <4753B957.2000207@trash.net>	 <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>	 <47550D5C.8090004@trash.net>	 <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>	 <47551A83.80009@trash.net>	 <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>	 <475561C6.4030704@trash.net>	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>	 <47556D32.1060901@trash.net> <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbXLDP5m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:57:42 -0500
In-Reply-To: <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> ~# iptables -L
> iptables v1.3.8: can't initialize iptables table `filter': Invalid argument
> Perhaps iptables or your kernel needs to be upgraded.
> 
> # dmesg
> ip_tables: (C) 2000-2002 Netfilter core team
> translate_table: size 632
> Finished chain 1
> Finished chain 2
> Finished chain 3
> table->private->number = 4
> get_entries: 668 != 672

This looks like an alignment problem. Old kernels required
alignof(struct ipt_entry), which should be 4. Userspace
compiled against current headers use:

struct _xt_align
{
         u_int8_t u8;
         u_int16_t u16;
         u_int32_t u32;
         u_int64_t u64;
};

#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1))  \ 

                         & ~(__alignof__(struct _xt_align)-1))

which I guess is 8 on ARM. Does removing the u_int64_t
from the struct above in the iptables source 
(include/linux/netfilter/x_tables.h) help?

