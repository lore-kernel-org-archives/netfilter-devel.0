From: "Hime Junior" <hime@engineer.com>
Subject: Re: fuzzy.patch and fuzzy.patch.ipv6 - again.
Date: Fri, 06 Jun 2003 12:54:54 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030606175454.28291.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: " Cieciwa" <cieciwa@alpha.zarz.agh.edu.pl>, laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 Hi Harald !

 Have you applied that patch ?

 As I said before , the new behavior is , in practice , equivalent to the old one.

 Regards.

----- Original Message -----
From: "Wojciech \"Sas\" Cieciwa" <cieciwa@alpha.zarz.agh.edu.pl>
Date: Fri, 6 Jun 2003 15:31:42 +0200 (CEST) 
To: Harald Welte <laforge@netfilter.org>
Subject: fuzzy.patch and fuzzy.patch.ipv6 - again.

> Hi,
> 
> I try to build p-o-m [2003 06 05] on PPC and I take some unresolved symbols.
> I don't know, that I send patch which resole this problem.
> 
> If yes, please appaly this.
> If not here is the patch.
> 
> diff -Nur netfilter.org/patch-o-matic/base/fuzzy.patch netfilter/patch-o-matic/base/fuzzy.patch
> --- netfilter.org/patch-o-matic/base/fuzzy.patch	Wed Sep  4 16:11:30 2002
> +++ netfilter/patch-o-matic/base/fuzzy.patch	Fri Jun  6 15:19:57 2003
> @@ -59,7 +59,7 @@
>  + Expressed in percentage
>  +*/
>  +
> -+#define PAR_LOW		0.01
> ++#define PAR_LOW		1/100
>  +#define PAR_HIGH	1
>  +
>  +static spinlock_t fuzzy_lock = SPIN_LOCK_UNLOCKED ;
> @@ -138,7 +138,7 @@
>  +       howlow  = mf_low(info->mean_rate,info->minimum_rate,info->maximum_rate);
>  +
>  +    info->acceptance_rate = (u_int8_t) \
> -+		           ( PAR_LOW*howhigh + PAR_HIGH*howlow ) ;
> ++		           ( howhigh*PAR_LOW + PAR_HIGH*howlow ) ;
>  +
>  +    /* In fact , the above defuzzification would require a denominator
>  +       proportional to (howhigh+howlow) but , in this particular case ,
> @@ -158,7 +158,7 @@
>  +		get_random_bytes((void *)(&random_number), 1);
>  +
>  +		/*  If within the acceptance , it can pass => don't match */
> -+		if ( random_number <= 2.55 * info->acceptance_rate )
> ++		if ( random_number <= (255 * info->acceptance_rate) / 100 )
>  +			return 0 ;
>  +		else
>  +			return 1; /* It can't pass ( It matches ) */
> diff -Nur netfilter.org/patch-o-matic/base/fuzzy6.patch.ipv6 netfilter/patch-o-matic/base/fuzzy6.patch.ipv6
> --- netfilter.org/patch-o-matic/base/fuzzy6.patch.ipv6	Fri Apr 11 12:27:54 2003
> +++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6	Fri Jun  6 15:20:49 2003
> @@ -60,7 +60,7 @@
>  + Expressed in percentage
>  +*/
>  +
> -+#define PAR_LOW		0.01
> ++#define PAR_LOW		1/100
>  +#define PAR_HIGH	1
>  +
>  +static spinlock_t fuzzy_lock = SPIN_LOCK_UNLOCKED;
> @@ -138,7 +138,7 @@
>  +		howlow  = mf_low(info->mean_rate,info->minimum_rate,info->maximum_rate);
>  +
>  +		info->acceptance_rate = (u_int8_t) \
> -+				(PAR_LOW * howhigh + PAR_HIGH * howlow);
> ++				(howhigh * PAR_LOW + PAR_HIGH * howlow);
>  +
>  +	/* In fact, the above defuzzification would require a denominator
>  +	 * proportional to (howhigh+howlow) but, in this particular case,
> @@ -158,7 +158,7 @@
>  +		get_random_bytes((void *)(&random_number), 1);
>  +
>  +		/*  If within the acceptance , it can pass => don't match */
> -+		if (random_number <= 2.55 * info->acceptance_rate)
> ++		if (random_number <= (255 * info->acceptance_rate) / 100)
>  +			return 0;
>  +		else
>  +			return 1; /* It can't pass (It matches) */
> 
> -- 
> {Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
> {e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
> 
> 




                    Hime Junior
            ___________________________
  
          Electronic and Control Engineer


-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
