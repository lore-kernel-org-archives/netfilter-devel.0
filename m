From: Phil Oester <kernel@linuxace.com>
Subject: nfnetlink_queue question
Date: Tue, 9 Jul 2013 15:40:14 -0700
Message-ID: <20130709224013.GA22816@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50046 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GIWkS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:40:18 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so5692293pdi.16
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2013 15:40:17 -0700 (PDT)
Received: from linuxace.com (cpe-76-171-169-87.socal.res.rr.com. [76.171.169.87])
        by mx.google.com with ESMTPSA id xl3sm30311896pbb.17.2013.07.09.15.40.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 09 Jul 2013 15:40:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The in-kernel header file include/uapi/linux/netfilter/nfnetlink_queue.h
nfqnl_attr_type enum includes two additional types:

        NFQA_CAP_LEN,                   /* __u32 length of captured packet */
        NFQA_SKB_INFO,                  /* __u32 skb meta information */

Which are not in the version shipped with libnetfilter_queue.  Should
these be in sync?

Phil
