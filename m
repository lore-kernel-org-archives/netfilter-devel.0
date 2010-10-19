From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 06/10] build: rebuild .pc files when configure status changed
Date: Tue, 19 Oct 2010 21:41:51 +0000
Message-ID: <3bb88c0985f0036cdbcc2b6307f4c4ce@mail.treenet.co.nz>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de> <1287485262-6562-7-git-send-email-jengelh@medozas.de> <4CBD8B89.7030802@treenet.co.nz> <alpine.LNX.2.01.1010191528290.25338@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:51447
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0JSVl4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:41:56 -0400
In-Reply-To: <alpine.LNX.2.01.1010191528290.25338@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 19 Oct 2010 15:30:56 +0200 (CEST), Jan Engelhardt
<jengelh@medozas.de> wrote:
> On Tuesday 2010-10-19 14:14, Amos Jeffries wrote:
> 
>> On 19/10/10 23:47, Jan Engelhardt wrote:
>>> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
>>> ---
>>>  Makefile.am |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Makefile.am b/Makefile.am
>>> index 35bfbe2..6d5b8dd 100644
>>> --- a/Makefile.am
>>> +++ b/Makefile.am
>>> @@ -8,6 +8,8 @@ DIST_SUBDIRS = src include examples
>>>  pkgconfigdir = $(libdir)/pkgconfig
>>>  pkgconfig_DATA = libmnl.pc
>>>
>>> +${pkgconfig_DATA}: ${top_builddir}/config.status
>>> +
>>>  $(OBJECTS): libtool
>>>  libtool: $(LIBTOOL_DEPS)
>>>  	$(SHELL) ./config.status --recheck
>>
>> IIRC {} is a bashism. () is more portable for automake.
> 
> What are you talking about? ${...} is not a bash-only feature.
> The automake developers certainly did not complain about the use
> of {} when I submitted my patches.

Okay, they would know best. I'm probably recallling non-linux automakes.
Sorry for the noise.

AYJ
