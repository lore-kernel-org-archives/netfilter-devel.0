From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [patch] iptables and NO_SHARED_LIBS/dlfcn.h
Date: Wed, 19 Dec 2007 13:18:38 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712191318100.12329@fbirervta.pbzchgretzou.qr>
References: <200712190715.46466.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44870 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbXLSMSk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:18:40 -0500
In-Reply-To: <200712190715.46466.vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 19 2007 07:15, Mike Frysinger wrote:
>
>if NO_SHARED_LIBS is defined, then iptables shouldnt even include
>dlfcn.h. otherwise you hit a build failure when using toolchains
>that do not provide dlfcn.h because they do not support shared
>objects.

Ideally such things would be done by autotools. Patch still floating :)
