From: jamal <hadi@cyberus.ca>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
	request]]
Date: Sun, 17 May 2009 12:59:13 -0400
Message-ID: <1242579553.3996.81.camel@dogo.mojatatu.com>
References: <4A0E9786.8060407@netfilter.org>
	 <1242566196.3996.23.camel@dogo.mojatatu.com>
	 <4A10235B.3070607@netfilter.org>
	 <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>
	 <4A103751.9060501@netfilter.org>
	 <alpine.LSU.2.00.0905171822570.6819@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:46800 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZEQQ75 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 12:59:57 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2231659qwd.37
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2009 09:59:57 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905171822570.6819@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2009-05-17 at 18:39 +0200, Jan Engelhardt wrote:

> Compatibility is the ultimate killer argument against about anything. 

Once you have user of an API, that arguement becomes hard to defend.
It is certainly a lesson learnt on the development of the
internet: You cant just replace IPV4, TCP, NAT and a lot of other
protocols and practises that people are using. You can incrementally
"fix them". You can the parallel provide the new way (IPv6).

cheers,
jamal


