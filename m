From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to
 INSTALL_HDR_PATH
Date: Tue, 6 Sep 2011 20:11:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109062001450.19110@frira.zrqbmnf.qr>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu> <20110905174847.GB32733@1984> <4E664E05.4090907@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
	kaber@trash.net, blueness@gentoo.org, gurligebis@gentoo.org,
	base-system@gentoo.org, kernel@gentoo.org, toolchain@gentoo.org,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60471 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1IFSLf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:11:35 -0400
In-Reply-To: <4E664E05.4090907@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-09-06 18:44, Anthony G. Basile wrote:
>> 
>> Could anyone clarify why miniupnpd (or any other application) require
>> this?
>> 
>> Those headers contain structure layouts that may change along time
>> without further notice, thus breaking backward compatibility.
>
>It makes use of
>
>   union nf_conntrack_man_proto
>   struct nf_nat_range
>   struct nf_nat_multi_range_compat

miniupnpd is fiddling with the binary representation. Yes, classic
case of "all the xt headers are exported, just DNAT/SNAT's structs are not".

Did miniupnpd consider using the text-based interface?
