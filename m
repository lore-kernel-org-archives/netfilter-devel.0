From: "misano riccione" <misano.riccione@europe.com>
Subject: build a traffic classificator
Date: Sat, 22 Mar 2008 11:21:55 -0500
Message-ID: <20080322162155.722851F50B2@ws1-2.us4.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:38100 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYCVQV4 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:21:56 -0400
Received: from 242.8.168.192.in-addr.arpa (242.8.168.192.in-addr.arpa [192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id C172C1800200
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2008 16:21:55 +0000 (GMT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.
I need to build a traffic analyzer i.e. a machine which I can insert in a ethernet branch.
It must have two nics and all (all kind of) packets (ARP, IP, TCP, UDP, etc.) must transparently traverse the nics.
Then I must analyze tcp/udp packets and sessions and write a program to dinamically mangle tcp/udp packets.

Could someone help me to trace a way to do that ?
thanks


-- 
Want an e-mail address like mine?
Get a free e-mail account today at www.mail.com!

