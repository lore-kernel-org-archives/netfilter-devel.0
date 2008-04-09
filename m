From: Anton <anton.vazir@gmail.com>
Subject: SVN ULOG2
Date: Wed, 9 Apr 2008 15:20:28 +0500
Message-ID: <200804091520.28617.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:47071 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYDIK1J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:27:09 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

A little question, regarding the current status of ULOGD2, 
and could it be used in the live accounting? 
Just trying to compile fresh SVN of ulog2 and noticed that 
lots of dependencies to fresh versions of NF libraries, and 
ULOG2 tries to compile MAC2STR, which does not exists in the 
ULOGD2 sources tree, so I had to remove it from Makefile to 
get it compiling.
Maybe ULOGD2 still is in deep development and not ready to 
any use yet?

Thanks in advance,
Anton.
