From: laurent.brando@mindspeed.com
Subject: NFCT_Q_UPDATE and IPv6
Date: Fri, 5 Oct 2007 17:34:14 +0200
Message-ID: <OF38CFDD8B.3B74F76F-ONC125736B.0053E9D0-C125736B.0055898A@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail190.messagelabs.com ([216.82.249.51]:8402 "HELO
	mail190.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763410AbXJEPeW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:34:22 -0400
Received: from npblnh1.la.mindspeed.com (inbound.la.mindspeed.com [10.1.16.81])
	by mspdsmtp2.mindspeed.com (8.11.7p3+Sun/8.11.7) with ESMTP id l95FYqS11814
	for <netfilter-devel@vger.kernel.org>; Fri, 5 Oct 2007 08:34:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm facing some issues trying to update UDP/TCP timeout attribut of an 
existing Ipv6 conntrack. 

It looks like call to nfct_query(ct_handler, NFCT_Q_UPDATE, ct) never 
returns and my application thread
gets killed.

I'm about to put some debug after the call to nfct_query , but I would 
like to know if any of you is aware of such
problem or  similar issue. 

Also, any proposal to narrow down the issue in an efficient way would be 
appreciated.

I'm using linux 2.6.21 + libnfnetlink 0.0.30 + libnetfilter_conntrack 
0.0.81.

Please note that I have no problem with Ipv4 connections.

Regards,
Laurent


