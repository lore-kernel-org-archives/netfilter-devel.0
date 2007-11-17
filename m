From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sat, 17 Nov 2007 09:48:37 +0100
Message-ID: <m38x4x6yvu.fsf@ursa.amorsen.dk>
References: <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com> <20071116.161926.00949588.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52382 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbXKQIss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:48:48 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1ItJM4-00045s-TP
	for netfilter-devel@vger.kernel.org; Sat, 17 Nov 2007 08:48:44 +0000
Received: from hd5b9080a.c45-01-12.sta.perspektivbredband.net ([213.185.8.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2007 08:48:44 +0000
Received: from benny+usenet by hd5b9080a.c45-01-12.sta.perspektivbredband.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2007 08:48:44 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>>>>> "DM" == David Miller <davem@davemloft.net> writes:

DM> I disagree, passive ftp is extremely pervasive, there is no reason
DM> to use traditional ftp these days.

Active FTP needs helpers on the client side, passive FTP needs helpers
on the server side.


/Benny


