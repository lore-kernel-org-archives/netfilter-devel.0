From: "Roth, Andrew" <andrew.roth@etrade.com>
Subject: Problems Compiling netfilter_queue on Fedora 14
Date: Fri, 27 May 2011 18:29:11 +0000
Message-ID: <B7A0862DFA14654BB90599BAA9BC479329370C52@atl1ex10mbx2.corp.etradegrp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1w27m3.etrade.com ([198.93.34.160]:58004 "EHLO
	mx1w27m3.etrade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1E0TCz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 15:02:55 -0400
Received: from atl1ex10ht2.corp.etradegrp.com (lbint6p27m3.etrade.com [10.53.27.144])
	by mx1w27m3.etrade.com (8.13.8/8.13.8) with ESMTP id p4RITCU3027894
	for <netfilter-devel@vger.kernel.org>; Fri, 27 May 2011 11:29:12 -0700
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am having a problem with the nfqnl_test.c program.  I have installed the needed packages to build the program and it builds with no errors.  When I run the program, it returns an error.  Can someone explain what this error is?

Program Output:
# ./nfqnl_test 
opening library handle
unbinding existing nf_queue handler for AF_INET (if any)
error during nfq_unbind_pf()

The source code for nfqnl_test.c can be found here:
http://www.netfilter.org/projects/libnetfilter_queue/doxygen/nfqnl__test_8c_source.html

Thanks,

~Andrew Roth




