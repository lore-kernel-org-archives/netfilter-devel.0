From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Tue, 08 Jan 2008 17:39:09 +0100
Message-ID: <4783A72D.4030504@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr> <4783A5CD.4050705@trash.net> <Pine.LNX.4.64.0801081738010.3032@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64294 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYAHQnJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:43:09 -0500
In-Reply-To: <Pine.LNX.4.64.0801081738010.3032@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 8 2008 17:33, Patrick McHardy wrote:
>> I removed xt_state, xt_length, xt_helper since I didn't apply those
>> patches yet and applied the patch.
> 
> xt_state has been marked obsolete by "[NETFILTER]: xt_conntrack
> match, revision 1", that's what this entry refers to. (Please leave
> it in.)

Well, I missed that and don't agree to that, so I've removed that
part of the patch now. The state match is significantly simpler,
uses a lot less memory and is used in almost every ruleset I've
ever seen. And it neither has any problems nor causes any maintenance
overhead.

