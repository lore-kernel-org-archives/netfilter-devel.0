From: "Srinivas Murthy" <codevana@gmail.com>
Subject: How to disable Connection Tracking runtime
Date: Mon, 5 May 2008 20:38:41 -0700
Message-ID: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:61572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYEFDim (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2008 23:38:42 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1468107rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 May 2008 20:38:42 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
 Is there a way to disable conntracking runtime?

 I see a lot of cpu time taken up by these fns:

__hash_conntrack
ipt_do_table
conn_hash_table_lookup

 I did see the perf tweaking params related to this but for test
purposes, I'd like to try w/ this disabled altogether (and going via/
the kernel config file is too painful for now).

Thanks.
