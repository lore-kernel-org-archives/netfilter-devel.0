From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: nat drop the icmp redirect packet
Date: Mon, 05 Dec 2011 09:18:28 +0800
Message-ID: <4EDC1BE4.4030701@cn.fujitsu.com>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED67BB1.8020808@trash.net> <4ED6D18C.7000802@cn.fujitsu.com> <4ED754EA.9060906@trash.net> <4ED862E6.6090104@cn.fujitsu.com> <4ED8CB82.40603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1LEBRj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Dec 2011 20:17:39 -0500
In-Reply-To: <4ED8CB82.40603@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2011=E5=B9=B412=E6=9C=8802=E6=97=A5 20:58, Patrick McHardy =E5=
=86=99=E9=81=93:
> On 02.12.2011 06:32, Gao feng wrote:
>> =E4=BA=8E 2011=E5=B9=B412=E6=9C=8801=E6=97=A5 18:20, Patrick McHardy=
 =E5=86=99=E9=81=93:
>>> Yes, as I said, we could set up a NULL source mapping on the
>>> conntrack of the original packet and let the REDIRECT through.
>>> The user might have configured a source NAT rule though which
>>> would become ineffective by this.
>>>
>>
>> Hi Patrick:
>>
>> Yes,you are right.
>>
>> You mean we have no idea of the ICMP REDIRECT packet being droppen
>> when nat is not finished?
>=20
> We can't determine whether we could let it through at that point.
> The safe choice is to drop it.
> --

Good Morning Patrick

I got it,thank you very much.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
