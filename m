From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to match
 user space
Date: Tue, 9 Mar 2010 18:03:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003091802060.3823@obet.zrqbmnf.qr>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com> <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44090 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0CIRDG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:03:06 -0500
In-Reply-To: <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-03-09 17:48, Lutz Jaenicke wrote:

>On some platforms (here: Intel IXP4xx ARM big endian)
>sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the user
>space code 2 bytes is hard coded.

Why does it evaluate to 4 bytes? That seems to go against all good C 
practice.

>@@ -39,7 +39,7 @@ enum tcp_conntrack {
> /* The field td_maxack has been set */
> #define IP_CT_TCP_FLAG_MAXACK_SET		0x20
> 
>-struct nf_ct_tcp_flags {
>+struct __attribute__ ((packed)) nf_ct_tcp_flags {
> 	__u8 flags;
> 	__u8 mask;
> };
