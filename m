From: Justin Kamerman <justin@kaleco.net>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 10:57:51 -0300
Message-ID: <4C7BB8DF.7040208@kaleco.net>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
Reply-To: justin@kaleco.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47105 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0H3N7J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:59:09 -0400
Received: by qyk33 with SMTP id 33so5157122qyk.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 06:59:08 -0700 (PDT)
In-Reply-To: <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicola,
iptables is complaining because it can't locate the userspace companion
to your netfilter module. The userspace companion tells iptables which
kernel module to load and parses command line options before they are
passed to the kernel module. The module_install target takes care of the
kernel module but you also need a userspace helper installed to 
/lib/xtables. If building standalone (as opposed to using the
Xtables-addons framework) you could use a maekfile rule like:

libs_install:
        cp -f libxt_ipaddr.so /lib/xtables

Regards,
Justin Kamerman

On 10-08-30 10:25 AM, Nicola Padovano wrote:
> -s 127.0.0.1 -p icmp -j DROP
> > but i don't know how create this new target...
> > I've modified the netfilter makefile e Kbuild file (in net/netfilter)
