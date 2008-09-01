From: Patrick McHardy <kaber@trash.net>
Subject: Re: Does policy routing based on owner-gid really work?
Date: Mon, 01 Sep 2008 15:14:43 +0200
Message-ID: <48BBEAC3.8040801@trash.net>
References: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jon hale <jon.h.hale@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34850 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIANOp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:14:45 -0400
In-Reply-To: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jon hale wrote:
> I have a problem when I combine owner-gid, fwmark, and iproute2.
> I am starting to wonder if I can really get there from here.
> 
> Synopsis:
>        I have been trying to set up policy routing based upon the group id
>        of the process sending the packets.
> 
>        It works for most packets, but there is some scenario that happens at
>        the end of every ftp upload, where the packet goes out the wrong
>        interface and gums up the works.

The stack may send packets that don't belong to the original socket.
You need to use CONNMARK to make sure all packets of a connection
are marked similar.
