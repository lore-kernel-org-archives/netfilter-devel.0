From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] nfnl_osf: use the right nfnetlink lib
Date: Wed, 3 Apr 2013 04:17:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1304030415450.14642@nerf07.vanv.qr>
References: <1364566870-7320-1-git-send-email-nicolas.dichtel@6wind.com> <alpine.LNX.2.01.1303291620200.11529@nerf07.vanv.qr> <515AED72.20300@6wind.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44531 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3DCCRo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:17:44 -0400
In-Reply-To: <515AED72.20300@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-04-02 16:38, Nicolas Dichtel wrote:

>>> @@ -7,4 +7,4 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
>>> sbin_PROGRAMS = nfnl_osf
>>> pkgdata_DATA = pf.os
>>>
>>> -nfnl_osf_LDADD = -lnfnetlink
>>> +nfnl_osf_LDADD = ${libnfnetlink_LIBS} -lnfnetlink
>>
>> You really should remove -lnfnetlink :)
>>
> Not sure to understand your comment. ${libnfnetlink_LIBS} contains only
> something like '-L/path/to/my/lib'.


	pkg-config libnfnetlink --libs

should definitely return at least an -l argument. If not, the .pc file 
is buggy.
This is what the Libs line should look like:


# libnfnetlink pkg-config file

prefix=/usr
exec_prefix=/usr
libdir=/usr/lib64
includedir=/usr/include/libnfnetlink-1.0.1

Name: libnfnetlink
Description: Low-level netfilter netlink communication library
URL: http://netfilter.org/projects/libnfnetlink/
Version: 1.0.1
Requires:
Conflicts:
Libs: -L${libdir} -lnfnetlink
Cflags: -I${includedir}
