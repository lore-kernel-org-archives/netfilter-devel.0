From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: /proc and/or /sys file to know if ip_tables is there?
Date: Thu, 28 Nov 2013 12:27:08 +0200
Message-ID: <52971A7C.7000505@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab3K1K1L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:27:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I need to know reliably at runtime whether or not ip_tables is either 
currently loaded as a module or built-in the kernel.

Testing for /sys/module/ip_tables solves the first issue, but in case of 
built-in it's not usable.

I could check for ip_tables_* symbols in /proc/kallsyms but I guess it's 
not a nice way.

Any other proper way?

Tomasz
