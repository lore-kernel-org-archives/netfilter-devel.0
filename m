From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ULOGD2] UNIXSOCK plugin (v4)
Date: Thu, 14 Jan 2010 20:57:27 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001142056280.12046@obet.zrqbmnf.qr>
References: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48472 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab0ANT5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:57:30 -0500
In-Reply-To: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-01-14 20:41, Pierre Chifflier wrote:
>
>Here is an updated version of the UNIXSOCK plugin.
>
>Changes for v4:
>- use structures instead of reading integers directly
>- all structures and fields are now aligned (4 bytes)

Are there any 64-bit quantities or pointers in these structs?
If so, this may need 8 bytes.



Jan
