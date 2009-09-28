From: "Florian Fuessl" <flo@degnet.de>
Subject: T.38 FAX support via nf_nat_sip,nf_conntrack_sip
Date: Mon, 28 Sep 2009 19:10:24 +0200
Message-ID: <002401ca405e$91c4ae90$b54e0bb0$@de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail04.viruscheckservice.de ([80.73.96.84]:51210 "EHLO
	mail04.viruscheckservice.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433AbZI1RRB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:17:01 -0400
Content-Language: de
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

T.38 FAX support via nf_nat_sip,nf_conntraack_sip does currently not seem to
work, because the REINVITE for the codec change is not handled correctly at
the moment (Figure: Fax Pass-Through and Call Flow diagram i.e. at
http://docwiki.cisco.com/wiki/Cisco_IOS_Voice_Troubleshooting_and_Monitoring
_--_Fax_Call_Flow )

Do you have an idea how to patch this problem?

-Florian

