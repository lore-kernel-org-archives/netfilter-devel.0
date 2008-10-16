From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix ERROR target on CRIS
Date: Thu, 16 Oct 2008 14:07:23 +0200
Message-ID: <48F72E7B.7090001@trash.net>
References: <A612847CFE53224C91B23E3A5B48BAC73889D09813@xmail3.se.axis.com> <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com> <alpine.LNX.1.10.0810151544580.10924@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Bengtsson <jesper.bengtsson@axis.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYJPMH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:07:28 -0400
In-Reply-To: <alpine.LNX.1.10.0810151544580.10924@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>> struct ipt_error_target
>> {
>>  struct ipt_entry_target target;
>> - char errorname[IPT_FUNCTION_MAXNAMELEN];
>> + char errorname[IPT_TABLE_MAXNAMELEN];
> 
> Resolve the indirect macro - use XT_TABLE_MAXNAMELEN.

Thats also fine of course.

> Fix up IPv6 too?
> This looks not quite right to me though it is of course one way
> to achieve to goal.. How about this?:
> 
> 	char errorname[XT_ALIGN(XT_FUNCTION_MAXNAMELEN)]
> 
> is what I would suggest.

That misses the point, CRIS doesn't require any alignment and
FUNCTION_MAXNAMELEN is wrong here.
