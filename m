From: Markus Teich <teichm@fs.tum.de>
Subject: [libmnl] portability of getpagesize() in libmnl.h
Date: Tue, 24 Feb 2015 21:45:50 +0100
Message-ID: <20150224204550.GZ3453@trolle>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hermod.fs.tum.de ([129.187.202.12]:36350 "EHLO hermod.fs.tum.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbbBXUvA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 15:51:00 -0500
Received: from localhost (dslb-188-110-065-108.188.110.pools.vodafone-ip.de [188.110.65.108])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by hermod.fs.tum.de (FachschaftsNachrichtenDienst) with ESMTPSA id C7B6CE043D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2015 21:44:48 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Heyho,

the getpagesize() call in line

#define MNL_SOCKET_BUFFER_SIZE (getpagesize() < 8192L ? getpagesize() : 8192L)

of libmnl.h seems to be less portable than sysconf(_SC_PAGESIZE) as suggested by
the getpagesize man page. getpagesize() needs e.g. _BSD_SOURCE while sysconf()
does not.

Would you consider fixing this or should I write a patch?

(I'm not on the list, so please leave me a CC)

--Markus
