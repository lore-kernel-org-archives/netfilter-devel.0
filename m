From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 08 Nov 2007 09:44:01 +0000
Message-ID: <4732DA61.5060900@ufomechanic.net>
References: <47322D4A.3090201@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34376 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172AbXKHJoS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:44:18 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Iq3vm-000126-KM
	for netfilter-devel@vger.kernel.org; Thu, 08 Nov 2007 09:44:10 +0000
Received: from 82.153.158.114 ([82.153.158.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Nov 2007 09:44:10 +0000
Received: from azez by 82.153.158.114 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Nov 2007 09:44:10 +0000
In-Reply-To: <47322D4A.3090201@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Peter Warasin wrote, On 07/11/07 21:25:
> Hi
> 
> The following patch renames the option --test (-t) to --dry-run (-d)
> in order to free the letter 't' for --table, which makes the options
> more consistent regarding the other *tables tools, where -t is always
> --table.


Get rid of -t if you have to, but I think it is good to keep --test as
well as --dry-run

Sam

