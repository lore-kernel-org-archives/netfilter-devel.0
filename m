From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: Use unsigned types for hooknum and pf
 vars
Date: Wed, 09 Apr 2008 18:21:17 +0200
Message-ID: <47FCECFD.3050201@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <91d87468ffa4c7a133c1ec294dbbd99f6642dd29.1207664141.git.jengelh@computergmbh.de> <47FB8AFB.4050904@trash.net> <alpine.LNX.1.10.0804091817420.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYDIQVW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:21:22 -0400
In-Reply-To: <alpine.LNX.1.10.0804091817420.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-08 17:10, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> and (try to) consistently use u_int16_t for the L3 family.
>> Let me think about this. I know I suggested to use u_int16_t,
>> but ypur last patch was only for conntrack, and thats what it
>> uses in the tuple (only to fill a hole). The protocol is
>> *actually* a u8, and thats also what all the others use or
>> should use.
> 
> So your resolution is..- moving everything to uint8?
> 

None so far, I've been kept busy responding to emails.
