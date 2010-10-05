From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: checkentry function
Date: Tue, 5 Oct 2010 14:46:15 +0900
Message-ID: <20101005144615.0f84d53a@s6510>
References: <AANLkTimeoRTBMY0OH5sDtVEfqFCx9F3go1qGKy5cJpWS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:54271 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab0JEFqU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:46:20 -0400
In-Reply-To: <AANLkTimeoRTBMY0OH5sDtVEfqFCx9F3go1qGKy5cJpWS@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2 Oct 2010 13:59:30 +0200
Nicola Padovano <nicola.padovano@gmail.com> wrote:

> Hello there.
> I've written checkentry function to check my new target, in this way:
>=20
> [CHECK_ENTRY_CODE]
> static bool xt_tarpit_check(const char *tablename, const void *entry,
>                             const struct xt_target *target, void *tar=
ginfo,
>                             unsigned int hook_mask)
> {
>  if (strcmp(tablename, "filter"))   {
>     printk(KERN_INFO "DEBUG: the tablename (not FILTER) is %s\n",tabl=
ename);
>     return false;
>   }
> return true;
> }
> [/CHECK_ENTRY_CODE]
>=20
> but it doesn't work.
> In fact if I do:
>=20
> iptables -A INPUT -t filter -s 192.168.0.1 -p tcp -j TAR
>=20
> the printk prints this message: DEBUG: the tablename (not FILTER) is:=
 =EF=BF=BD%H =EF=BF=BD
>=20
> so: in the tablename i haven't the string "filter"...what' the matter=
?
>=20

In current kernels, checkentry returns errno values.
0 =3D okay
<0 is error (example -EINVAL).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
