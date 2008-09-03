From: Eric Leblond <eric@inl.fr>
Subject: Re: Does policy routing based on owner-gid really work?
Date: Wed, 3 Sep 2008 16:22:25 +0200
Message-ID: <20080903142225.GA28695@khasse.inl.fr>
References: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com> <48BBEAC3.8040801@trash.net> <abe9c56e0809021144g12be20fcue4c6c336dc47eea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: jon hale <jon.h.hale@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:49473 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYICOXk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:23:40 -0400
Content-Disposition: inline
In-Reply-To: <abe9c56e0809021144g12be20fcue4c6c336dc47eea8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tuesday, 2008 September  2 at 11:44:18 -0700, jon hale wrote:
> On Mon, Sep 1, 2008 at 6:14 AM, Patrick McHardy <kaber@trash.net> wrote:
> > jon hale wrote:
> >>
> >> I have a problem when I combine owner-gid, fwmark, and iproute2.
> >> I am starting to wonder if I can really get there from here.
> >>
> >> Synopsis:
> >>       I have been trying to set up policy routing based upon the group id
> >>       of the process sending the packets.
> >>
> >>       It works for most packets, but there is some scenario that happens
> >> at
> >>       the end of every ftp upload, where the packet goes out the wrong
> >>       interface and gums up the works.
> >
> > The stack may send packets that don't belong to the original socket.
> > You need to use CONNMARK to make sure all packets of a connection
> > are marked similar.
> >
> Hmm, I thought I was using CONNMARK
> I do have the iptables command:
>       iptables -t mangle -A OUTPUT -j CONNMARK --save-mark
> 
> Is there something else I need as well?

maybe:
iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark 

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
