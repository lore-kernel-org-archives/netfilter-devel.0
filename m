From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Extending class handle from 16bit to 32bit
Date: Mon, 4 Mar 2013 20:08:22 -0800
Message-ID: <20130304200822.25180df3@nehalam.linuxnetplumber.net>
References: <CAN==1RrDHivRrzE1FKcDykRkgh2Obp+XC+5NEeuOE0NWJ=cn_g@mail.gmail.com>
	<20130228135209.1f82c7b3@nehalam.linuxnetplumber.net>
	<CAN==1Rrj7aPqSs1CqegnR264JsuNmbSzdt99+_A+N1p45PJD9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Karel Rericha <karel@maxtel.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:47689 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3CEEI1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:08:27 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so5650134iaz.30
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Mar 2013 20:08:27 -0800 (PST)
In-Reply-To: <CAN==1Rrj7aPqSs1CqegnR264JsuNmbSzdt99+_A+N1p45PJD9g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 1 Mar 2013 10:22:21 +0100
Karel Rericha <karel@maxtel.cz> wrote:

> >> a) low effort
> >> Fork hfsc and in forked hfsc interpret 32bit handle as 8bit qdisc and
> >> 24bit class.
> >> - not "clean" solution, no chance to accept to mainstream IMHO
> >> - requires just fork hfsc and add support for forked hfsc to iptables ???
> 
> > The handle is baked into the kernel binary API, You can't change it without
> > a doing a whole new netlink API and have compatibility layer.
> 
> Stephen, is "low effort" way possible ? Any ideas what difficulties
> can we walk into if going that way ?
> 
> Karel

There is no "low effort" way. Look at:
 include/uapi/linux/rtnetlink.h


/*****************************************************************
 *		Traffic control messages.
 ****/

struct tcmsg {
	unsigned char	tcm_family;
	unsigned char	tcm__pad1;
	unsigned short	tcm__pad2;
	int		tcm_ifindex;
	__u32		tcm_handle
	__u32		tcm_parent;
	__u32		tcm_info;
};

The handles are 32 bits. with Major/minor of 16 bit.

