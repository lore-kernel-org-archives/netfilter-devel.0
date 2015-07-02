From: =?ISO-8859-15?Q?Szil=E1rd_Pfeiffer?= <pfeiffer.szilard@balabit.hu>
Subject: Re: [PATCH] conntrack: made the protocol option value case insensitive
Date: Fri, 03 Jul 2015 00:53:57 +0200
Message-ID: <5595C105.2060102@balabit.hu>
References: <1435227145-15554-1-git-send-email-pfeiffer.szilard@balabit.hu> <20150626071921.GA30656@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:47782 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbbGBWyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 18:54:00 -0400
Received: from [10.70.0.70] (unknown [10.70.0.70])
	by mail.balabit.hu (Postfix) with ESMTPSA id 242EC205E58
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2015 00:53:58 +0200 (CEST)
In-Reply-To: <20150626071921.GA30656@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2015-06-26 09:19, Florian Westphal wrote:
> pfeiffer.szilard@balabit.hu <pfeiffer.szilard@balabit.hu> wrote:
>> From: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
>>
>> Extensions register protocols by lowercase protocol name, but value =
of
>> proto command line option may be uppercase. Extension related option=
s
>> cannot be used when protocol name comparision fails.
>>
>> Signed-off-by: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
>> ---
>>  src/conntrack.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/src/conntrack.c b/src/conntrack.c
>> index f7d37fb..b1a2589 100644
>> --- a/src/conntrack.c
>> +++ b/src/conntrack.c
>> @@ -555,6 +555,12 @@ static struct ctproto_handler *findproto(char *=
name, int *pnum)
>>  	/* using the protocol name for an unsupported protocol? */
>>  	if ((pent =3D getprotobyname(name))) {
>>  		*pnum =3D pent->p_proto;
> Why not use strcasecmp to check the proto_list?
>
I have just realized that iptables ignores case while checking value of
--protocol parameter, so the conntrack tool should do it in the same wa=
y.

I remake the patch. Thanks for your feedback.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
