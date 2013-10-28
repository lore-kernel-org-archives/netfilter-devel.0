From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] netfilter: ipset: Fix library interface version
Date: Mon, 28 Oct 2013 10:28:07 +0700
Message-ID: <CAMQP0s=o1CVJoa+rNbOpPAm704DDN2BUJ5At641y=K=wTd1EdA@mail.gmail.com>
References: <20131026080206.GA19266@nitrogen.neutroncom.local>
	<alpine.DEB.2.10.1310271912590.6494@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58715 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3J1D2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:28:08 -0400
Received: by mail-pd0-f182.google.com with SMTP id q10so6426046pdj.41
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 20:28:08 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.10.1310271912590.6494@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks a lot, and also thanks Jan Engelhardt.

I will prepare the Debian package asap.

Best regards,
Neutron Soutmun

On Mon, Oct 28, 2013 at 1:14 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Sat, 26 Oct 2013, Neutron Soutmun wrote:
>
>> * The library interface version should be 5:0:2 which it will create the
>>   libipset.so.3.2.0 instead of 4:1:2 which create the libipset.so.2.2.1
>>
>> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
>
> Jan Engelhardt already sent a patch to fix the library version, I have
> applied his patch.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
