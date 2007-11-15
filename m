From: "=?utf-8?B?RGFuaWVs?=" <zyzhou1@gmail.com>
Subject: =?utf-8?B?SG93IGFib3V0IGlzc3VlaW5nIGNvbm50cmFjayBldmVudCBpbiBpbml0X2Nvbm50cmFjaygpPw==?=
Date: Thu, 15 Nov 2007 17:38:19 +0800
Message-ID: <200711151738170572772@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
To: =?utf-8?B?bmV0ZmlsdGVyLWRldmVs?= <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:25520 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbXKOJi0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:38:26 -0500
Received: by rv-out-0910.google.com with SMTP id k20so443709rvb
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2007 01:38:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

hi, all

We all know event IPCT_NEW is issued whenever conntrack is confirmed,
then how about issueing a IPCT_INIT event in init_conntrack()? 
IPCT_INIT indicates that one IP is trying to create a connection, maybe 
we can catch these kind of events, do some analyzation work, and block 
the evil *attempting* packet(this will prevent conntrack being confirmed). 

Is this make any sense?

Thanks :-)

Daniel
2007-11-15

