From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: xt_TEE: have cloned packet travel through
 Xtables too
Date: Mon, 19 Apr 2010 16:07:31 +0200
Message-ID: <4BCC63A3.2000309@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57662 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0DSOHd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:07:33 -0400
In-Reply-To: <1271373909-6959-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Since Xtables is now reentrant/nestable, the cloned packet can also go
> through Xtables and be subject to rules itself.

Applied, thanks Jan.
