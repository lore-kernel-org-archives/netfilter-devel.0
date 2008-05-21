From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 04:33:54 -0400
Message-ID: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:11425 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYEUIdz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 04:33:55 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2474545rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 01:33:54 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is a problem which I used to have with MASQUERADE,

When the machine boots - naturally there are some connections which

begin to flow as soon as the first ppp interface comes up...
Some of these connections remain open for days - for example - openvpn
and iax2 trunks...


Since ppp0 always come up first, then these connections begin to flow
via ppp0 and with the MASQ IP of ppp0...

Later, when the mangle-rules kick-in, these connections are being
router via ppp4 (which is what I want)...
So far no problem..


The only problem is that these packets now exit via ppp4 but they
continue to keep the source IP of ppp0


Ok, I tried to use the userspace conntrack-tool to search and remove
these entries, but this tool doesn't allow me to do something like this

$> conntrack -L conntrack -d IP

...without asking me the complete tuple-information. I can't delete every

entry with a specific IP either without providing a complete tuple.


Maybe we could add a parameter to the target masquerade, which could add
a flag in the conntrack that would mean "don't use the conntrack entry, we

want to go through the MASQUERADING code again".

What you guys think it should be wise to do ?

thank you
Nick
