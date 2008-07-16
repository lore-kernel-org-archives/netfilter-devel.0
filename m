From: "Kevin Sookocheff" <kevin.sookocheff@gmail.com>
Subject: Re: Invalid size of target
Date: Wed, 16 Jul 2008 14:15:31 -0400
Message-ID: <48bd37870807161115u1cf3eca2jf5e649fbd78a729e@mail.gmail.com>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>
	 <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
	 <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
	 <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
	 <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr>
	 <48bd37870807150547r6211bb9bp74c1d3490c019000@mail.gmail.com>
	 <alpine.LNX.1.10.0807151650130.2212@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:11727 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYGPSPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:15:33 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1857702nfc.21
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2008 11:15:32 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807151650130.2212@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Simplifying my iptables private struct in ipt_CSUM.h down to

struct ipt_CSUM_info {
   u_int32_t    count;
};

and calculating .size .userspacesize (in libiptCSUM.c) and .targetsize
(in ipt_CSUM.c) all with IPT_ALIGN(sizeof(struct ipt_CSUM_info) gives
me an error stating:

iptables: CSUM target: invalid size 12 != 4

In what way should I be creating this struct so that it aligns
correctly in user and kernel space?

Thanks again,
Kevin




On Tue, Jul 15, 2008 at 10:52 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2008-07-15 14:47, Kevin Sookocheff wrote:
>
> >Great, that worked wonderfully!
> >
> >So, just out of curiosity and for completeness, do you know why this
> >error would present itself only on SMP kernels?  I'm presuming it has
> >something to do with what version of IPTables is compiled in the
> >kernel.
>
> The kernel-level iptables component has no version number (it uses
> the kernel version). For best interoperability (and chance to get an
> answer to a bugreport), 2.6.18 or any kernel more recent than that,
> specifically its latest stable versions, and userspace
> iptables >= 1.4.1.1 are strongly recommended.
