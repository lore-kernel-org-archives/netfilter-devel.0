From: Jianqing Zhang <arrow.jianqing@gmail.com>
Subject: iptables vs. IPsec SP
Date: Wed, 18 Feb 2009 10:17:06 -0600
Message-ID: <8a38e1330902180817h6a2f9017v1b38b7f6a75fd6b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:36174 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZBRQRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:17:07 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1299265yxm.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Feb 2009 08:17:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I configure both IPsec SPs and iptables, when an IP packet is going
out or coming,  which will process the packet first? SP or iptables
(netfilters) rules?

Thanks
