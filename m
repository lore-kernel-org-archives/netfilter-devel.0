From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Sat, 21 Aug 2010 11:23:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008211120120.23263@obet.zrqbmnf.qr>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Aijaz Baig <aijazbaig1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52063 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0HUJXi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:23:38 -0400
In-Reply-To: <1282373834.4080.79.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-08-21 08:57, Aijaz Baig wrote:

>So why is it that when my netfilter module is exporting something to the
>kernel and im tryin to use it from within a core kernel file, the
>compiler flags a 'undefined reference to' error?

There, you answered yourself. Exports only go one way. And that is
core -> module -> module.

