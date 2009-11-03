From: Patrick McHardy <kaber@trash.net>
Subject: Re: Xtables cleanup patches
Date: Tue, 03 Nov 2009 19:27:31 +0100
Message-ID: <4AF07613.6030701@trash.net>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50619 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKCS1e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:27:34 -0500
In-Reply-To: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I am posting here already the next round of pullable patches
> (that I originally wanted to get in _much_ faster) for review.

Well, you could speed things up by benchmarking your patches yourself
when concerns about adding overhead is raised. Otherwise you'll just
have to wait until someone else gets to do it.

> This block is mostly cleanups, simplifications. It might be worth
> testing these together with the previous set if there are concerns
> about speed.
