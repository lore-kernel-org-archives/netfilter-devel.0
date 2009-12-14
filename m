From: Tobias Koeck <tobias.koeck@gmail.com>
Subject: Re: netfilter kernel modules question
Date: Mon, 14 Dec 2009 21:48:23 +0100
Message-ID: <4B26A497.8000900@gmail.com>
References: <4B2657B7.5070405@gmail.com> <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr> <4B269FD2.4020807@gmail.com> <alpine.LSU.2.01.0912142130020.14802@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:50440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZLNUs3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:48:29 -0500
Received: by fg-out-1718.google.com with SMTP id e21so133136fga.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2009 12:48:28 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.0912142130020.14802@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 >
 > You can argue what a data structure is or what it is not; a header
 > file should not include any definitions, only declarations. (And
 > perhaps static-inlines, but that's probably too expert for you at
 > this stage.) Various C-related forums or IRC channels can enlighten
 > you towards the reasoning for that.

'int a' is declaration (only used in a function it's a definition).

Does that mean if I define a (nonstatic) variable in a kernel module 
and it's accessible in the whole kernel?

Don't worry - last kernel newbie question from myself ;=).

Greetings
tk
