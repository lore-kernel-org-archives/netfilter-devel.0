From: Pierre Chifflier <chifflier@inl.fr>
Subject: [announce] nfqueue-bindings 0.3
Date: Thu, 28 Jan 2010 22:27:37 +0100
Message-ID: <20100128212736.GA12551@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47170 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0A1V1r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:27:47 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 39F5B940124
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2010 22:27:39 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 5B86E940075
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2010 22:27:37 +0100 (CET)
Received: from piche2.inl.fr ([192.168.33.184])
	by fydelkass.edenwall.com with esmtp (Exim 4.63)
	(envelope-from <pchifflier@edenwall.com>)
	id 1Nabtp-0002a4-6d
	for netfilter-devel@vger.kernel.org; Thu, 28 Jan 2010 22:27:37 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

NFQueue-bindings 0.3 has been released.

nfqueue-bindings is a set of high-level modules for several languages
(Python and Perl, for the moment), for libnetfilter_queue. Similar
bindings are also available for NFLOG: nflog-bindings.

The goal is to provide a library to gain access to packets queued by the
kernel packet filter, and set the verdict from userspace, or alert
packets etc.

It is important to note that these bindings will not follow blindly
libnetfilter_queue API. For ex., some higher-level wrappers will be
provided for the open/bind/create mechanism (using one function call
instead of three).

Links:
* Project page: http://software.inl.fr/trac/wiki/nfqueue-bindings
* Git tree: http://git.inl.fr/git/nfqueue-bindings.git
* (old) blog post with examples:
  http://www.wzdftpd.net/blog/index.php?2008/06/01/22-nfqueue-bindings
* Slides of a presentation in the NFWS:
  http://nfws.inl.fr/nfws_userday/Pierre-Chifflier_NFQUEUE-Bindings.pdf

Best regards,
Pierre

