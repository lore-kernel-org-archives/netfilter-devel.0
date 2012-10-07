From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: Re: searching tuples in conntrack
Date: Sun, 7 Oct 2012 02:31:41 -0500
Message-ID: <CA+Z0r8OcKfcVRv4sKnvvNNOs8_An2HRC86sYTi+NHyz_tLKfig@mail.gmail.com>
References: <CA+Z0r8MVyzWP_uM+Ryge5YY8Dr9XO+Uh1x0g7Zc8FBp16mMAGQ@mail.gmail.com>
 <alpine.LNX.2.01.1209262231180.30346@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:50845 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2JGHcM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:32:12 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so1005771dak.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Oct 2012 00:32:12 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209262231180.30346@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I'm having some problems creating a function like count_them and the
hash table it uses. My module is a target extension and connlimit is a
match extension.

So correct me if I'm wrong... basically connlimit creates an extra
hash table with struct xt_connlimit_info *info =3D par->matchinfo as a
parameter to save conntracks and tuples, but I don't have such info
because i'm making a target extension... Can't I do a lookup directly
to the NFCT list?

How can I initialize the hash table like in connlimit_mt_check() if I
don't work with const struct xt_mtchk_param *par?

Can you point in the right direction? I'm really new to kernel dev.. I
hope I'm not asking too much of you

Regards


On Wed, Sep 26, 2012 at 3:32 PM, Jan Engelhardt <jengelh@inai.de> wrote=
:
> On Wednesday 2012-09-26 19:29, Miguel Alejandro Gonz=E1lez wrote:
>
>>Hello,
>>
>>I have been reading some kernel code trying to find a function that
>>searches the conntrack hash table for a transport address and returns
>>the given tuple. Is there any way to do this? I found a function in
>>the nat code called find_appropriate_src but i think it only works fo=
r
>>the nat table...
>
> nf_conntrack_find_get(...) is the one to use for CT lookup.
> (Cf. xt_connlimit.c)
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
