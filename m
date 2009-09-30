From: Saikiran Madugula <hummerbliss@gmail.com>
Subject: Re: How to add data to connection tracker
Date: Wed, 30 Sep 2009 11:34:45 +0100
Message-ID: <4AC33445.5060700@gmail.com>
References: <845389504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nils Rennebarth <Nils.Rennebarth@web.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:30204 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZI3Keo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:34:44 -0400
Received: by fg-out-1718.google.com with SMTP id 22so2054959fge.1
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2009 03:34:47 -0700 (PDT)
In-Reply-To: <845389504@web.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nils Rennebarth wrote:
> Hi,
> 
>
> I need to store some additional data to a connection in the connection tracker. Although infrastructure to do that
> appears to be in place, I could not find an obvious way to do that. I *did* read the kernel source and already know
> how to write and register a new netfilter extension.
> 

You can utilize netfilter conntrack's extension infrastructure. Look at
nf_conntrack_acct.c to how its done. I am pretty sure you would receive better
solutions from the list.
