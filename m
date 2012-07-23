From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - will there be a network latency?
Date: Sun, 22 Jul 2012 22:32:11 -0700
Message-ID: <CAAJpzgZm8sYBezOSZYUObtEOuJLdZD3NOZLV_NK-nhzmGm5-=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64601 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2GWFcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 01:32:32 -0400
Received: by obbuo13 with SMTP id uo13so8982669obb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jul 2012 22:32:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm trying to use ulogd in a system where the System has IPtables
based firewall. It acts as a router.
As per my understanding if I use ulogd, it will not cause any
networking delay in the system in routing the request.
Is it correct?  Or depending upon the usage of the system, ulogd may
cause networking delay.

Thanks & Regards,
