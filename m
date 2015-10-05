From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v3] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Mon, 5 Oct 2015 20:46:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510052045420.11268@nerf40.vanv.qr>
References: <20151005173655.GA15088@oxygen>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40209 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbbJESqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 14:46:32 -0400
In-Reply-To: <20151005173655.GA15088@oxygen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-10-05 19:36, Neutron Soutmun wrote:
>  Drop the EXPORT_SYMBOL() tags also fix the failed to build with
>  clang.

>-CHECK_GCC_FVISIBILITY

We should be able to also drop the m4 code behind CHECK_GCC_FVISIBILITY
(I remember writing that, and so it's not something autoconf would
provide on its own.)
