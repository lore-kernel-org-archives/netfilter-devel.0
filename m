From: Bruno Fiss <bruno_fiss@yahoo.com.br>
Subject: Re: nf_unregister_hook problem
Date: Tue, 23 Jun 2009 14:02:01 -0700 (PDT)
Message-ID: <384888.96768.qm@web52401.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web52401.mail.re2.yahoo.com ([206.190.48.164]:36101 "HELO
	web52401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753584AbZFWVIk convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:08:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--- Em ter, 23/6/09, Jan Engelhardt <jengelh@medozas.de> escreveu:


>
> Does the problem go away if you call it indirectly? Like:
>
>
> stop_trigger.function =3D myfunc;
> ...
>
> myfunc(void)
> {
>     nf_unregister_hook(&nf_hook);
> }
>


Hi,

I've got a very similar question, about scheduling nf_register_hook, an=
d since I'm already calling it indirectly, I think this could prove use=
ful to both of us. I'd appreciate if anybody could help.

This is what I'm trying to do:

void foo () {
        unsigned long parameter;
        ...
        DEFINE_TIMER( timer, secfoo, jiffies + 250, parameter);
        ...
        add_timer(timer);
}

void secfoo( unsigned long param ) {
        ...
        nf_register_hook(...);
        ...
}

If I comment the "add_timer(timer);" and put "secfoo( parameter );" ins=
tead, it works out, though it doesn't help me, because I wanted to sche=
dule it. The way it is, I get a kernel panic.

Good day,

Bruno Fiss


      Veja quais s=E3o os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
