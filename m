From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: nat drop the icmp redirect packet
Date: Fri, 02 Dec 2011 13:32:22 +0800
Message-ID: <4ED862E6.6090104@cn.fujitsu.com>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED67BB1.8020808@trash.net> <4ED6D18C.7000802@cn.fujitsu.com> <4ED754EA.9060906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1LBFbi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:31:38 -0500
In-Reply-To: <4ED754EA.9060906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D3=DA 2011=C4=EA12=D4=C201=C8=D5 18:20, Patrick McHardy =D0=B4=B5=C0:
> Yes, as I said, we could set up a NULL source mapping on the
> conntrack of the original packet and let the REDIRECT through.
> The user might have configured a source NAT rule though which
> would become ineffective by this.
>=20

Hi Patrick:

Yes,you are right.

You mean we have no idea of the ICMP REDIRECT packet being droppen
when nat is not finished?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
