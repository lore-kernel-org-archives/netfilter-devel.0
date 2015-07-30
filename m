From: Rudolf_AT <Rudolf_AT.nf@aon.at>
Subject: IP sets: Suggestion: additional value match
Date: Thu, 30 Jul 2015 17:29:45 +0200
Message-ID: <55BA42E9.70808@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout-fallback.aon.at ([195.3.96.119]:20823 "EHLO
	smtpout-fallback.aon.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbbG3Pgc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 11:36:32 -0400
Received: from unknown (HELO smtpout.aon.at) ([172.18.1.201])
          (envelope-sender <Rudolf_AT.nf@aon.at>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 30 Jul 2015 15:29:50 -0000
Received: from 213-240-124-94.adsl.highway.telekom.at (HELO [192.168.1.66]) ([213.240.124.94])
          (envelope-sender <Rudolf_AT.nf@aon.at>)
          by smarthub81.res.a1.net (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <netfilter-devel@vger.kernel.org>; 30 Jul 2015 15:29:46 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

when working with IP sets, I came up with the following idea:
adding a value match:

  -j SET --add-set set1 flag[,flag]=value
  --match-set set1 flag[,flag]=value

Where value is an integer which is set in the added list element of the 
SET target. The value does not change the dimension of the list. The 
match is true only if the given value is equal to the value stored in 
the found element.

Optionally adding an arbitrary value could help using IP sets in even 
more ways than now, for example easily tracking packets independently of 
other extensions or matches.

For example, instead of using three sets to distinguish between three 
different states:
  -j SET --add-set state1set src,dst,dst
  -j SET --del-set state2set src,dst,dst
  -j SET --del-set state3set src,dst,dst
one would write:
  -j SET --add-set aset1 src,dst,dst=<integer>
Where <integer> resembles state1|state2|state3 then.

Maybe you can think of more uses for this feature.
As a further enhancement bit operators might be useful, too.

Best Regards,
Rudolf
