From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xtables-1.5.2 not working
Date: Wed, 5 Mar 2008 15:32:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803051521080.7660@fbirervta.pbzchgretzou.qr>
References: <47CE69D9.7090308@yahoo.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Filippo Zangheri <filippo.zangheri@yahoo.it>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37484 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYCEOcl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:32:41 -0500
In-Reply-To: <47CE69D9.7090308@yahoo.it>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 5 2008 10:37, Filippo Zangheri wrote:
>
>Now, all attempts to set an iptables rule fail with either
>segmentation fault:
>
>filippo@master:~/repos/xtables-dev$ sudo /usr/sbin/iptables -A INPUT -=
i lo -j ACCEPT
>Segmentation fault
>filippo@master:~/repos/xtables-dev$ dmesg
>iptables[19575]: segfault at 00000000 eip 0804d1b0 esp bfa585b0 error =
6

Thanks for the report!
I fixed this in 3474f7db.. (master); find_match was incorrectly called
when we tried to load libxt_standard (a target actually).


>iptables-restore v1.5.2: Couldn't load target
>`standard':/usr/libexec/xtables/libipt_standard.so: cannot open
>shared object file: No such file or directory
>
>Well, that's normal - there's no such library - so after issuing:

Internally it tries libxt_<foo> beforehand. Only if that does not
exist, it will skip to libipt_<foo> and then report an error.
But *if* libxt_<foo> exists, it will print the appropriate dlopen
error message=C2=A0=E2=80=94 it just did not happen in this case becaus=
e the
dlopen succeeded while the line after it did not.
So this message was a result of the previous wronglet.


thanks,
Jan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
