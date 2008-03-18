From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: interface based conntrack entry
Date: Tue, 18 Mar 2008 14:58:31 +0100
Message-ID: <m3ve3kp20o.fsf@ursa.amorsen.dk>
References: <CAC6870A2B8FE846AD24D7E75B05F90A3F1960@moe.nextone.local> <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local> <20080317232543.GB4003@bayen.regit.org> <Pine.LNX.4.64.0803180032560.18817@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52141 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYCRN6t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:58:49 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JbcKu-0000Qf-TK
	for netfilter-devel@vger.kernel.org; Tue, 18 Mar 2008 13:58:40 +0000
Received: from hd5b9080a.c45-01-12.sta.perspektivbredband.net ([213.185.8.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2008 13:58:40 +0000
Received: from benny+usenet by hd5b9080a.c45-01-12.sta.perspektivbredband.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2008 13:58:40 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@computergmbh.de> writes:

> I believe that nf_conntrack deliberately does not use interfaces
> as tuple parts because packets may very well come in on
> and/or leave on different interfaces (routing on fwmark).

As a reminder, this makes it very important that Linux firewalls have
rp_filter set to true -- or that they drop packets coming in on the
"wrong" interface BEFORE the customary -A FORWARD -m state --state
RELATED,ESTABLISHED -j ACCEPT


/Benny


