From: =?iso-8859-1?Q?Giuseppe_Macr=EC?= <macri.giuseppe.disk@gmail.com>
Subject: NAT connection
Date: Mon, 12 Apr 2010 10:55:16 -0500
Message-ID: <F9F341B6-9283-4339-A8C4-B08754B98E01@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:54578 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DLPzU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:55:20 -0400
Received: by iwn35 with SMTP id 35so1173106iwn.21
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Apr 2010 08:55:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I woud like to communicate some information between ip_nat module and the user space, not regardin the packet queue but the established connections in the nat. Is it possible to use copy_to_user function? In that case do you know which is the syscall related to ip_nat module in order to retrieve information from user space?
Or is a different way to retrieve information about nat connection?
Thanks

Giuseppe