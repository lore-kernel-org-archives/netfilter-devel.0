From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 0/12] make progress ulogd_output_IPFIX
Date: Tue, 3 Jun 2014 19:01:30 +0900
Message-ID: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62651 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFCKBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:01:37 -0400
Received: by mail-pb0-f52.google.com with SMTP id rr13so5284064pbb.25
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:01:37 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

This patches confined primarly to build IPFIX message, does not send it yet.
Changes from v2:
  does not add new u64 usec okey at NFCT
  some minor fixes related to IPFIX at NFCT
  compare input keys using nfct_bitmask_test_bit

Thanks,
