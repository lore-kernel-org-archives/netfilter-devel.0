From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 0/8] make progress ulogd_output_IPFIX
Date: Sat, 8 Mar 2014 10:03:46 +0900
Message-ID: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43356 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaCHBD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:03:56 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so4903725pab.33
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:03:56 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id js7sm41878739pbc.35.2014.03.07.17.03.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:03:54 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hello,
 
If there is someone who is working on ulogd_output_IPFIX, please let me
know. I need it and would work on it.
 
This patch series make progress, not work completely, just print IPFIX
packet format. Would you review this? I think this has four issues.
 
* Install nfct_bitmask in libnetfilter_conntrack
  This needs libnetfilter_conntrack patch I'll send after.
 
* Send only one dataset, not multiple at once
  And it (will) send a message each time when output_ipfix() is called.
  It's not efficient sending.
 
* No options template and data
  Do we need these scope data?
  4. Specific Reporting Requiremt in RFC7011, says MAY be implemented
 
* Template retransmit timing
  It send template per messages specified in config file. 
  I took a glance softflowd and follow that.

Thanks. 
