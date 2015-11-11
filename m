From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd PATCH 2/2 v2] conntrackd: add systemd support
Date: Wed, 11 Nov 2015 19:18:20 +0100
Message-ID: <CAOkSjBi=MMnYNPPzTee5P3eOFCRBymEOoUDAZFQohr+Tk_LLgw@mail.gmail.com>
References: <144619584355.30622.12279676149815885959.stgit@r2d2.cica.es>
 <20151106135318.GA7657@salvia> <CAOkSjBh92vvnW2UV=6E3V8ha1+wRi0+eLuPcoyPQku1K0SCakw@mail.gmail.com>
 <20151111155933.GA20284@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33000 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbKKSSl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 13:18:41 -0500
Received: by wmec201 with SMTP id c201so194166962wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 10:18:40 -0800 (PST)
In-Reply-To: <20151111155933.GA20284@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 November 2015 at 16:59, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Fri, Nov 06, 2015 at 04:59:22PM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 6 November 2015 at 14:53, Pablo Neira Ayuso <pablo@netfilter.org>=
 wrote:
>> >> +void sd_ct_watchdog_init(void)
>> >> +{
>> >> +     /* ignoring systemd API erros: only care if admin expects w=
atchdog */
>> >
>> > Not sure what you mean with this comment.
>>
>> The API call may returns:
>>  * negative errno-style error code
>>  * 0 if watchdog is not expected by systemd for this daemon
>>  * >0 if watchdog is expected by systemd for this daemon
>>
>> My patch ignores the 2 first options, we only continue executing thi=
s
>> function if watchdog is expected by systemd (i.e, the admin configur=
ed
>> it).
>
> I think it is a good idea to report that no systemd watchdog is going
> on through log messages.

Ok.

>
>> I ignored errors because I would not like to exit conntrackd if ther=
e
>> is some issue in the systemd side, just ignore it.
>>
>> >
>> >> +     if (sd_watchdog_enabled(0, &sd_watchdog_interval) < 1)
>> >
>> > So sd_watchdog_enabled is setting sd_watchdog_interval?
>> >
>> > What is the value that sd_watchdog_interval is being set?
>> >
>>
>> Yes, only if sd_watchdog_enabled returned >0.
>>
>> From the man page:
>>
>> ""
>> int sd_watchdog_enabled(int unset_environment, uint64_t *usec);
>> [...]
>> If the usec parameter is non-NULL, sd_watchdog_enabled() will write
>> the timeout in =E7=9B=9C for the watchdog logic to it.
>> ""
>
> I guess this is configured from systemd, what is the default?

No defaults, an explicit timeout is required by systemd if whatdog is
configured.
Well, the default timeout time is 0 seconds, which disables the systemd=
 feature.
So the admin has to select one (in seconds).

>
> On top of this, I wonder if we should have a configuration option fro=
m
> our configuration file, something that allows us to do "Systemd Off".
> I would suggest default in "Systemd On" if not specified, given that
> main distros decided to follow this path.
>
> After this patch, we can only enable/disable systemd integration at
> configuration/compilation stage, however I expect most users will be
> using packages from distros. I think it would be good to provide them
> a runtime way to disable this if they don't want any interference wit=
h
> their existing infrastructure.
>
> Does this sound reasonable to you? Other than that above, this patch
> looks good to me.

Yeah, I agree. Will do that ASAP.

thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
