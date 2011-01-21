From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall rules
Date: Fri, 21 Jan 2011 01:10:38 +0100
Message-ID: <201101210110.38451.richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <4D38CD9F.1040905@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:55521 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1AUAKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:10:42 -0500
In-Reply-To: <4D38CD9F.1040905@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Freitag 21 Januar 2011, 01:04:47 schrieb Mr Dash Four:
> > "conntrack -L" shows us this two entries:
> > tcp      6 431999 ESTABLISHED src=192.168.1.1 dst=192.168.1.2 sport=51444
> > \
> > 
> > 	dport=22 src=192.168.1.2 dst=192.168.1.1 sport=22 dport=51444 [ASSURED]
> > 	\ mark=0 established=1 related=0 new=3 reply=2 use=1
> > 
> > icmp     1 28 src=192.168.1.2 dst=149.20.20.133 type=8 code=0 id=63239 \
> > 
> > 	src=149.20.20.133 dst=192.168.1.2 type=0 code=0 id=63239 mark=0 \
> > 	established=2 related=0 new=2 reply=1 use=1
> 
> Isn't there supposed to be secctx (SELinux context) field showing as
> well or is this still not implemented in the conntrack tools?

SELinux is disabled on my box.

//richard
