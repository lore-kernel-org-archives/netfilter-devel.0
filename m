From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd PATCH 0/8] make progress ulogd_output_IPFIX
Date: Sun, 23 Mar 2014 19:50:20 +0100
Message-ID: <1395600620.23474.18.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39858 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaCWSu3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:50:29 -0400
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 2014-03-08 at 10:03 +0900, Ken-ichirou MATSUZAWA wrote:
>   Hello,
>  
> If there is someone who is working on ulogd_output_IPFIX, please let me
> know. I need it and would work on it.

Thanks lot for working on it.

> This patch series make progress, not work completely, just print IPFIX
> packet format. Would you review this? I think this has four issues.
>  
> * Install nfct_bitmask in libnetfilter_conntrack
>   This needs libnetfilter_conntrack patch I'll send after.

Not an issue because Florian did accept your patch.

> * Send only one dataset, not multiple at once
>   And it (will) send a message each time when output_ipfix() is called.
>   It's not efficient sending.

I don't think there is possibly issue with starting with that
implementation and then provide a better one later.

> * No options template and data
>   Do we need these scope data?
>   4. Specific Reporting Requiremt in RFC7011, says MAY be implemented

IPFIX is in ulogd wanted feature list since so long that this is not an
issue if we don't implement the extended feature. The only point is to
be able to interact cleanly with IPFIX collector in the market.
 
> * Template retransmit timing
>   It send template per messages specified in config file. 
>   I took a glance softflowd and follow that.

Good idea to mimic an existing software.

Some generic points regarding this patchset:
      * There is some whitespace errors please fix them when resending
      * I need the Signed-off-by line in your patch (for the same reason
        as in Linux
        https://www.kernel.org/doc/Documentation/SubmittingPatches)

More comments to come in reply to individual patches.

BR,
-- 
Eric Leblond <eric@regit.org>

