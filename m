From: "Wojciech \"Sas\" Cieciwa" <cieciwa@alpha.zarz.agh.edu.pl>
Subject: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Mon, 28 Apr 2003 17:13:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0304281710230.12878-100000@alpha.zarz.agh.edu.pl>
References: <20030427094949.GF990@sunbeam.de.gnumonks.org>
 <20030427.173804.13764775.davem@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030427.173804.13764775.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,
This is small patch to fix toruble on PPC with netfilter in module.
[Without this compiler generate "unresolved symbols"]

Thanx.
				Sas.


--- fuzzy.patch.org	Wed Sep  4 16:11:30 2002
+++ fuzzy.patch	Mon Apr 28 17:06:58 2003
@@ -59,7 +59,7 @@
 + Expressed in percentage
 +*/
 +
-+#define PAR_LOW		0.01
++#define PAR_LOW		1/100
 +#define PAR_HIGH	1
 +
 +static spinlock_t fuzzy_lock = SPIN_LOCK_UNLOCKED ;
@@ -138,7 +138,7 @@
 +       howlow  = mf_low(info->mean_rate,info->minimum_rate,info->maximum_rate);
 +
 +    info->acceptance_rate = (u_int8_t) \
-+		           ( PAR_LOW*howhigh + PAR_HIGH*howlow ) ;
++		           ( howhigh*PAR_LOW + PAR_HIGH*howlow ) ;
 +
 +    /* In fact , the above defuzzification would require a denominator
 +       proportional to (howhigh+howlow) but , in this particular case ,
@@ -158,7 +158,7 @@
 +		get_random_bytes((void *)(&random_number), 1);
 +
 +		/*  If within the acceptance , it can pass => don't match */
-+		if ( random_number <= 2.55 * info->acceptance_rate )
++		if ( random_number <= (255 * info->acceptance_rate) / 100 )
 +			return 0 ;
 +		else
 +			return 1; /* It can't pass ( It matches ) */
--- fuzzy6.patch.ipv6.org	Fri Apr 11 12:27:54 2003
+++ fuzzy6.patch.ipv6	Mon Apr 28 17:07:51 2003
@@ -60,7 +60,7 @@
 + Expressed in percentage
 +*/
 +
-+#define PAR_LOW		0.01
++#define PAR_LOW		1/100
 +#define PAR_HIGH	1
 +
 +static spinlock_t fuzzy_lock = SPIN_LOCK_UNLOCKED;
@@ -138,7 +138,7 @@
 +		howlow  = mf_low(info->mean_rate,info->minimum_rate,info->maximum_rate);
 +
 +		info->acceptance_rate = (u_int8_t) \
-+				(PAR_LOW * howhigh + PAR_HIGH * howlow);
++				(howhigh * PAR_LOW + PAR_HIGH * howlow);
 +
 +	/* In fact, the above defuzzification would require a denominator
 +	 * proportional to (howhigh+howlow) but, in this particular case,
@@ -158,7 +158,7 @@
 +		get_random_bytes((void *)(&random_number), 1);
 +
 +		/*  If within the acceptance , it can pass => don't match */
-+		if (random_number <= 2.55 * info->acceptance_rate)
++		if (random_number <= (255 * info->acceptance_rate) / 100)
 +			return 0;
 +		else
 +			return 1; /* It can't pass (It matches) */

-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
