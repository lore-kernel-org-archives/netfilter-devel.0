From: "Hime Junior" <hime@engineer.com>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Wed, 30 Apr 2003 15:47:56 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430204757.26957.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, hime@engineer.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: laforge@netfilter.org, cieciwa@alpha.zarz.agh.edu.pl
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Harald :

 My comments go along the original message...

----- Original Message -----
From: Harald Welte <laforge@netfilter.org>
Date: Wed, 30 Apr 2003 17:57:36 +0200
To: Wojciech Sas Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6

> On Mon, Apr 28, 2003 at 05:13:15PM +0200, Wojciech Sas Cieciwa wrote:
> > 
> > Hi,
> > This is small patch to fix toruble on PPC with netfilter in module.
> > [Without this compiler generate "unresolved symbols"]
> 

    I´m curious about what "unresolved symbols" are those and why, 
 by changing the VALUE of a symbolic constant,the problem vanishes...

> indeed, there is no need for using floating point arithmetics at all.

 OK . The floating point instructions are eliminated by
 applying this patch .

> 
> Hime, would the proposed changes be fine with you (as the original
> author) ?
> 

 In functional terms , there is no difference between the 
two pieces of code - the behavior of the controller SHOULD be
 the same (in abstract terms).

 The only problem is relative to truncation errors...
I don´t have a PPC to do exaustive tests , but 
in the simulations that I have made , no discrepancies were detected
when computing the final acceptance rates .

=========================================================
	info->acceptance_rate = (u_int8_t) \
		(PAR_LOW * howhigh + PAR_HIGH * howlow);
		(howhigh * PAR_LOW + PAR_HIGH * howlow);
=========================================================


 However , when we change 

  " if (random_number <= 2.55 * info->acceptance_rate) "

by 

  " if (random_number <= (255 * info->acceptance_rate) / 100) "
		
we get different results for some (few) values of info->acceptance_rate.

 The good news are that the controller still works well and its
 behavior is basically the same .

 So , the patch (if applied , of course) will change the behavior of the controller - in an innocuous way , truly . 

 My opinion is that the primary reason for the change is very weird -
 "unresolved symbols" - and the solution is even more strange. 
 Anyway , I suggest additional investigation about this issue .
 
  Thank you very much .
   

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
