From: Ignacy Gawedzki <i@lri.fr>
Subject: Netfilter API and libiptc
Date: Thu, 5 Feb 2009 15:17:22 +0100
Message-ID: <20090205141722.GB21417@qubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:50463 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZBEOdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:33:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by ext.lri.fr (Postfix) with ESMTP id E039BA4466
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2009 15:13:59 +0100 (CET)
Received: from ext.lri.fr ([127.0.0.1])
	by localhost (ext.lri.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Elx31HBHYPdy for <netfilter-devel@vger.kernel.org>;
	Thu,  5 Feb 2009 15:13:59 +0100 (CET)
Received: from smtp.lri.fr (vhost3-23 [129.175.3.23])
	by ext.lri.fr (Postfix) with ESMTP id C9A0AA438A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2009 15:13:59 +0100 (CET)
Received: from qubit.lri.fr (qubit [129.175.11.180])
	by smtp.lri.fr (Postfix) with ESMTP id C3A4AE056D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2009 15:13:59 +0100 (CET)
Received: from ig by qubit.lri.fr with local (Exim 4.69)
	(envelope-from <i@lri.fr>)
	id 1LV52g-0005f5-3j
	for netfilter-devel@vger.kernel.org; Thu, 05 Feb 2009 15:17:22 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everybody,

I'm currently working on a project that relies on manipulation of iptables in
order to perform fine data packet accounting.  This manipulation is performed
dynamically, so the code initially used libiptc.

Since iptables 1.4.0, libiptc is not distributed anymore, so I resolved to
incorporate the code into our own source distribution, just as people from
collectd seemingly did.  All seemed to work well until yesterday, when we
eventually pinpointed our calls to the (internal) libiptc as a cause of a
kernel freeze.  It only happened on a generic Ubuntu Hardy kernel
(2.6.24-22-generic) on one particular laptop (I didn't succeed in reproducing
the freeze on another hardware with the same distribution).  I suppose it has
something to do with the change of the format of data flowing to kernelspace
(iptables 1.3.8 came distributed on that freezing machine), could anyone here
confirm that this is possible indeed?

Now my question is: how are we supposed to proceed from now on in order to
manipulate iptables?  I read about libxtables and the corresponding libxtc.h
(though these are not yet packaged in the current Ubuntu Intrepid), but it's
not clear to me how the communication with the kernel is actually to be done.

Thanks for any information that could help me making this work properly.

Ignacy

-- 
P.S.  All information contained in the above letter is false,
      for reasons of military security.
