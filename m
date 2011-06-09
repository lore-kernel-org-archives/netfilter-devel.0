From: Adam Sampson <ats@offog.org>
Subject: netfilter release signing keys
Date: Thu, 9 Jun 2011 09:30:00 +0100
Message-ID: <20110609083000.GP3173@cartman.at.offog.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from malt.us-lot.org ([78.31.108.14]:38824 "EHLO malt.us-lot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1FIIsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:48:09 -0400
Received: from 94-194-126-16.zone8.bethere.co.uk ([94.194.126.16] helo=cartman.offog.org)
	by malt.us-lot.org with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <ats@offog.org>)
	id 1QUacL-00089Z-N4
	for netfilter-devel@vger.kernel.org; Thu, 09 Jun 2011 09:29:29 +0100
Received: from ats by cartman.offog.org with local (Exim 4.76)
	(envelope-from <ats@offog.org>)
	id 1QUacq-0004p1-HN
	for netfilter-devel@vger.kernel.org; Thu, 09 Jun 2011 09:30:00 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

(I sent this to webmaster@netfilter.org as suggested on
http://netfilter.org/about.html, but that address bounced.)

The latest iptables release is signed with key ID BB5F58CC:

http://www.netfilter.org/projects/iptables/files/iptables-1.4.11.tar.bz2.sig

The "key" link next to that on the iptables downloads page points to:

http://www.netfilter.org/files/coreteam-gpg-key.txt

However, that key is CA9A8D5B.

On the "About" page, it says that the current key is 2D0987E6 and gives
a revocation certificate for CA9A8D5B. It says that 2D0987E6 "will be
valid until March 27, 2011", so I guess that someone's generated a new
key and not updated the About page or download links yet. Please could
someone confirm that BB5F58CC is a legitimate key for iptables releases,
and update the web pages?

Thanks,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>
