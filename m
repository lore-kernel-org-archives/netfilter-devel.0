From: Ben Gamsa <ben@somanetworks.com>
Subject: arptables issue with user-defined chains and -j RETURN
Date: Tue, 10 Jun 2008 12:40:14 -0400
Message-ID: <484EAE6E.30206@somanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.somanetworks.com ([216.126.67.42]:47973 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYFJQq5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:46:57 -0400
Received: from odo.yyz.somanetworks.com (HELO [10.11.11.50]) (ben@[10.11.11.50])
          (envelope-sender <ben@somanetworks.com>)
          by mail.somanetworks.com (qmail-ldap-1.03) with RC4-MD5 encrypted SMTP
          for <netfilter-devel@vger.kernel.org>; 10 Jun 2008 16:40:14 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm using version 0.0.3-3 of arptables (curently with a 2.6.20 kernel, soon
to be upgraded) and it seems like explicit and implicit RETURNs are not working.
What I believe is happening is that arptables includes its own version of
arp_tables.h (actually, two identical copies), with a definition for ARPT_RETURN.
Specifically, it defines it as:

#define ARPT_RETURN (-NF_MAX_VERDICT - 1)

while the kernel defines it as XT_RETURN, which in turn defines it as

#define XT_RETURN (-NF_REPEAT - 1)

The end result seems to be that rules that explicitly or implicitly use the
target RETURN actually end up with the target STOP, and so returns from
chains don't work.  Changing the definition of ARPT_RETURN in arptables to
match the definition of XT_RETURN appears to fix the problem.

-- 
Ben Gamsa             ben@somanetworks.com
SOMA Networks, Inc.   312 Adelaide St. W. Suite 600 Toronto, Ontario, M5V1R2
