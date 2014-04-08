From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [libnetfilter_conntrack/ulogd PATCH 0/3] add mark filter
Date: Tue, 8 Apr 2014 19:26:16 +0900
Message-ID: <20140408102614.GA29462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56091 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbaDHK0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:26:22 -0400
Received: by mail-pd0-f173.google.com with SMTP id z10so818361pdj.18
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2014 03:26:22 -0700 (PDT)
Received: from gmail.com (softbank220009032009.bbtec.net. [220.9.32.9])
        by mx.google.com with ESMTPSA id dy7sm8336984pad.9.2014.04.08.03.26.19
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 08 Apr 2014 03:26:20 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

This patch series enables mark filtering in NFCT plugin.
Would you review it? I think there are two issues:

* libnetfilter_conntrack
  I reused struct nfct_filter_dump_mark for NFCT_FILTER_MARK
  nfct_filter_add_attr(). Should I introduce a new one which
  will be the same field?

* ulogd
  I've changed all dump function to use nfct_filter_dump
  excepting in do_purge(). It may require many tests so that
  is it better having a field to check mark filter has set
  and checking it on dumping?

Thanks.
