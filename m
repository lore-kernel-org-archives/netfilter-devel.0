From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: option "--state" cannot be inverted
Date: Sun, 12 Jun 2011 19:36:08 +0200
Message-ID: <it2te9$o7a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57908 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1FLRgY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:36:24 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1QVoaD-0001g5-EH
	for netfilter-devel@vger.kernel.org; Sun, 12 Jun 2011 19:36:21 +0200
Received: from h75021.upc-h.chello.nl ([62.194.75.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jun 2011 19:36:21 +0200
Received: from sfzhi by h75021.upc-h.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jun 2011 19:36:21 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

If I try to use

-m state ! --state NEW

as a part of the iptables command line I get this error message:

iptables v1.4.11.1: state: option "--state" cannot be inverted.

It worked fine with iptables 1.4.10. I'm wondering if this an intended change
or one more in the series of similar bugs introduced in 1.4.11?

--
Sergei.

