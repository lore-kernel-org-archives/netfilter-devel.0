From: Justin Yaple <yaplej@gmail.com>
Subject: Source for tracking tcp sessions?
Date: Thu, 17 Sep 2009 22:01:46 -0700
Message-ID: <8363055a0909172201l4ba0499fw9d102721c76c0c83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:42490 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZIRFBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:01:42 -0400
Received: by ywh5 with SMTP id 5so899407ywh.4
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 22:01:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am just playing around with a kernel module to sniff network
traffic, but I would also like to enable it to save session
information.  I was trying to find the source that shows what
netfilter does to uniquly identify a session, and then how it saves it
so it can be matched to packets later.

My end goal prevents me from just using anything that already in conntrack.

Thanks.
