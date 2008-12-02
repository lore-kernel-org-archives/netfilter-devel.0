From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: More nf_conntrack_sip questions
Date: Tue, 02 Dec 2008 14:36:53 -0800
Message-ID: <4935B885.8030107@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:55180 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYLBWgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:36:45 -0500
Received: from [192.168.10.6] (tosh.redfish-solutions.com [63.224.43.239])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.2/8.14.2) with ESMTP id mB2MafhB011222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Dec 2008 15:36:43 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I did a little investigation into my one-way voice issue, and noticed 
that if I don't do voice-menus (i.e. where the Asterisk box itself 
generates the first outbound INVITE, then passes-through the 2nd INVITE 
once a handset picks up) then I get two-way voice (i.e. with sending the 
call directly to the phone).  (In this topology, my Asterisk box is also 
my firewall/NATting router...)

If I enable the voice menus in the inbound dialplan, however, it can 
hear the voice menus, but not the called-party when they pick up their 
phone (extension).

So someone (either the SIP conntrack module on the Asterisk border 
firewall or else the SBC at the ILEC) is failing to look into the 2nd 
INVITE (i.e. we're not rewriting it properly as it goes by, or the SBC 
is failing to see it).

I've put traces up on ftp://ftp.redfish-solutions.com/ as:

trace-20081128-230313.br0
trace-20081128-230313.br1
trace-20081128-230415.br0
trace-20081128-230415.br1

The traces on interface "br1" are the "internal" network, with private 
192.168.1.x addresses.  The "br0" traces are after outbound NATting (and 
conntrack rewriting) has been applied.

This was done on a Linux 2.6.25.19 box with iptables v1.4.2.

Thanks,

-Philip

