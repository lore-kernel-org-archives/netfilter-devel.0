From: Serge Leschinsky <serge.leschinsky@gmail.com>
Subject: Re: a possible bug in netfilter
Date: Tue, 17 Apr 2012 15:20:42 -0700
Message-ID: <4F8DECBA.4080302@gmail.com>
References: <4F7E6D32.9060109@gmail.com> <alpine.LNX.2.01.1204061444170.19371@frira.zrqbmnf.qr> <20120407155847.GB28425@Chamillionaire.breakpoint.cc> <4F810EF1.1030209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39993 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2DQWUp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:20:45 -0400
Received: by dake40 with SMTP id e40so8938264dak.11
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Apr 2012 15:20:45 -0700 (PDT)
In-Reply-To: <4F810EF1.1030209@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46lorian,

I think the problem is fixed - the boxes work fine, I didn=92t notice p=
anics from=20
the update.

Thanks a lot!

Serge


On 04/07/2012 09:07 PM, Serge Leschinsky wrote:
> On 04/07/2012 08:58 AM, Florian Westphal wrote:
> ....
>> Serge, could you try this patch?
>>
>> diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
>> index 46b2831..acb5e8e 100644
>> --- a/extensions/xt_psd.c
>> +++ b/extensions/xt_psd.c
>> @@ -227,7 +227,7 @@ xt_psd_match(const struct sk_buff *pskb, struct
>> xt_action_param *match)
>> goto out_match;
>>
>> /* Remember the new port */
>> - if (curr->count< SCAN_MAX_COUNT) {
>> + if (curr->count< ARRAY_SIZE(curr->ports)) {
>> curr->ports[curr->count].number =3D dest_port;
>> curr->ports[curr->count].proto =3D proto;
>> curr->ports[curr->count].and_flags =3D tcp_flags;
>>
>
> The patch is applied. I'll monitor logs for about a week to make sure=
 there are
> no more panics.
>
> Thank you!
> Serge

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
