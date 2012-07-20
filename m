From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: What happened to NIPQUAD and friends?
Date: Fri, 20 Jul 2012 14:23:53 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207201422120.4231@frira.zrqbmnf.qr>
References: <1342784295.15462.3.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:37602 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab2GTMXy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:23:54 -0400
In-Reply-To: <1342784295.15462.3.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-07-20 13:38, Arif Hossain wrote:

>Hi,
>
>NIPQUAD has nothing in 3.4 kernel. What happened to it?

NIPQUAD never had any possessions.


>Any alternative?

const struct in_addr *foo;
printf("%pI4\n", foo);
