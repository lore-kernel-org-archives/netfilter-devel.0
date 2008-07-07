From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: New Version of IPtables (iptables-tng) Ver2.0
Date: Mon, 7 Jul 2008 10:06:55 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807071002180.28765@fbirervta.pbzchgretzou.qr>
References: <464293e60807062032q6c7fd622h6e364eae33018dc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: hamid jafarian <hamid.jafarian@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41221 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbYGGIG5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:06:57 -0400
In-Reply-To: <464293e60807062032q6c7fd622h6e364eae33018dc1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-07 05:32, hamid jafarian wrote:
>
>To see Ver1.0 Features and throughput tests: http://iptablestng.sourceforge.net/


"Adding 10000 rules" taking 5 minutes 11 seconds.
That's a hilarious joke still, because you should not be using iptables 
for that; at least not now.

# time iptables-restore 10000.rules

real    0m0.120s
user    0m0.079s
sys     0m0.039s
