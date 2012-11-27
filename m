From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] build: move remaining preprocessor flags into
 CPPFLAGS
Date: Tue, 27 Nov 2012 14:09:57 +0100
Message-ID: <1354021797.4103.13.camel@tiger2>
References: <1354020546-4799-1-git-send-email-jengelh@inai.de>
	 <1354020546-4799-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37819 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2K0NKa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:10:30 -0500
In-Reply-To: <1354020546-4799-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2012-11-27 at 13:49 +0100, Jan Engelhardt wrote:
> The flags retrieved from `pkg-config --cflags ...` are generally only
> preprocessor flags (mostly -I to point to the directories), since
> anything else would inconvenience downstream users.
> 
...
> -AM_CPPFLAGS = -I$(top_srcdir)/include
> -AM_CFLAGS = ${regular_CFLAGS} ${libsqlite3_CFLAGS}
> +AM_CPPFLAGS = -I$(top_srcdir)/include ${libsqlite3_CFLAGS}
> +AM_CFLAGS = ${regular_CFLAGS}
>  
>  if HAVE_SQLITE3
 
All four patches have been applied. Thanks a lot Jan.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

