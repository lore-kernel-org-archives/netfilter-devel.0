From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Identifying if the packet has been conn tracked by the conn track
	module in the NAT module.
Date: Thu, 5 Mar 2009 11:17:23 +0530
Message-ID: <17923cc80903042147p6426a582tb503bff825ab0a5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f163.google.com ([209.85.217.163]:44016 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZCEFrZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 00:47:25 -0500
Received: by gxk7 with SMTP id 7so4189701gxk.13
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Mar 2009 21:47:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to know if its possible for the NAT module to know if the
packet sent to it has been identified by conn track modules like FTP,
H323 and is treated differently than simple NAT.

Thanks
-Sachin
