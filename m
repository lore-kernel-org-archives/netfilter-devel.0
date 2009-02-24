From: Abhishek Singh <abhishek@abhishekonline.info>
Subject: ROUTE patch
Date: Tue, 24 Feb 2009 14:29:57 +0530
Message-ID: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:30588 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZBXI77 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:59:59 -0500
Received: by qb-out-0506.google.com with SMTP id q18so1442634qba.17
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2009 00:59:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Everyone

A long time ago, iptables used to have a ROUTE extension. This option
adds a `ROUTE' target, which enables you to setup unusual routes. For
example, the ROUTE lets you route a received packet through an
interface or towards a host, even if the regular destination of the
packet is the router itself. The ROUTE target is also able to change
the incoming interface of a packet.

This extension was discontinued sometime in 2007 and there as of now,
such a ROUTE target does not exist. I found it rather useful and
upgraded its source code to work with the latest kernel and the latest
iptables code also.

What I would like to know is that if someone would like to add it to
the main iptables tree and the patchomatic repository. I am not sure
how to go about it. If someone is interested, please let me know. I
shall contribute the code and if would be happy to incorporate review
comments by other developers.

Regards
Abhishek
