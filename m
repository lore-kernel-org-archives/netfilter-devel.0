From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 10:32:36 -0500 (EST)
Message-ID: <57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
To: "Krzysztof Oledzki" <olenf@ans.pl>
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

On Fri, January 14, 2005 9:48 am, Krzysztof Oledzki said:
>> This is most likely due to Andi Kleen's net timestamp optimization,
>> which
>> avoids calling gettimeofday in the network fastpath unless it is neede=
d.
>
> I see... So, where we should fix this in netfilter code?

Am sorry, I haven't looked much at your patches. But here's my opinion.

Netfilter shouldn't enable this for the unique reason a match/target
will possibly rely on this.

I think it's the job of the first rule (of a given module) seeing that
'new' packet to keep counting the last-seen time. Yes, the stamp is a bit
later than it should. But that's not dramatic and still consistant among
multiple rules (of a common module) needing that reference.

I use an ugly hack of this kind:

   /* We might not have a timestamp, get one */
   if (skb->stamp.tv_sec =3D=3D 0)
      do_gettimeofday((struct timeval *)&skb->stamp);

   now =3D timeval_to_jiffies(&skb->stamp);


   if (struct->curr !=3D now)
      struct->prev =3D xchg(&struct->curr, now);

As of writing it, I only tested it under nfsim while increasing kernel
time before each hook. Seemed to work.

Each of my rules were using struct->prev as the last-seen time of the
packet. And the first rule always update this stamp.

If I am way of target, just slap me 8)

> Best regards,
>
>
>  			Krzysztof Ol=EAdzki

Cheers,

Samuel
