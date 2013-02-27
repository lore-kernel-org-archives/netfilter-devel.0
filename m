From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Help on error message
Date: Wed, 27 Feb 2013 20:43:44 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302272040020.31630@nerf07.vanv.qr>
References: <512E49C8.30602@cats-muvva.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nicole <nicole@cats-muvva.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45618 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3B0Tnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:43:45 -0500
In-Reply-To: <512E49C8.30602@cats-muvva.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-02-27 19:00, Nicole wrote:

> Hi Guys,
>
> Call me lazy if you wish, but I thought I'd get a clear answer here.
> I have written a extension using xtables. It spits out the error message
> Extension xxxx uses invalid ID nn.
> What does this mean?

Usually hints towards the fact that your extension uses more than 256 
command-line options.

Our magic glass spheres are, unfortunately, under maintenance until 
further notice. You will have to post more details - such as full 
unabridged source code - before a satisfying assessment can be made as 
to where in your extension the problem lies.
