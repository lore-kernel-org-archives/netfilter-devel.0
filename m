From: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Subject: [ULOGD2] missing file Rules.make.in needed by configure.in
Date: Wed, 21 May 2008 10:55:41 +0200
Message-ID: <200805211055.42278.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:46224 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYEUJQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 05:16:00 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Running autogen.sh from current ulogd2.git  results in the following error:

~/git/ulogd2$ ./autogen.sh
configure.in: installing `./install-sh'
configure.in: installing `./missing'
filter/Makefile.am: installing `./depcomp'
configure.in:75: required file `Rules.make.in' not found

