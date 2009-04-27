From: Leonardo Rodrigues <leolistas@solutti.com.br>
Subject: Re: problem with xtables-addons and CentOS 5.3
Date: Mon, 27 Apr 2009 07:38:35 -0300
Message-ID: <49F58B2B.4030609@solutti.com.br>
References: <49F49944.3010800@solutti.com.br> <alpine.LSU.2.00.0904271110320.6706@fbirervta.pbzchgretzou.qr> <49F582F4.5080604@solutti.com.br> <alpine.LSU.2.00.0904271224480.6706@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ML netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:45135 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZD0Kil convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:38:41 -0400
Received: by gxk10 with SMTP id 10so4581801gxk.13
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2009 03:38:40 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0904271224480.6706@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt escreveu:
>
>>   hmmmm that's bad ..... is there any workaround, or it's simply uns=
upported ?
>>   is it the shipped iptables that has problem ? is it some shipped l=
ib that
>> has problems ?
>>    =20
>
> It is the RHEL/Centos kernel that's riddled with problematic backport=
s=20
> as usual.
>  =20

    so getting a fresh kernel source (from www.kernel.org) and get it=20
running should workaround the problem ?

    i'll just try that .....  thanks for the hint.

--=20


	Atenciosamente / Sincerily,
	Leonardo Rodrigues
	Solutti Tecnologia
	http://www.solutti.com.br

	Minha armadilha de SPAM, N=C3O mandem email
	gertrudes@solutti.com.br
	My SPAMTRAP, do not email it




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
