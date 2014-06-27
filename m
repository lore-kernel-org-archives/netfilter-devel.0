From: netfilter@tsaunders.co.uk
Subject: sockopts
Date: Fri, 27 Jun 2014 16:13:42 +0100 (BST)
Message-ID: <Pine.LNX.4.64.1406271607001.4915@fedex.thefeds.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fedex.thefeds.net ([81.168.97.116]:48088 "EHLO
	fedex.thefeds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaF0QKR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:10:17 -0400
Received: from fedex.thefeds.net (fedex.thefeds.net [127.0.0.1])
	by fedex.thefeds.net (8.13.8/8.13.8) with ESMTP id s5RFDh9g004942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2014 16:13:43 +0100
Received: from localhost (elwe@localhost)
	by fedex.thefeds.net (8.13.8/8.13.8/Submit) with ESMTP id s5RFDghE004939
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2014 16:13:43 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am maintaining a proprietary netfilter module. The module fails to load 
when ip_set is loaded and ip_set won't load when it is loaded. I think 
this may be because the sockopt number the original developer chose 
clashes with the number ip_set uses. Would this clash cause such a 
problem?

I have read the netfilter hacking howto and searched, but I cannot find 
any details of how to choose a sockopt number. Is there any documentation?

Thanks
Tim
