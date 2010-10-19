From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/10] build: rebuild .pc files when configure status
 changed
Date: Tue, 19 Oct 2010 15:30:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010191528290.25338@obet.zrqbmnf.qr>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de> <1287485262-6562-7-git-send-email-jengelh@medozas.de> <4CBD8B89.7030802@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56976 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab0JSNa5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:30:57 -0400
In-Reply-To: <4CBD8B89.7030802@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-10-19 14:14, Amos Jeffries wrote:

> On 19/10/10 23:47, Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
>> ---
>>  Makefile.am |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 35bfbe2..6d5b8dd 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -8,6 +8,8 @@ DIST_SUBDIRS = src include examples
>>  pkgconfigdir = $(libdir)/pkgconfig
>>  pkgconfig_DATA = libmnl.pc
>>
>> +${pkgconfig_DATA}: ${top_builddir}/config.status
>> +
>>  $(OBJECTS): libtool
>>  libtool: $(LIBTOOL_DEPS)
>>  	$(SHELL) ./config.status --recheck
>
> IIRC {} is a bashism. () is more portable for automake.

What are you talking about? ${...} is not a bash-only feature.
The automake developers certainly did not complain about the use
of {} when I submitted my patches.
