From: Brad Fisher <brad@info-link.net>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 10:35:46 -0600
Message-ID: <41EFDDE2.8030901@info-link.net>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>	<20050114143722.GA10088@ti64.telemetry-investments.com>	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>	<41E7F2DA.608@info-link.net>
	<41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:

>>
>> Sorry for the additional spam :(
>>
>> The check should be changed to something like the following:
>>
>> +      if (info->date_start <=3D info->date_stop) {
>> +              /* normal order: start <=3D stop */
>> +              if ((skb->stamp.tv_sec < info->date_start) ||=20
>> (skb->stamp.tv_sec > info->date_stop))
>> +                        return 0;
>> +        } else {
>> +              /* reversed order: stop < start */
>> +                if ((skb->stamp.tv_sec < info->date_start) &&=20
>> (skb->stamp.tv_sec > info->date_stop))
>> +                        return 0;
>> +        }
>>
>> Sorry about the previous crap :)  Anyway, this only adds one more if=20
>> test per packet, which in my opintion is acceptable when the=20
>> alternative is an additional rule.
>
>
>
> OK.. You need to match 20:00-4:00, right? So why you just cannot=20
> reverse the match of 4:00-20:00?
>
> Best regards,
>
>                 Krzysztof Ol=EAdzki
>
20:00 - 4:00 is very different from 4:00 - 20:00, one is a range of 8=20
hours (20,21,22,23,0,1,2,3), the other is a range of 16=20
(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)...  They are complementary=20
to each other in terms of a 24 hour clock.

To match 20:00 - 4:00 you currently need 2 rules:
  1) match 20:00 - 23:59
  2) match 0:00 - 4:00
What I'm proposing is to allow this to be reduced to one rule.

-Brad Fisher
