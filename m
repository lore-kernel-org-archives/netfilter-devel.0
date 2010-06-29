From: tingwei liu <tingw.liu@gmail.com>
Subject: Re: multi-path route can't keep long time connections
Date: Tue, 29 Jun 2010 10:36:46 +0800
Message-ID: <AANLkTil_yDjxhEJDfQRc-7I-eMIOU7w6mJj6TA3-KXDx@mail.gmail.com>
References: <AANLkTimeYhY-lgY2c5dfYQRDZ2oDLpB1U7TzkvyFQh_A@mail.gmail.com>
	<4C205531.2010402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53808 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0F2Cgr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:36:47 -0400
Received: by vws5 with SMTP id 5so838569vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jun 2010 19:36:46 -0700 (PDT)
In-Reply-To: <4C205531.2010402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you very much.

2010/6/22 Patrick McHardy <kaber@trash.net>:
> tingwei liu wrote:
>>
>> Because route circularly flush route cache
>> (/proc/net/sys/ipv4/route/secret_timeval),the multi-path route can't
>> keep long time connections. The long time connections maybe interrup=
t
>> every "secret_timeval" seconds.
>> Such as:
>> default nexthop via 192.168.0.1 weight 1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 via 192.168.1.1 weight 1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 via 192.168.2.1 weight 1
>>
>> With a connection cross 192.168.0.1 in the first time."secret_timeva=
l"
>> seconds later,this connection maybe cross 192.168.1.1,then this
>> connection will be reconnect.
>>
>> Anyone can help me?
>
> Use CONNMARK to mark new connections, than use that mark
> to bind them to a specific route.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
