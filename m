From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 2.6]: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insersion
Date: Tue, 09 Sep 2008 19:19:48 +0900 (JST)
Message-ID: <200809091019.m89AJnvE027205@toshiba.co.jp>
References: <200809080613.m886DnGY021233@toshiba.co.jp>
	<48C61D88.6050703@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:47396 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYIIKTw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:19:52 -0400
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id m89AJo3H024425
	for <netfilter-devel@vger.kernel.org>; Tue, 9 Sep 2008 19:19:50 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id m89AJo0c013724
	for netfilter-devel@vger.kernel.org; Tue, 9 Sep 2008 19:19:50 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id m89AJor4026930
	for <netfilter-devel@vger.kernel.org>; Tue, 9 Sep 2008 19:19:50 +0900 (JST)
In-Reply-To: <48C61D88.6050703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


From: Patrick McHardy <kaber@trash.net>
Date: Tue, 09 Sep 2008 08:54:00 +0200

> Yasuyuki KOZAKAI wrote:
> > Hi Patrick,
> > 
> > Please apply the following patch. The option IP6T_OPTS_NSTRICT causes to
> > ignore rules for options in HBH/DST header.
> > 
> > I think this issue affects few users. Because fortunately (?) man page and
> > 'ip6tables -m hbh --help' does not show --hbh-not-strict option, and
> > 'ip6tables ... --hbh-not-strict' does not work due to incorrect has_arg
> > value in userland libip6t_hbh.c ;)
> > 
> > I will implement not-strict mode, so the patch leaves the definition of
> > IP6T_OPTS_NSTRICT. The strict mode is too strict (the specified options
> > have to be included in order in HBH/DST header) and would be useless
> > in most senarios.
> 
> Since my knowledge of this quite limited - is this fix important
> enough so it should go in 2.6.27, or is queuing it for 2.6.28 OK
> too?

Actually I am torn between them. I think this is security issue, like that
'iptables -p tcp -j DROP' does not drop TCP packets.
But no ip6tables user meet this issue because of has_arg bug.

I prefer 2.6.27 so that I don't need to fear rare case in several months :)

-- Yasuyuki Kozakai
