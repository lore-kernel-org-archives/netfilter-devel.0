From: "Nir Tzachar" <nir.tzachar@gmail.com>
Subject: libipq thread safety
Date: Tue, 25 Sep 2007 15:56:19 +0200
Message-ID: <9b2db90b0709250656g304194b7va67d4a02eb23e26e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:44692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXIYN4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:56:21 -0400
Received: by ug-out-1314.google.com with SMTP id z38so942549ugc
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Sep 2007 06:56:20 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello.

I am writing an application which uses the QUEUE target and am using
the libipq library.

I have a question regarding the thread safety of the library: is it
possible to do an ipq_read from one thread and an ipq_set_verdict from another?
Searching the archive of both netfilter and netfilter-devel yields no
definite answers...

Thanks for your help.
