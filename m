From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: Unable to post - Ulogd / NFCT - Request for changes
Date: Thu, 19 Jul 2012 20:57:45 -0700
Message-ID: <CAAJpzgbsOSJjxdj-xRkNXvAa9z_Y4Oo01SFAQHWwb=DVFq9UgA@mail.gmail.com>
References: <CAAJpzgYYNbET-M07dKN6tEa7qpL3z0+6Tm=mRewnsoZue_Yddw@mail.gmail.com>
 <1342637621.5282.10.camel@tiger.regit.org> <CAAJpzgYJbk=Zo07Ue3R=Kx+X7aZDb2NR-YKMW4Y4r7PC81VGAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64562 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GTD6H convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:58:07 -0400
Received: by vbbff1 with SMTP id ff1so2578795vbb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jul 2012 20:58:06 -0700 (PDT)
In-Reply-To: <CAAJpzgYJbk=Zo07Ue3R=Kx+X7aZDb2NR-YKMW4Y4r7PC81VGAQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Can anyone respond for the message that I initially posted?

Thanks & Regards,




On Wed, Jul 18, 2012 at 12:21 PM, Gomathivinayagam Muthuvinayagam
<sankarmail@gmail.com> wrote:
> Thank for your info.
>
> I have few questions on this.
>
> Basically I want to record all the information that are coming to my
> system. I want to do accounting for each sender that send packets to
> my system.
>
> It seems nfacct provides data usage for different protocols. If I wan=
t
> to achieve the above requirement, I  have to set individual IP table
> rules for each incoming host and use nfacct. I dont want to do this.
>
> In consideration, nacct solves the problem, but only problem is it
> does not emit the data usage for long living connections in regular
> interval. Instead it emits the data usage only at the end of
> destroying the connections. That's why I raised the concern of
> changing the do_purge method that emits the data usage at regular
> intervals.
>
>
> Thanks & Regards,
>
>
>
>
> On Wed, Jul 18, 2012 at 11:53 AM, Eric Leblond <eric@regit.org> wrote=
:
>> Hi,
>>
>> Le mercredi 18 juillet 2012 =E0 08:10 -0700, Gomathivinayagam
>> Muthuvinayagam a =E9crit :
>>> Hi,
>>>
>>> Currently NFCT supports polling mode, but polling mode only propaga=
tes
>>> the message to output plugin during DESTROY event.
>>> This is a problem for long living connections, since I want to know
>>> the amount of data transfer before the destroy event.
>>
>> For accounting, you may want to look NFACCT. For more information, y=
ou
>> can read my recent blog post:
>> https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ul=
ogd2/
>>
>>
>>> After getting a quick walk through on NFCT plugin code, It seems I
>>> have to change the do_purge method, which is called in a regular ti=
me
>>> interval.
>>>
>>> I came with the following updates in the code (I added the else blo=
ck only).
>>>
>>>
>>> static int do_purge(void *data1, void *data2)
>>> {
>>>         int ret;
>>>         struct ulogd_pluginstance *upi =3D data1;
>>>         struct ct_timestamp *ts =3D data2;
>>>         struct nfct_pluginstance *cpi =3D
>>>                                 (struct nfct_pluginstance *) upi->p=
rivate;
>>>
>>>         ulogd_log(ULOGD_NOTICE,"Inside do_purge method\n");
>>>
>>>         /* if it is not in kernel anymore, purge it */
>>>         ret =3D nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
>>>         if (ret =3D=3D -1 && errno =3D=3D ENOENT) {
>>>                 do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
>>>                 hashtable_del(cpi->ct_active, &ts->hashnode);
>>>                 nfct_destroy(ts->ct);
>>>                 free(ts);
>>>         }
>>>         else // Added code
>>>         {
>>>                 do_propagate_ct(upi, ts->ct,NFCT_T_UPDATE,ts);
>>>         }
>>>
>>>         return 0;
>>> }
>>>
>>> The else part propagates a flow eventhough there were no updates
>>> happened to the flow. Could you help somone here, I would like to
>>> propagate about the updates of a connection, if there was a change
>>> happened to the long living connection. Is this correct approach?
>>>
>>> My intuition, I have to call nfct_cmp method by passing the local h=
ash
>>> table connection, and the available connection in the kernel. If th=
ey
>>> are same, then there were no updates happened to the connection,
>>> otherwise I will propagate the details of the particular connection=
=2E
>>>
>>> Thanks & Regards,
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netfilter=
-devel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> Eric Leblond
>> Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
