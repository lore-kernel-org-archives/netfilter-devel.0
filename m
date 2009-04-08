From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re: Compiling ebtables statically or dynamically results in different
    	behaviour
Date: Wed, 08 Apr 2009 09:49:08 +0000
Message-ID: <W8403423488155181239184148@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Tim Verhoeven" <tim.verhoeven.be@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:43167 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbZDHJtg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:49:36 -0400
Received: from zoltar.telenet-ops.be (unknown [195.130.132.57])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 3B30F710089
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2009 11:49:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

What is your exact command and what type of processor are you using?

cheers,
Bart

>----- Oorspronkelijk bericht -----
>Van
: Tim Verhoeven [mailto:tim.verhoeven.be@gmail.com]
>Verzonden
: dinsdag
, april
 7, 2009 03:53 PM
>Aan
: netfilter-devel@vger.kernel.org
>Onderwerp
: Compiling ebtables statically or dynamically results in different 	behaviour
>
>Hi,
>
>I have a very strange problem with ebtables. I'm using it on CentOS 5
>(2.6.18 kernel) and when using the dynamically compiled version
>(version 2.0.8-2) I can't create a new chain. When using the same
>version but compiled statically it works. The difference is clearly to
>see when using a strace :
>
>Good behavior (statically compiled) :
>
>setsockopt(3, SOL_IP, 0x80 /* IP_??? */,
>"filter\0\0\0\352tv;\0\0\0\0\0\0\0\0\0\0\0008\2\0\0\0\0\0\0"..., 312)
>= 0
>exit_group(0)                           = ?
>
>
>Bad behavior (dynamically compiled) :
>
>setsockopt(3, SOL_IP, 0x80 /* IP_??? */,
>"filter\0\0\0\352tv;\0\0\0\0\0\0\0\0\0\0\0e\3\0\0\0\0\0\0"..., 312) =
>-1 EINVAL (Invalid argument)
>write(2, "The kernel doesn't support a cer"..., 113The kernel doesn't
>support a certain ebtables extension, consider recompiling your kernel
>or insmod the extension) = 113
>write(2, ".\n", 2.
>)                      = 2
>exit_group(-1)                          = ?
>
>For some reason the one version sets different options then the other.
>I've tried different things (compiling against the standard kernel
>include files (kernel-devel), compiling against the included include
>files, using some gcc options, ...). But none of those worked. Any
>hints are appreciated.



