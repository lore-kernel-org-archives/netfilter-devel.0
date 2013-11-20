From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Wed, 20 Nov 2013 15:14:12 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311201510170.17186@nerf07.vanv.qr>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de> <1382280491-9921-4-git-send-email-jengelh@inai.de> <20131119202815.GC4929@localhost> <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr> <20131120140605.GB7599@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44972 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab3KTOOP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:14:15 -0500
In-Reply-To: <20131120140605.GB7599@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2013-11-20 15:06, Pablo Neira Ayuso wrote:
>On Wed, Nov 20, 2013 at 11:54:21AM +0100, Jan Engelhardt wrote:
>> On Tuesday 2013-11-19 21:28, Pablo Neira Ayuso wrote:
>> 
>> >On Sun, Oct 20, 2013 at 04:48:11PM +0200, Jan Engelhardt wrote:
>> >> This now also honors the cflags as obtained from pkgconfig, otherwise
>> >> one gets a compile error if the headers are in a location other than
>> >> /usr/include.
>> >
>> >I don't want to consider changing the build system at this stage.
>> 
>> At this stage, the build is rather broken, for cases that are not
>> even far-fetched.
>
>Then fix what we already have.
>
>If you convince me in that it is way too complex to make it, then
>I'll consider this move to automake.

Was the diffstat not convincing enough that the automake way (which
fixes many of the reported issues) is preferable to the manual way
(which is yet unfixed and would need more lines)?

 16 files changed, 87 insertions(+), 482 deletions(-)
