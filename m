From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 19:23:48 -0500
Message-ID: <41F04B94.3070902@cookinglinux.org>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
	<41EFDDE2.8030901@info-link.net>
	<Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
	<13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501202346450.3962@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.61.0501202346450.3962@bizon.gios.gov.pl>
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
> I'm not sure if adding a negation-like-workaround to ipt_time (and 
> possible other matches like ipt_limit) is a good idea.

Obviously, I would need to peek at the code to continue following this 
thread. However, my brain is already spinning on other codes.

> My qestion is: 
> why we cannot simply negate all matches?

I guess it would confuse the user when the match uses multiple options.
Am confused just thinking about it :)

But am also in the favor that all matches should accept and behave the 
right way with negation unless negation really doesn't make sense nor 
does anything usefull.

Maybe I missed a match that really doesn't make sense with negation.
(I surely did)

> 
> 
> Best regards,
> 
>             Krzysztof Olêdzki

Cheers,

Samuel
