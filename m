From: "Ashwini R" <ashwinir.11@gmail.com>
Subject: Setting source routing option using netfilter
Date: Tue, 11 Dec 2007 16:35:15 -0700
Message-ID: <c0549e500712111535g4d9ba530n47a346b32d3b6b84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:4887 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXLKXfQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:35:16 -0500
Received: by wr-out-0506.google.com with SMTP id c49so10535wra.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Dec 2007 15:35:15 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am trying to dynamically add IP_Options to the packet header in
2.6.23 kernel to perform strict source routing. I am using Netfilter
hooks (NF_IP_LOCAL_OUT hook) to intercept the packet before it goes
out of the host. If the IP_Options are set through setsockopt() in my
application, I am able to read those options using Netfilter. However,
I am not sure how to insert new IP_Options into packets originating
from another application. Could anyone please point me to some
documentation or sample code regarding this.

Thank you,

Ashwini.
