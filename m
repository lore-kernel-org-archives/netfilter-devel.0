From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] ebtables v2.0.10-1
Date: Sun, 10 Jul 2011 20:23:05 +0200
Message-ID: <4E19EE09.8070602@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:53491 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab1GJSXG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:23:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I just released a new version of the ebtables tool.
Changes:
* fix --among-dst-file, which translated to --among-src (reported by 
Thierry Watelet)
* fix bug in test_ulog.c example
* Makefile: respect LDFLAGS during ebtables build (Peter Volkov)
* Makefile: create directories to avoid build failure when DESTDIR is 
supplied (Peter Volkov)
* incorporate fixes for possible issues found by Coverity analysis 
(thanks to Jiri Popelka)
* define __EXPORTED_HEADERS__ to get access to the Linux kernel headers
* extend ebt_ip6 to allow matching on ipv6-icmp types/codes (by Florian 
Westphal)
* Print a more useful error message when an update of the kernel table 
failed.
* Add --concurrent option, which enables using a file lock to support 
concurrent scripts updating the ebtables kernel tables


Have fun,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

