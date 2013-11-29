From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: /proc and/or /sys file to know if ip_tables is there?
Date: Fri, 29 Nov 2013 08:01:48 +0200
Message-ID: <52982DCC.5060105@linux.intel.com>
References: <52971A7C.7000505@linux.intel.com> <20131128161053.GA21908@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3K2GBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 01:01:53 -0500
In-Reply-To: <20131128161053.GA21908@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

> Although built in components will show up in/sys/module/  also.

I was expecting something like that, but making as built-in only 
ip_tables module did not.
I guess I need to add other stuff too.

Thanks,

Tomasz


