From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 0/13] make progress ulogd_output_IPFIX
Date: Mon, 28 Apr 2014 20:39:36 +0900
Message-ID: <20140428113936.GA12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44981 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaD1Ljn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:39:43 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so2225272pdj.29
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:39:42 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id kj1sm34498484pbd.20.2014.04.28.04.39.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:39:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

Would you review IPFIX patchset? Compared with previous one,

change:
* configure.ac
  check if new libnetfilter_conntrack bitmask functions
  exists or not.

* ulogd_output_IPFIX.c
  remove odd space

add:
* ulogd_inpflow_NFCT.c
  - fix field id of "flow.end.usec"
  - introduce IPFIX_VENDOR_REVERSE field from RFC5103
  - introduce new key "flow.(start|end).mcsec for
    flow(Start|End)MicroSecond
  - add debug symbol for yafscii

Thanks,
