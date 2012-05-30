From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: filter IP protocol with ip6tables
Date: Wed, 30 May 2012 18:42:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205301842001.3598@frira.zrqbmnf.qr>
References: <4FC63DB2.8000503@umic.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bernd Kohler <kohler@umic.rwth-aachen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58400 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2E3Qmm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 May 2012 12:42:42 -0400
In-Reply-To: <4FC63DB2.8000503@umic.rwth-aachen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-05-30 17:33, Bernd Kohler wrote:

>Hi,
>
>I tried to filter IP packets with ip6tables (next hdr field)
>
>But as you can see in output [1] the kernel maps "0" to all and not to
>ip as listed in /etc/protocols.

IP, if you mean classic IP(v4), then that is value 4, not 0.
