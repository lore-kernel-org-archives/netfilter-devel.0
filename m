From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH 02/34] [Resend] Do not propagate one conntrack event via
 2 messages
Date: Sun, 03 Feb 2008 10:27:07 +0100
Message-ID: <877ihmmluc.fsf@kruemel.eitzenberger.org>
References: <1201987469575-git-send-email-eric@inl.fr>
	<1201987469368-git-send-email-eric@inl.fr>
	<12019874692227-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058AbYBCJ1K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:27:10 -0500
In-Reply-To: <12019874692227-git-send-email-eric@inl.fr> (Eric Leblond's
 message of "Sat,  2 Feb 2008 22:23:57 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@inl.fr> writes:

> Ulogd2 was propagating through a stack 2 message for one single conntrack event.
> This patch provides a fall back to on message per event. It also uses an enum to improve
> code readability instead of direct access to array via numerical index.

Hi Eric,

this one would clash with the changes I did.  I'll check what you do
did there.  In the meantime can you please check

 [ULOGD 15/15] NFCT: rework and let it scale

from my last patchset?  I'll happily change that code to keep the
output key compatibility.

Thanks.

 /holger
