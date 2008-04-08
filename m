From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: Use unsigned types for hooknum and pf
 vars
Date: Tue, 08 Apr 2008 17:10:51 +0200
Message-ID: <47FB8AFB.4050904@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <91d87468ffa4c7a133c1ec294dbbd99f6642dd29.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41973 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbYDHPK6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:10:58 -0400
In-Reply-To: <91d87468ffa4c7a133c1ec294dbbd99f6642dd29.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> and (try to) consistently use u_int16_t for the L3 family.

Let me think about this. I know I suggested to use u_int16_t,
but ypur last patch was only for conntrack, and thats what it
uses in the tuple (only to fill a hole). The protocol is
*actually* a u8, and thats also what all the others use or
should use.

Your other patches don't seem to depend on this one, so I'll
try to apply them without it.
