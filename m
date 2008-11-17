From: "varun uppal" <varuneet.uppal@gmail.com>
Subject: problems with iptables and ip_queue
Date: Mon, 17 Nov 2008 16:50:28 +0000
Message-ID: <ed1bf3f70811170850u7b6f5019o39ec2295ce0aaaa9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:34975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKQQu2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:50:28 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2505888rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 08:50:28 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

  I have a utility which uses iptables and captures the incoming
packets on INPUT chain of filter table. I am getting a wierd problem,
the incoming TCP segments start getting rejected due to incorrect
checksum by my utility. I took tcpdump on ethernet interface and
loopback interface, the segments on ethernet interface are fine, but
by the time they are passed on to my application by iptables using
ip_queue, the packets are corrupted. The TCP payload gets reset to
zeroes, and thus my application when verifies the checksum, discards
the segment on finding it incorrect.
Surprisingly it happens only with segments greater than 200bytes in
length. This problem is driving me crazy. Any help will be more than
welcome.
I have red hat enterprise linux 4, with kernel 2.6.9-42 and iptables
version 1.2.11

thanks
varun
