From: Eric Leblond <eric@inl.fr>
Subject: Re: Does policy routing based on owner-gid really work?
Date: Thu, 4 Sep 2008 08:59:04 +0200
Message-ID: <20080904065903.GA3361@khasse.inl.fr>
References: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com> <48BBEAC3.8040801@trash.net> <abe9c56e0809021144g12be20fcue4c6c336dc47eea8@mail.gmail.com> <20080903142225.GA28695@khasse.inl.fr> <abe9c56e0809031552o11f1bb8ctccc5aac5bbc9d6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: jon hale <jon.h.hale@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:33494 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYIDG7M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:59:12 -0400
Content-Disposition: inline
In-Reply-To: <abe9c56e0809031552o11f1bb8ctccc5aac5bbc9d6e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wednesday, 2008 September  3 at 15:52:37 -0700, jon hale wrote:
> Hi,
> Well I tried adding the CONNMARK line that you suggest.
> I then try a simple ftp from here to there of a 2 byte file.
> 
> I run tcpdumps on both the ppp0 and eth0 interfaces catching all of
> the packets that are going out to "there".
> 
> What I see is that when my machine (here) is responding to the Fin
> packet sent by the server that this goes out eth0. When I thought that
> I had configured it otherwise.
> All other packets until that point seem happy to go out ppp0.
> 
> Any ideas on why this packet would go out the "wrong" interface?
> Suggestions on how I may continue to debug this?

You may try to log every packet marked 0x1 in INPUT and OUTPUT filter
chain to see it the mark is correclty propagated through the connection.
By doing this, you will be able to check if your conditionnal routing
can occur correctly.

Just to be sure: Is nf_conntrack_ftp loaded ? It is necessary to have
RELATED connection detected.

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
