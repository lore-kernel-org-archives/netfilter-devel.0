From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd PATCH 2/2 v2] conntrackd: add systemd support
Date: Fri, 6 Nov 2015 16:59:22 +0100
Message-ID: <CAOkSjBh92vvnW2UV=6E3V8ha1+wRi0+eLuPcoyPQku1K0SCakw@mail.gmail.com>
References: <144619584355.30622.12279676149815885959.stgit@r2d2.cica.es> <20151106135318.GA7657@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33831 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbKFP7n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 10:59:43 -0500
Received: by wikq8 with SMTP id q8so33007602wik.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2015 07:59:42 -0800 (PST)
In-Reply-To: <20151106135318.GA7657@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 November 2015 at 14:53, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
>> +void sd_ct_watchdog_init(void)
>> +{
>> +     /* ignoring systemd API erros: only care if admin expects watc=
hdog */
>
> Not sure what you mean with this comment.

The API call may returns:
 * negative errno-style error code
 * 0 if watchdog is not expected by systemd for this daemon
 * >0 if watchdog is expected by systemd for this daemon

My patch ignores the 2 first options, we only continue executing this
function if watchdog is expected by systemd (i.e, the admin configured
it).

I ignored errors because I would not like to exit conntrackd if there
is some issue in the systemd side, just ignore it.

>
>> +     if (sd_watchdog_enabled(0, &sd_watchdog_interval) < 1)
>
> So sd_watchdog_enabled is setting sd_watchdog_interval?
>
> What is the value that sd_watchdog_interval is being set?
>

Yes, only if sd_watchdog_enabled returned >0.

=46rom the man page:

""
int sd_watchdog_enabled(int unset_environment, uint64_t *usec);
[...]
If the usec parameter is non-NULL, sd_watchdog_enabled() will write
the timeout in =C2=B5s for the watchdog logic to it.
""

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
