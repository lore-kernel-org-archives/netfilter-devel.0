From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 16:51:43 +0200
Message-ID: <4E0C8D7F.3000902@trash.net>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>	 <1309340843.2532.112.camel@edumazet-laptop>	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4E0C651A.1000300@trash.net> <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4E0C8902.8070303@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46932 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1F3Ovs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:51:48 -0400
In-Reply-To: <4E0C8902.8070303@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.06.2011 16:32, Stephen Clark wrote:
> On 06/30/2011 11:15 AM, Eric Dumazet wrote:
>> Le jeudi 30 juin 2011 =E0 13:59 +0200, Patrick McHardy a =E9crit :
>>
>>  =20
>>> Thanks Eric, I agree. Give us data and we'll fix it if really is a =
bug.
>>>
>>> The fact that the timeout patch apparently helps indicates that som=
e
>>> packets don't receive verdicts.
>>>     =20
>> My rough guess is that this user application gets an error in its
>> nfq_set_verdict() call ( maybe a transient out of memory indication)=
 and
>> packet never gets its verdict.
>>
>> libnetfilter_queue/utils/nfqnl_test.c is buggy in this regard : It
>> should at least log an error if nfq_set_verdict() fails, so that
>> programmer using nfqnl_test.c as a template is aware of a possible
>> problem here.
>>
>>
>>   utils/nfqnl_test.c |    7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
>> index a554f2d..b7e0cf9 100644
>> --- a/utils/nfqnl_test.c
>> +++ b/utils/nfqnl_test.c
>> @@ -69,8 +69,13 @@ static int cb(struct nfq_q_handle *qh, struct
>> nfgenmsg *nfmsg,
>>             struct nfq_data *nfa, void *data)
>>   {
>>       u_int32_t id =3D print_pkt(nfa);
>> +    int res;
>> +
>>       printf("entering callback\n");
>> -    return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
>> +    res =3D nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
>> +    if (res =3D=3D -1)
>> +        printf("nfq_set_verdict() error %d (packet stuck in queue
>> !)\n", errno);
>> +    return res;
>>   }
>>
>>   int main(int argc, char **argv)
>>
>>   =20
>=20
> So if you receive a -1 the proper recovery is to call nfq_set_verdict=
()
> again?

Look at errno to see what's happening. But yes, this indicates the
verdict wasn't issues successfully, so you need to retransmit.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
