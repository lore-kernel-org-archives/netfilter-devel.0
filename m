From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: some minor tweaks for building doc/man pages for nftables
Date: Wed, 12 Mar 2014 05:34:42 -0400 (EDT)
Message-ID: <alpine.LFD.2.11.1403120529570.4122@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter devel list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:37716 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaCLK0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:26:51 -0400
Received: from [99.240.204.5] (port=35984 helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1WNfYk-00021h-7n
	for netfilter-devel@vger.kernel.org; Wed, 12 Mar 2014 05:34:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


  new here so not confident enough to submit any patches yet, but on
my fedora rawhide system, some notes on building the man page and PDF
docs.

* re: INSTALL file, on fedora, the package names are actually:

  * docbook2x -> docbook2X
  * docbook-utils -> docbook-utils-pdf

* re: Makefile and configure, command to generate man output:

  * docbook2x-man -> db2x_docbook2man

* in doc directory, man page currently refers to "nftables" command,
shouldn't that be just "nft" (both filename and contents of
doc/nftables.xml).

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
