From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: Reverse Nat and ICMP packet
Date: Thu, 29 Jan 2009 20:59:06 +0100
Message-ID: <417f50830901291159ma6ad4dbm454abc04f66e94e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:49748 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZA2T7I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:59:08 -0500
Received: by ey-out-2122.google.com with SMTP id 25so33337eya.37
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2009 11:59:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi:


I've a netfilter module that unpack a icmp packet and then there is a
NAT to internet but in the back there is a problem the NAT don't do
anything in prerouting.
The question is the reverse is done with a match for address and what
else? , i cannot no see it. I supposse that the macht is not done and
then the reverse is not done too, perhaps the id or sequence fields of
icmp are involved too.

Any clue, thanks anyway.




-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
