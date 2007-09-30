From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] Transparent Proxying Patches, Take 3 - userspace
Date: Mon, 1 Oct 2007 00:05:04 +0200
Message-ID: <200710010005.04553@nessa>
References: <200709302318.11465@nessa> <Pine.LNX.4.64.0709302330270.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:41549 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXI3WFD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:05:03 -0400
In-Reply-To: <Pine.LNX.4.64.0709302330270.7130@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jan,

On Sunday 30 September 2007, Jan Engelhardt wrote:
> On Sep 30 2007 23:18, KOVACS Krisztian wrote:
> >Hi Patrick,
> >
> >Here is the patch adding iptables components of the 'socket' match
> >and the 'TPROXY' target. The code is pretty straightforward and basic
> >manual pages describing what the two modules do are included in the
> >patch.
>
> Hm, you asked me for my kernel patch, well you could have also asked
> for the iptables part :-p
>
> Uses the kernel-level xt_TPROXY.

Thanks, but this one is old: the userspace patch I've sent has received 
significant updates since than.

As Attila has already done the userspace ipt->xt conversion we could 
update it to xt_* anytime: it's just that I don't think it's worth it -- 
it's heavily IPv4 dependent anyway.

The 'socket' match does not support IPv6 either, however, we could add 
support _without_ any changes to the userspace, so that's why it's an 
x_tables match.

-- 
 KOVACS Krisztian
