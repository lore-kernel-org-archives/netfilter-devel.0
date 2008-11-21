From: "varun uppal" <varuneet.uppal@gmail.com>
Subject: problem with iptables....badly need help
Date: Fri, 21 Nov 2008 11:40:31 +0000
Message-ID: <ed1bf3f70811210340m2892dc67lbb8af84078905eee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:39549 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYKULkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:40:31 -0500
Received: by rv-out-0506.google.com with SMTP id k40so911768rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2008 03:40:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using iptables to queue the packets and then
read them from
IP_queue.
The downloads stop, I took tcpdump on Ethernet interface
and loopback
interface, the data seems to be getting corrupted
By the time it hits INPUT chain or is read from ip_queue.
I have red hat enterprise linux 4, with kernel 2.6.9-42
and iptables
version 1.2.11

please please badly need help.

thanks
varun
