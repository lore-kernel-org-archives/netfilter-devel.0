From: Patrick Schaaf <netdev@bof.de>
Subject: TOS target mask - leave alone the ECN bits
Date: Sun, 10 Nov 2013 12:53:21 +0100
Message-ID: <1475190.7d3oHlGIdH@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42703 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3KJLxZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Nov 2013 06:53:25 -0500
Received: by mail-ee0-f46.google.com with SMTP id b57so1873176eek.5
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Nov 2013 03:53:24 -0800 (PST)
Received: from rofl.localnet (p5DCB1DD3.dip0.t-ipconnect.de. [93.203.29.211])
        by mx.google.com with ESMTPSA id i1sm48406993eeg.0.2013.11.10.03.53.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 10 Nov 2013 03:53:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear netfilter developers,

I'm stumbling over a confusion, maybe just mine, regarding the use of the mask 
value of the TOS target in order to avoid messing with the ECN bits within. 

I thought I understood the issue, starting to use, for example:

	-j TOS --set-tos 0x0c/0xfc

which should result in A) leaving ECN alone and B) set the DSCP bits to 
000011, the first "reserved for local use" value.

The confusion I'd like to clear up with this mail, is that googling around to 
confirm my understanding, I found the following text in my iptables-extensions 
manual page for the tos _match_ --tos option:

	... Note that this implies a mask of 0x3F, i.e. all but the ECN bits.

Is my understanding wrong, should I use --set-tos 0x03/0x3f instead for the 
example above? Or is the manpage wrong?

best regards
  Patrick
