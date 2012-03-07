From: tingwei liu <tingw.liu@gmail.com>
Subject: Re: NFQUEUE in bridge mode performance poor in the last kernels
Date: Wed, 7 Mar 2012 08:46:21 +0800
Message-ID: <CA+qZnSTMb=wXeHmmj5=HKxQcLbMJK16m+u37EERw5G_Wgup5tQ@mail.gmail.com>
References: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
	<1331047163.2474.47.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64696 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932723Ab2CGAqV convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:46:21 -0500
Received: by obbuo6 with SMTP id uo6so6136858obb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Mar 2012 16:46:21 -0800 (PST)
In-Reply-To: <1331047163.2474.47.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 6, 2012 at 11:19 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le mardi 06 mars 2012 =C3=A0 10:05 +0800, tingwei liu a =C3=A9crit :
>> In the past few days, I have puzzled by NFQUEUE in bridge mode.
>> I have take some test with five kernels.
>> 2.6.24.4
>> 2.6.36.4
>> 2.6.38
>> 3.0.8
>> 3.1.10
>>
>> The result is : 2.6.24.4,2.6.26.4,2.6.38 have a goog performance;
>> 3.0.8 and 3.1.10 have a poor performance.
>> Next is copy from suricata maillist( eric@regit.org )
>>
>> I'm having a look at it. There has been some changes between the two
>> kernel versions (bringing more performances) but it seems there is s=
ome
>> side effects with bridge.
>> Thanks!
>
> More data is welcomed. What is "good", what is "bad" ?
>
Sorry for that.
My network is 100Mbps.
"good" means the forward bandwidth almost 100Mbps.
"bad" means the forward bandwidth with nfqueue only 30Mbps.
Thanks for your reply!
> You dont expect us to magically understand the issue, do you ?
>
> If you want some help, you should give as much information as possibl=
e.
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
