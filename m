From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: iptables-nftables: Invalid argument
Date: Fri, 31 May 2013 09:52:33 +0200
Message-ID: <CAOkSjBi3ogMOU=gT2gij8gU30_Ptqz_JfFQgv564YGMsKqaiVQ@mail.gmail.com>
References: <CAFpD06Qpkm2sXQc0UAN1JfBeHX0sP9TH9mgca4q_d2y5pSQSxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:55271 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3EaHwz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 May 2013 03:52:55 -0400
Received: by mail-la0-f46.google.com with SMTP id er20so1071650lab.5
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2013 00:52:53 -0700 (PDT)
In-Reply-To: <CAFpD06Qpkm2sXQc0UAN1JfBeHX0sP9TH9mgca4q_d2y5pSQSxA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/5/30 Giuseppe Longo <giuseppelng@gmail.com>:
> Hello,
> I've compiled iptables-nftables on debian 7 vm, with kernel 3.2.0

Hi there,

try using a newer kernel.
I would suggest to compile and run 'nf-next' or 'nftables' from here:
http://1984.lsi.us.es/git/

Regards.
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
