From: Nicolas Bareil <nico@chdir.org>
Subject: Re: scrubbing support in Netfilter
Date: Wed, 28 May 2008 09:33:31 +0200
Message-ID: <87d4n6nar8.fsf@chdir.org>
References: <87hccjdbm4.fsf@chdir.org>
	<alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr>
	<483CE1D7.30408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33983 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYE1HkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 03:40:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K1GGQ-0004Wv-GQ
	for netfilter-devel@vger.kernel.org; Wed, 28 May 2008 07:40:02 +0000
Received: from moog.chdir.org ([88.191.42.160])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2008 07:40:02 +0000
Received: from nico by moog.chdir.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2008 07:40:02 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> writes:
> No, unless you're refering to the unwanted side-effects from
> defragmentation and refragmentation for IPv4. I also don't
> want to include something like this in netfilter, NAT is
> already bad enough and the threats it *might* protect against
> seem a bit vague. Better throw your broken IDS out if can
> be fooled by changing TTLs.

Indeed, you're totally right : in an ideal world, it should be useless
and avoided, but there are cases where you need "a workaround" because
you have some legacy equipement, broken IDS, broken TCP/IP stack, etc.

> I don't want to sound too discouraging though, I have no problem
> adding it to the pom-ng sources.list.

No problem, if you feel it better fits there, I'm ok with that.

> I assume its a random offset per connection, but still, no.
> You can also still distinguish different hosts by their clock
> rates.

What do you mean precisely ? Variation of the TCP Timestamp ?  TCP
retransmission mechanisms ?

Thanks

-- 
Nicolas Bareil                                  http://chdir.org/~nico/
OpenPGP=0xAE4F7057 Fingerprint=34DB22091049FB2F33E6B71580F314DAAE4F7057

