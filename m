From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: iptables: build fixes
Date: Wed, 6 Mar 2013 06:13:19 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303060612480.28932@nerf07.vanv.qr>
References: <1357830919-10367-1-git-send-email-jengelh@inai.de> <20130112024915.GA22315@altlinux.org> <20130306000833.GA30360@altlinux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:59689 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab3CFFNV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:13:21 -0500
In-Reply-To: <20130306000833.GA30360@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-03-06 01:08, Dmitry V. Levin wrote:
>On Sat, Jan 12, 2013 at 06:49:15AM +0400, Dmitry V. Levin wrote:
>> On Thu, Jan 10, 2013 at 04:15:17PM +0100, Jan Engelhardt wrote:
>> [...]
>> > Jan Engelhardt (2):
>> >       build: also use libtool for install stage
>> >       build: do not dereference symlinks on installation
>> > 
>> >  extensions/GNUmakefile.in |   21 +++++++++++++++------
>> >  1 file changed, 15 insertions(+), 6 deletions(-)
>> 
>> Acked-by: Dmitry V. Levin <ldv@altlinux.org>
>
>Any idea why these fixed didn't get into 1.4.18?

http://www.spinics.net/lists/netfilter-devel/msg25045.html
and its reply ("Thread Next" link).
