From: alan furlong <alan250985@gmail.com>
Subject: Netfilter + TSO/GSO
Date: Sun, 1 Apr 2012 14:56:41 -0700
Message-ID: <CAAqR2YaeJxHfE4pMbSEntkPhoHk_0cBsDtN++chG4zcz305iwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2DAV4m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:56:42 -0400
Received: by iagz16 with SMTP id z16so3311509iag.19
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Apr 2012 14:56:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Are there any guidelines on how to implement netfilter hooks when TCP
or Generic Segmentation offloading is enabled and is supported by the
NIC? I'm trying to implement pre-routing netfilter hook that intends
to change the IP header and payload.

Thanks
- Alan F.
