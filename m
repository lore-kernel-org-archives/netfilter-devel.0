From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] fixed the position of the exclamation mark
Date: Wed, 28 May 2008 18:42:36 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805281841380.16560@fbirervta.pbzchgretzou.qr>
References: <20080528150425.20290.58521.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59839 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYE1Qmi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 12:42:38 -0400
In-Reply-To: <20080528150425.20290.58521.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-05-28 17:04, Max Kellermann wrote:

>iptables-save misplaces the exclamation mark (negation): it puts the
>the exclamation mark before the option name, although the option is
>documented as requiring the negation specifier before the arguments.

No no, the documentation is incorrect here.
I have a patch, though I need to refresh it first. Give me a few minutes :)
