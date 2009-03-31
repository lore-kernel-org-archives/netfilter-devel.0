From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Checkentry called twice?
Date: Tue, 31 Mar 2009 14:28:28 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0903311428080.14162@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com> <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56376 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZCaM2b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:28:31 -0400
In-Reply-To: <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-31 14:03, Kristian Evensen wrote:

>After looking more into this, it seems that checkentry is called for
>every rule up to and including the one I added. For example, if give
>each a unique ID and outputs the id, then the first three -A give me:

checkentry is called for all rules, since whole tables are replaced 
every time you call iptables.
