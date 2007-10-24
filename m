From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: asking external app for true/false value prior to opening a new
 session
Date: Wed, 24 Oct 2007 15:23:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710241523370.17781@fbirervta.pbzchgretzou.qr>
References: <12445fff0710150527u5e368a3cr4c81b2a6e0d579b0@mail.gmail.com>
 <12445fff0710240554v47f2eac5q68dfa0df3af42c93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Greg <j.greg.k@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXJXNXv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:23:51 -0400
In-Reply-To: <12445fff0710240554v47f2eac5q68dfa0df3af42c93@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 24 2007 07:54, Greg wrote:
>
>Is there a way to create a rule that will ask an external application for a
>true or false value before allowing a new connection to be established?

I'd say -j NFQUEUE.
