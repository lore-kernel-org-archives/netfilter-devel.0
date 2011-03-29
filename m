From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [ANNOUNCE] ipset 6.2 released
Date: Wed, 30 Mar 2011 00:18:00 +0400
Message-ID: <4D923E78.4090300@msgid.tls.msk.ru>
References: <alpine.DEB.2.00.1103272124170.3535@blackhole.kfki.hu> <4D91E7D7.3070000@msgid.tls.msk.ru> <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:43617 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1C2USE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:18:04 -0400
In-Reply-To: <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

29.03.2011 23:23, Jozsef Kadlecsik wrote:
> On Tue, 29 Mar 2011, Michael Tokarev wrote:
>=20
>> ipset-6.2/kernel/net/netfilter/ipset/Kconfig file
>> appears to be some net/netfilter/Kconfig file from
>> linux source tree (from one directory level up),
>> patched with NETFILTER_XT_SET.  It gets included
>> into itself recursively.
>=20
> Yes, you are right, I fixed it in the ipset git tree. Thanks!

You added stuff to the top of that file, but haven't deleted
the old content, starting with =ABmenu "Core Netfilter Configuration"=BB=
 ;)

/mjt
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
