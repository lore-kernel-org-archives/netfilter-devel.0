From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: locking iptables configuration
Date: Tue, 13 Dec 2011 20:32:49 +0000
Message-ID: <4EE7B671.4020101@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39684 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1LMUcy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:32:54 -0500
Received: by wgbdr13 with SMTP id dr13so114205wgb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2011 12:32:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Would it be possible to add an option to iptables preventing it from 
making any (rule) changes to the chains, in effect locking its 
configuration?

There is something similar done with auditctl - "auditctl -e 2" locks 
and prevents any further changes to its configuration and logs any such 
attempts to the audit log file. It would be nice if I could load my 
iptables(-saved) configuration/rules and then use that option to lock it 
so that it cannot be changed until the next time the machine reboots. Is 
this (easily) doable?
