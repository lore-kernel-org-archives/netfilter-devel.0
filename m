From: michael <mteicher@gmail.com>
Subject: iptables-1.4.1.1 but no iptables file
Date: Wed, 18 Jun 2008 21:31:41 -0700
Message-ID: <66c5208e0806182131n581a29bbhcc02d6c3f1b9215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:23218 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbYFSEbm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:31:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4969058rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jun 2008 21:31:41 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Sorry for the cross post.  I mistakenly posted to the users mailing list.

On linux 2.4.34
ran configure && make && make install
Everything looks good but I cannot see where iptables was installed.
The only new file I can see installed is /usr/local/bin/iptables-xml ,
/usr/local/libexec/xtables (no files in there), and several man pages
in /usr/local/share/man/man8.

The install exited cleanly.

I have been running iptables 1.3.37 for awhile.  I have done a cursory
search and have yet to understand what I am missing.

Any help/pointers/suggestions are appreciated.

Thanks,
