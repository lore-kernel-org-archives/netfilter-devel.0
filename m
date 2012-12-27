From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [libnl-nft PATCH] Fix file descriptor leak on error
Date: Thu, 27 Dec 2012 10:49:11 +0100
Message-ID: <1418857.6RhmGgvzdE@storm>
References: <50D9B656.6040809@intra2net.com> <Pine.GSO.4.63.1212270723220.1519@stinky-local.trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:54487 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2L0JtN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:49:13 -0500
In-Reply-To: <Pine.GSO.4.63.1212270723220.1519@stinky-local.trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 27. December 2012 07:23:35 Patrick McHardy wrote:
> On Tue, 25 Dec 2012, Thomas Jarosch wrote:
> > Detected by cppcheck
> 
> Same question here.

I've submitted the patch to upstream. Thanks (also to Pablo).

Thomas

