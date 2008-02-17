From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: "#ifndef __KERNEL" ??
Date: Sun, 17 Feb 2008 12:26:34 -0500 (EST)
Message-ID: <alpine.LFD.1.00.0802171225390.7957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:34534 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYBQR0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:26:55 -0500
Received: from cpe001d60ad7267-cm001225dbafb6.cpe.net.cable.rogers.com ([99.236.100.208] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1JQnI9-0000Tk-DF
	for netfilter-devel@vger.kernel.org; Sun, 17 Feb 2008 12:27:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


  this doesn't look right:

.../include/linux/netfilter/nfnetlink_compat.h:
...
#ifndef __KERNEL
...

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
