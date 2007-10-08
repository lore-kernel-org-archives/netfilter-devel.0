From: Patrick McHardy <kaber@trash.net>
Subject: Re: make print-extensions doesn't show libxt_* extensions
Date: Mon, 08 Oct 2007 07:08:52 +0200
Message-ID: <4709BB64.3000604@trash.net>
References: <1191588730.4456.14.camel@basti79.freenet-ag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sebastian Classen <sebastian.classen@freenet.ag>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51612 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXJHFLM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 01:11:12 -0400
In-Reply-To: <1191588730.4456.14.camel@basti79.freenet-ag.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sebastian Classen wrote:
> In extensions/Makefile the variable PFX_EXT_SLIB_OPTS is not appended to
> OPTIONALS, therefor 'make print-extensions' doesn't show any optional
> libxt_* extension.


Applied, thanks Sebastian.
