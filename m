From: ilninno <ilninno@gmail.com>
Subject: I need help with libnetfilter_queue
Date: Sun, 23 Nov 2008 15:03:49 +0100
Message-ID: <92770c820811230603p4276d98bnc41df9606f4c6bc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:50847 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbYKWODw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:03:52 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1378487rnd.17
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Nov 2008 06:03:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again! I need help with libnetfilter_queue, I searched examples,
but I only found one simple test. My problem is that i need source ip
and source port, but i don't know how can i get from struct nfq_data
*pkt in the callback function.


Sorry for my english and thanks for your time :)
