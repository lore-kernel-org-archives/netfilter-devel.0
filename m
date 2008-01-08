From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Tue, 8 Jan 2008 17:38:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801081738010.3032@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr>
 <4783A5CD.4050705@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55098 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366AbYAHQi7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:38:59 -0500
In-Reply-To: <4783A5CD.4050705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 17:33, Patrick McHardy wrote:
>
> I removed xt_state, xt_length, xt_helper since I didn't apply those
> patches yet and applied the patch.

xt_state has been marked obsolete by "[NETFILTER]: xt_conntrack
match, revision 1", that's what this entry refers to. (Please leave
it in.)

> Since I've lost the overview of your kernel patches I'm going to
> stop at the ones I have now. Please resend everything relevant
> once I've pushed my tree to Dave. Thanks.
>
> I'll look into the userspace patches soon.
>
