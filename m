From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Suggestion: "--match recent --set --life-span <secs>"  to prevent
 table filling up
Date: Tue, 10 Mar 2009 17:13:27 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903101712400.19523@fbirervta.pbzchgretzou.qr>
References: <49B59CC7.7080002@bluebottle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Hanson <chanson@bluebottle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59556 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbZCJQN3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:13:29 -0400
In-Reply-To: <49B59CC7.7080002@bluebottle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-09 23:48, Chris Hanson wrote:
>
> A suggestion for the match recent part of netfilter. Include a
> life_span field in the table. A host is removed from a table after
> it hasn't been seen for x seconds.

How does this differ from simply ignoring hosts recorded in the list
whose last_seen time is greater than x -- apart from potential
memory savings?
