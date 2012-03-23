From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: ipset nomatch not showing
Date: Fri, 23 Mar 2012 12:58:16 +0000
Message-ID: <4F6C7368.3040905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42518 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2CWM61 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:58:27 -0400
Received: by wgbdr13 with SMTP id dr13so2099076wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 05:58:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I create a set using the following set of statements:

ipset n test-net hash:net family inet timeout 0 hashsize 64
ipset a test-net 10.1.1.0/24
ipset a test-net 10.1.1.2 nomatch

and then issue "ipset l test-net" I get this:
Header: family inet hashsize 64 maxelem 65536 timeout 0
Size in memory: 924
References: 0
Members:
10.1.1.0/24 timeout 0
10.1.1.2 timeout 0

It is not clear whether the "nomatch" option on the 10.1.1.2 member I 
used above is in fact non matching. Am I missing something?

Also, a minor nitpick on some of the help text displayed using "ipset help":
-n
        When listing, list just setnames from kernel.

It should be "When listing, just list setnames from the kernel."

-!
        Ignore errors when creating already created sets,
        when adding already existing elements
        or when deleting non-existing elements.

It should be "Ignore errors when creating or adding sets or elements 
that do exist or when deleting elements that don't exist."
