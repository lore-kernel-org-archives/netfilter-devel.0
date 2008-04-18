From: Jason Stubbs <j.stubbs@linkthink.co.jp>
Subject: Re: conntrack bug?
Date: Fri, 18 Apr 2008 14:14:52 +0900
Message-ID: <200804181414.52424.j.stubbs@linkthink.co.jp>
References: <200804181343.25640.j.stubbs@linkthink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.blogtoy.net ([202.177.195.2]:59992 "EHLO smtp.blogtoy.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYDRFOy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2008 01:14:54 -0400
Received: from mail.linkthink.co.jp (unknown [221.186.146.128])
	by smtp.blogtoy.net (Postfix) with ESMTP id A84F56A4ADC
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 14:14:53 +0900 (JST)
Received: from localhost (localhost [127.0.0.1])
	by mail.linkthink.co.jp (Postfix) with ESMTP id 7EB2DA7053D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 14:14:53 +0900 (JST)
Received: from mail.linkthink.co.jp ([127.0.0.1])
	by localhost (mail.linkthink.co.jp [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RVZEcacJtfRw for <netfilter-devel@vger.kernel.org>;
	Fri, 18 Apr 2008 14:14:52 +0900 (JST)
Received: from [192.168.0.104] (unknown [192.168.0.104])
	by mail.linkthink.co.jp (Postfix) with ESMTP id E2F5EA70538
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2008 14:14:52 +0900 (JST)
In-Reply-To: <200804181343.25640.j.stubbs@linkthink.co.jp>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 18 April 2008 13:43:25 Jason Stubbs wrote:
> I would think that behaviour to be correct, but an entry appearing wh=
en
> only an ACK packet has been sent seems wrong. Is it a bug or intentio=
nal?

It seems it's intentional. After a bit more searching I finally found o=
ut=20
about the net.netfilter.nf_conntrack_tcp_loose sysctl setting. Is this=20
setting (and the others) documented anywhere other than the source?

--=20
Jason Stubbs <j.stubbs@linkthink.co.jp>
LINKTHINK INC.
=E6=9D=B1=E4=BA=AC=E9=83=BD=E6=B8=8B=E8=B0=B7=E5=8C=BA=E6=A1=9C=E3=83=B6=
=E4=B8=98=E7=94=BA22-14 N.E.S S=E6=A3=9F 3F
TEL 03-5728-4772  FAX 03-5728-4773
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
