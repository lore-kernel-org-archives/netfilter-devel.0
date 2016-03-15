From: ravin goyal <ravirocks1021@gmail.com>
Subject: libnetfilter_conntrack's NFCT_OF_TIMESTAMP is not working
Date: Tue, 15 Mar 2016 12:04:35 +0530
Message-ID: <CANU0Mn3qL9Bd=fJAzpAhwit9WQas3N9oMynuunLBS+3084=Btw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35394 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbcCOGfB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 02:35:01 -0400
Received: by mail-vk0-f42.google.com with SMTP id e6so8895545vkh.2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 23:35:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

this email is in reference to previous email regarding the NFCT_OF_TIMESTAMP,

setting /proc/sys/net/netfilter/nf_conntrack_timestamp to 1 or 0
doesn't run the following code in
/libnetfilter_conntrack-1.0.4/src/conntrack/snprintf_default.c file

        if (flags & NFCT_OF_TIMESTAMP) {
                if (test_bit(ATTR_TIMESTAMP_START, ct->head.set)) {
                        ret = __snprintf_timestamp_start(buf+offset, len, ct);
                        BUFFER_SIZE(ret, size, len, offset);
                }
                if (test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
                        ret = __snprintf_timestamp_stop(buf+offset, len, ct);
                        BUFFER_SIZE(ret, size, len, offset);
                }
        }

flags and NFCT_OF_TIMESTMP is always 1 and 8 respectively no matter value of
/proc/sys/net/netfilter/nf_conntrack_timestamp is 1 or 0

So what value should i set of nf_conntrack_timestamp if i want to get
start and stop timestamp from __snprintf_timestamp_start and
__snprintf_timestamp_stop respectively.

Regards
Ravin Goyal
