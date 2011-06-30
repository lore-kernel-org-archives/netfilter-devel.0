From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 10:32:34 -0400
Message-ID: <4E0C8902.8070303@earthlink.net>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>	 <1309340843.2532.112.camel@edumazet-laptop>	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4E0C651A.1000300@trash.net> <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:60798 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab1F3Okj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:40:39 -0400
In-Reply-To: <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/30/2011 11:15 AM, Eric Dumazet wrote:
> Le jeudi 30 juin 2011 =C3=A0 13:59 +0200, Patrick McHardy a =C3=A9cri=
t :
>
>   =20
>> Thanks Eric, I agree. Give us data and we'll fix it if really is a b=
ug.
>>
>> The fact that the timeout patch apparently helps indicates that some
>> packets don't receive verdicts.
>>     =20
> My rough guess is that this user application gets an error in its
> nfq_set_verdict() call ( maybe a transient out of memory indication) =
and
> packet never gets its verdict.
>
> libnetfilter_queue/utils/nfqnl_test.c is buggy in this regard : It
> should at least log an error if nfq_set_verdict() fails, so that
> programmer using nfqnl_test.c as a template is aware of a possible
> problem here.
>
>
>   utils/nfqnl_test.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
> index a554f2d..b7e0cf9 100644
> --- a/utils/nfqnl_test.c
> +++ b/utils/nfqnl_test.c
> @@ -69,8 +69,13 @@ static int cb(struct nfq_q_handle *qh, struct nfge=
nmsg *nfmsg,
>   	      struct nfq_data *nfa, void *data)
>   {
>   	u_int32_t id =3D print_pkt(nfa);
> +	int res;
> +
>   	printf("entering callback\n");
> -	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
> +	res =3D nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
> +	if (res =3D=3D -1)
> +		printf("nfq_set_verdict() error %d (packet stuck in queue !)\n", e=
rrno);
> +	return res;
>   }
>
>   int main(int argc, char **argv)
>
>   =20

So if you receive a -1 the proper recovery is to call nfq_set_verdict()=
=20
again?

--=20

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
