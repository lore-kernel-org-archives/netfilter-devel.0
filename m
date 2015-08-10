From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [IPTABLES] Module ipt_same
Date: Mon, 10 Aug 2015 11:55:25 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508101151430.27258@nerf40.vanv.qr>
References: <BLU436-SMTP2146D2AF1763E1C081B991E9A8A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alex william <alex.william21@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35061 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496AbbHJJz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 05:55:26 -0400
In-Reply-To: <BLU436-SMTP2146D2AF1763E1C081B991E9A8A0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2015-07-31 07:24, Alex william wrote:

>Hello,
>
>My objective is if ip A.A.A.A goes to B.B.B.B it is natted with IP X.X.X.X
>then if A.A.A.A re-establishes a session with B.B.B.B it is natted with
>the same IP X.X.X.X. According to my reseach the module ipt_same does
>that: 

Word on the street is that regular SNAT already does that, which is why 
SAME is gone.
