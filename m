From: "Jianqing Zhang" <arrow.jianqing@gmail.com>
Subject: How to iptables' QUEUE?
Date: Fri, 31 Oct 2008 15:06:28 -0500
Message-ID: <8a38e1330810311306oaa38381g1b1b3f76ccbe3195@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:15876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYJaUG2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:06:28 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1429892rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2008 13:06:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I use iptables to filter incoming packets with some particular
protocols, such as ICMP, and the target is QUEUE.

=============================

Chain INPUT (policy ACCEPT)
target prot opt source destination
QUEUE icmp -- anywhere anywhere

Chain FORWARD (policy ACCEPT)
target prot opt source destination

Chain OUTPUT (policy ACCEPT)
target prot opt source destination

============================

How can I check QUEUE of iptables, i.e. how can I know iptables
captures the packets and put them in the QUEUE?

Thanks
