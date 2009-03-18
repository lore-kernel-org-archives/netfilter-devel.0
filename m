From: AMIT ARORA <amitarora.iitb@gmail.com>
Subject: Destination MAC Address
Date: Wed, 18 Mar 2009 17:43:25 +0530
Message-ID: <c19f67d70903180513l5aefe0e3qeae3b149eea1a255@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:18154 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZCRMN1 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:13:27 -0400
Received: by wf-out-1314.google.com with SMTP id 29so27124wff.4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2009 05:13:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello guys,
I am new to netfiler. I am hooking the packet from the INPUT hook of
the iptables through libnetfilter_queue. I am able to get the source
MAC address of the captured packet but not the Destination MAc (if it
was a broadcast or addressed to my machine).
Can someone please help

Thanks
Amit

--

Samuel Beckett =A0- "Birth was the death of him."
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
