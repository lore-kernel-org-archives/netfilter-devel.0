From: Michal Kubecek <mkubecek@suse.de>
Subject: Re: SNAT before IPSEC - why?
Date: Sat, 08 Oct 2011 11:13:07 +0200
Message-ID: <20111008111307.yh6li19ypc8coog4@imap.suse.de>
References: <4E8FB084.6030807@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sclark46@earthlink.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1JHJNK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:13:10 -0400
In-Reply-To: <4E8FB084.6030807@earthlink.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat 2011-10-08,=C2=A004:08:04=C2=A0CEST Stephen Clark <sclark46@eart=
hlink.net> wrote:
> What is the reasoning for having SNAT happen before ipsec encryption?
>
> It forces one to add special rules in the NAT table to keep this from
> happening and
> I can't think of one reason why you would want it to be this way.
>
> Please someone enlighten me.

IMHO the main reason is that addresses translation of IPsec =20
encapsulated packet
wouldn't work without something like NAT Traversal.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
