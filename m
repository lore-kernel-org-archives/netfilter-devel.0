From: julioarr@fisica.uh.cu
Subject: [Fwd: how to filter with layer7??]
Date: Tue, 11 Oct 2011 13:26:32 -0400
Message-ID: <7695350de0ed0af3448e11288b3cd653.squirrel@mail.fisica.uh.cu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.uh.cu ([200.14.51.4]:53540 "EHLO smtp.uh.cu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab1JKR1L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:27:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>hi all,
>
>I rebuild my kernel with layer7-support. All is working ok. But, I need
>filter the TCP-SSL/TLS-forward-connections packets from a client to the
>server ($SERVER_IP:443) by layer7 protocols. How I can do this?
>

just to redirect some forward-packets that match some layer7 condition to
other destination

>
>thanks,
>julio
>

