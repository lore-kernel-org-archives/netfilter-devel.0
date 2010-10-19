From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 06/10] build: rebuild .pc files when configure status
 changed
Date: Wed, 20 Oct 2010 01:14:01 +1300
Message-ID: <4CBD8B89.7030802@treenet.co.nz>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de> <1287485262-6562-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:54942
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab0JSMOH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:14:07 -0400
In-Reply-To: <1287485262-6562-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19/10/10 23:47, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
> ---
>   Makefile.am |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 35bfbe2..6d5b8dd 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -8,6 +8,8 @@ DIST_SUBDIRS = src include examples
>   pkgconfigdir = $(libdir)/pkgconfig
>   pkgconfig_DATA = libmnl.pc
>
> +${pkgconfig_DATA}: ${top_builddir}/config.status
> +
>   $(OBJECTS): libtool
>   libtool: $(LIBTOOL_DEPS)
>   	$(SHELL) ./config.status --recheck

IIRC {} is a bashism. () is more portable for automake.

AYJ
