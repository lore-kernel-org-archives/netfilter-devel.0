From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 16:34:27 +0300
Message-ID: <1283175267.3085.21.camel@chilepepper>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	 <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: ext Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17918 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0H3Neh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:34:37 -0400
In-Reply-To: <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-30 at 15:25 +0200, ext Nicola Padovano wrote:
> i make an error the iptables line is:
>  iptables -A INPUT -s 127.0.0.1 -p icmp -j TAR
> 
> On Mon, Aug 30, 2010 at 3:22 PM, Nicola Padovano
> <nicola.padovano@gmail.com> wrote:
> > Hi all!
> > I've write the following  (and dummy) module that drops all packet...
> > but...now? after i write the module i can use it?
> > for example: i want digit:
> > iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
> > but i don't know how create this new target...
> > I've modified the netfilter makefile e Kbuild file (in net/netfilter),
> > and then i've do 'make' 'make modules' 'make modules_install' but
> > after i digit iptables i have this message
> >
> > "iptables v1.4.2: Couldn't load target `TAR':/lib/xtables/libipt_TAR.
> > so: cannot open shared object file: No such file or directory"
> >
> > what's my problem?

You need to add support for your new target in the iptables userspace
tool as well.  Check the source code here:

https://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=summary

You need to add a new extension file called extensions/libipt_TAR.c, the
rest should take care of itself ;)

-- 
Cheers,
Luca.

