From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 adjust policy in user-defined chains
Date: Wed, 19 Nov 2014 13:23:01 +0100
Message-ID: <CAOkSjBjFf9vi98B8oJ1y2LGjaYg+s4nP1uMKn0bqCUYh2wxRFg@mail.gmail.com>
References: <20141117123622.11349.43033.stgit@nfdev.cica.es> <20141118184343.GA5179@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:65072 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKSMXY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:23:24 -0500
Received: by mail-la0-f48.google.com with SMTP id s18so390633lam.7
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2014 04:23:22 -0800 (PST)
In-Reply-To: <20141118184343.GA5179@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 November 2014 19:43, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>>                       if (command =3D=3D 'N' && c =3D=3D 'P') {
>> -                             command =3D c;
>> -                             optind--; /* No table specified */
>> -                             goto handle_P;
>> +                             xtables_error(PARAMETER_PROBLEM,
>> +                                           "The default policy in u=
ser-defined"
>> +                                           " chains is RETURN (mand=
atory)");
>>                       }
>
> I'd really prefer to avoid changes in the ebtables parser. Could you
> perform this checking from later on, when validating the
> configuration.
>
>         if (strcmp(chain, "INPUT") !=3D 0 &&
>             strcmp(chain, "FORWARD") !=3D 0 &&
>             ...                           &&
>             strcmp(policy, "RETURN") !=3D 0)
>                 xtables_error("...);
>

In the user-defined chain creation path, the code jumps to several
places (the goto handle_P; thing). I don't see clearly a zone where to
put these validations.

Could you please point to where would you like to put this code?

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
