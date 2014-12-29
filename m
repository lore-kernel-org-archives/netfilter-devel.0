From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH libnftnl] Add Libs.private field to libnftnl.pc
Date: Mon, 29 Dec 2014 16:29:58 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1412291628370.1534@nerf08.vanv.qr>
References: <1419864034-19450-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:55805 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaL2PaB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:30:01 -0500
In-Reply-To: <1419864034-19450-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2014-12-29 15:40, Thomas Petazzoni wrote:

>The Libs.private field is specifically designed for such usage:

It's not - 
http://thread.gmane.org/gmane.linux.utilities.util-linux-ng/953

>Therefore, this patch adds a reference to libmnl in the Libs.private
>field of libnftnl pkg-config file.

It should probably use Requires.private.
