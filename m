From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Idea for a new NFQUEUE module (ebtables) ?
Date: Tue, 11 Jan 2011 16:09:49 +0100
Message-ID: <4D2C72BD.2040104@wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:40672 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753837Ab1AKPlq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:41:46 -0500
Received: from [88.171.131.12] (helo=fydelkass.edenwall.com)
	by sd-6807.edenwall.com with esmtp (Exim 4.69)
	(envelope-from <chifflier@wzdftpd.net>)
	id 1Pcfr3-0005rr-Lg
	for netfilter-devel@vger.kernel.org; Tue, 11 Jan 2011 16:09:49 +0100
Received: from piche2.inl.fr ([192.168.33.184])
	by fydelkass.edenwall.com with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <chifflier@wzdftpd.net>)
	id 1Pcfr3-0005ru-9X
	for netfilter-devel@vger.kernel.org; Tue, 11 Jan 2011 16:09:49 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I' currently looking at the kernel part of the code (for fun ;) ) and am
looking a ebtables.
I am thinking at writing a module to send packets to userspace, using
NFQUEUE. This has previously been asked [1] and Patrick answered there
could be problems, but if it makes some sense I'd like to try anyway

This would allow to queue packets to userspace, not only IP packet but
any protocol. I think this would also send the raw (not reassembled)
packets, which makes some sense for IDS like Suricata.

I've looked at the net/bridge code for core functions and modules, this
does not look impossible, though I must admit I'm not familiar with the
code at all and not understanding it entirely for the moment .. I've
looked at the ebt_NFLOG module and the netfilter NFQUEUE code to
understand how to implement it

Basically, I've started looking at the code and implementing a few
functions, but before going into deep modifications or problems, I'd
like to ask if that sounds like a good idea at all ?
If yes, I'll probably have lots of questions (including beginners), is
there someone I can ask directly, or should I send them to the -devel list ?

Thanks,
Pierre


[1] http://www.spinics.net/lists/netfilter-devel/msg15730.html
