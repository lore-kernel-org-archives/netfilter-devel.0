From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] mnl_attr_get_str: document that the result is not
 NUL-terminated
Date: Tue, 14 Aug 2012 12:46:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208141245440.30509@frira.zrqbmnf.qr>
References: <502A2624.6050701@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:48198 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2HNKqy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:46:54 -0400
In-Reply-To: <502A2624.6050701@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-08-14 12:19, Florian Weimer wrote:

> Hi,
>
> while reviewing from libmnl-using code, I discovered that the result of
> mnl_attr_get_str was used as a NUL-terminated string, although in reality the
> string wasn't.  I think this should be mentioned in the documentation.

IIRC, mnl_attr_get_str should only be called for NLA_NUL_STRING attrs.
