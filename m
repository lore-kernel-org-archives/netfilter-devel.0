From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_set_hash_netnet.c:62: possible typo ?
Date: Mon, 25 Nov 2013 12:58:19 -0800
Message-ID: <20131125205818.GA20219@home>
References: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>
 <alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Binderman <dcb314@hotmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64917 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3KYU6X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:23 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so6564674pbc.19
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2013 12:58:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 25, 2013 at 09:50:27PM +0100, Jozsef Kadlecsik wrote:
> Yes, you are completely right. I'm going to check why the testsuite did 
> not catch it.

FYI, seems this was already reported earlier this month:

    marc.info/?l=linux-netdev&m=138444371526170&w=2

Guess it got missed.

Phil
