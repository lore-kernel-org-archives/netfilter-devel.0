From: giorgio.nicole@arcor.de
Subject: Aw: Re: [PATCH 6/7] autotools conversion: commit the rest of the
 configure.ac changes.
Date: Mon, 7 Jul 2014 16:13:28 +0200 (CEST)
Message-ID: <2005804746.1283594.1404742408487.JavaMail.ngmail@webmail12.arcor-online.net>
References: <alpine.LSU.2.11.1407071513100.20461@nerf08.vanv.qr> <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de> <1404728169-7899-7-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@inai.de, giorgio.nicole@arcor.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:54460 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbaGGON3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:13:29 -0400
In-Reply-To: <alpine.LSU.2.11.1407071513100.20461@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 


----- Original Nachricht ----
Von:     Jan Engelhardt <jengelh@inai.de>
An:      Giorgio Dal Molin <giorgio.nicole@arcor.de>
Datum:   07.07.2014 15:14
Betreff: Re: [PATCH 6/7] autotools conversion: commit the rest of the
 configure.ac changes.

> 
> On Monday 2014-07-07 12:16, Giorgio Dal Molin wrote:
> >+
> >+AS_CASE([$enable_debug],
> >+	[yes],[
> >+	AC_DEFINE([DEBUG],1,[Debug enabled])
> >+	DEBUG_CPPFLAGS="-g -DDEBUG"
> >+	])
> >+
> >+AC_SUBST(DEBUG_CPPFLAGS)
> 
> -g should not be in DEBUG_CPPFLAGS (but DEBUG_CFLAGS)
> because it's strictly speaking not a preprocessor flag.

OK, I changed it; I define/subst now two variable: DEBUG_CFLAGS='-g' and DEBUG_CPPFLAGS='-DDEBUG'.

giorgio
