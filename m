From: Jan Engelhardt <jengelh@inai.de>
Subject: Suspicious iptables snapshot in NF FTP
Date: Wed, 15 May 2013 22:59:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1305152256410.8046@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41026 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab3EOU7H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 16:59:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by ares07.inai.de (Postfix) with ESMTP id 33DEF96A07E8
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2013 22:59:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


A script in conjunction with the openSUSE Build Service has reported 
that a new version "030513" of iptables, which is due to the 
new existence of

 http://ftp.netfilter.org/pub/iptables/iptables-030513.tar.bz2

This file looks somewhat out of place (were snapshots not in another 
directory?) and is possible to be flagged up Debian and other distros' 
"new version update"-type search programs as well.
