From: Anton <anton.vazir@gmail.com>
Subject: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 10:53:40 +0500
Message-ID: <200805221053.41058.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:43338 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbYEVFxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 01:53:39 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

Just doing some testuing of NFQUEUE, and noticed that in the 
simple case, if I do the following (yes, there is 
no "nlif_catch", but anyway) - I'm experiencing a memory 
leak for every open - close cycle?
Anything I'm missing?

       struct nlif_handle *h;
        h = nlif_open();
        if (h != NULL) {
         nlif_query(h);
         nfq_get_indev_name(h,tb,agg.iname);
         nfq_get_outdev_name(h,tb,agg.oname);
         nlif_close(h);
        }
