From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] libxtables: prefix exit_error to xtables_error
Date: Mon, 23 Feb 2009 17:56:18 +0100
Message-ID: <49A2D532.2050506@trash.net>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de> <1235186284-31661-4-git-send-email-jengelh@medozas.de> <49A2D2D6.8070606@trash.net> <alpine.LSU.2.00.0902231751550.12150@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39416 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZBWQ4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:56:21 -0500
In-Reply-To: <alpine.LSU.2.00.0902231751550.12150@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-23 17:46, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>>> diff --git a/extensions/expr b/extensions/expr
>>> new file mode 100644
>>> index 0000000..f00b70d
>>> --- /dev/null
>>> +++ b/extensions/expr
>>> @@ -0,0 +1,179 @@
>>> +#include <stdio.h>
>>> +#include <stdint.h>
>>> +#include <libHX/option.h>
>>> +
>>> +enum ttl_rel {
>>> +	REL_EQ,
>>> +	REL_LT,
>>> +	REL_GT,
>>> +}
>> What is this file? I see no mentioning in the (non-existant) changelog.
>>
> Accidentally git-added code. It is removed in the latest tree's form.
> There should not need to be any detailed changelog entry - it
> really is just the prefixing that is needed for a good library
> that was done.
> 

This look a lot better:

  94 files changed, 778 insertions(+), 788 deletions(-)

:)

Pulled and pushed out again, thanks. Now lets slow things down until
the next release please.
