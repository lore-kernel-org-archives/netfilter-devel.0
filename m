From: Sam Roberts <vieuxtech@gmail.com>
Subject: can expectations be marked persistent, so they can match repeatedly
 until they timeout?
Date: Thu, 24 Mar 2011 10:43:31 -0700
Message-ID: <AANLkTi=dEfb8f1moPE5Mp2yS5DqiB=abuJcFP99opXy9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52784 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab1CXRnc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:43:32 -0400
Received: by vws1 with SMTP id 1so192322vws.19
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2011 10:43:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm writing a userspace conntrack, using nfqueue and conntrack.

Creating expectations works fine, metfilter matches and allows the
expected connection.

However, unlike ftp, the negotiated ephemeral port is used by multiple
simultaneous tcp connections for some period. I'd like the expectation
to be kept in place until it times out, even when its matched.

I can create this effect by watching for the conntrack event
indicating the expectation was destroyed, and recreating it, but I'd
like to know if there is a better way.

Cheers,
Sam
