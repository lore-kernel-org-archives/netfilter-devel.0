From: Nadeem Douba <ndouba@gmail.com>
Subject: Re: FTP Packet Mangling & NAT
Date: Thu, 9 Jun 2011 15:06:45 -0400
Message-ID: <BANLkTim6WA1AW=ARNXKEx1kyVDo6TjCp-Q@mail.gmail.com>
References: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com>
	<81c0aab748c6ad27b289055e31777945@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:39521 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1FITGq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:06:46 -0400
Received: by pxi2 with SMTP id 2so1223862pxi.10
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 12:06:46 -0700 (PDT)
In-Reply-To: <81c0aab748c6ad27b289055e31777945@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>  The proxy completely controls what the client gets given. It is
>  breaking transparency by not reverse-mapping the response properly.
>  Mention it to the authors and get it fixed.

The authors (Websense) are of a different opinion of how this issue is
fixed. They recommended that we enable active FTP (significant
security risk).


>  A transparent proxy is equivalent to a NAT module in all respects.
>  Merely operates on the FTP layer in this case.
>  Switch "module" for "proxy" and you have a good plan for fixing the
>  bug.

Not really, even proxying these requests would result in the same
issue as the child proxy would relay the parent proxy's response.

>  NOTE: If you do steps 5 and 6 in the IP layer you will be bypassing the
>  proxy data handling and void all your reasons for having it done by a
>  proxy in the first place. Instead of by the conntrack NAT module for FTP
>  for both outgoing and returning traffic.

The point is not to get rid of the proxy but to fix the issue that the
proxy is presenting to all FTP communications.

>  Disclaimer: I'm not one of the NF gurus. Just a proxy guy.

Thanks anyways.
