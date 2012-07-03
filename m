From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] Include <net/ip6_checksum.h> for csum_ipv6_magic
Date: Tue, 3 Jul 2012 22:54:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207032254200.26577@frira.zrqbmnf.qr>
References: <20120703183345.GA14043@kevinzilla>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Locke <kevin@kevinlocke.name>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:48385 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2GCUya (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:54:30 -0400
In-Reply-To: <20120703183345.GA14043@kevinzilla>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-07-03 20:33, Kevin Locke wrote:

>xt_ECHO fails to build on PPC because csum_ipv6_magic is declared in
><net/ip6_checksum.h>, which is not implicitly included from other
>headers on PPC causing build failures due to this function being
>undefined.  So, include this header explicitly.

Fixed.
