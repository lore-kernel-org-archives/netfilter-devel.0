From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft 0/1] Proposal: include directories for rulesets
Date: Fri, 4 Mar 2016 10:57:40 +0100
Message-ID: <CAOkSjBjPom6KFPLEae7=LWUd79LuqPvV5mfQrhy37HY-jALvYw@mail.gmail.com>
References: <1456920690-14477-1-git-send-email-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33882 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbcCDJ6B convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2016 04:58:01 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so3307843wmp.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Mar 2016 01:58:01 -0800 (PST)
In-Reply-To: <1456920690-14477-1-git-send-email-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 March 2016 at 13:11, Ismo Puustinen <ismo.puustinen@intel.com> wro=
te:
> A nice-to-have feature in nft would be the ability to use include
> directories that contain rule files. The use case would be support fo=
r
> services dropping their custom configuration files into a directory,
> allowing a more modular firewall configuration.
>
> This is a proof-of-concept patch -- I'm not very familiar with nftabl=
es
> code base and conventions.
>

Hi Ismo,

I like the idea. What I'm wondering is if it worth having another
directive like 'includedir' to be more explicit.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
