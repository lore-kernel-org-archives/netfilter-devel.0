From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Wed, 16 Feb 2005 23:24:54 +0800
Message-ID: <200502162324.55174.fabrice@netfilter.org>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<200502152323.11942.fabrice@netfilter.org>
	<Pine.LNX.4.62.0502151647350.16076@bizon.gios.gov.pl>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0502151647350.16076@bizon.gios.gov.pl>
Content-Disposition: inline
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


Hi,

On Tuesday 15 February 2005 23:58, Krzysztof Oledzki wrote:
> True. Talking about negation of -m (match). Excuse me for my question, 
> maybe this is obvious, but.. why we don't have a negation for -m 
> (match) like for -p (protocol)?

There is one actually. If you look at the existing code of libipt_time.c
you'll see that I explicitly prevented the negation operator long time ago.
But it's very straight forward to enable it, and implement a check
in kernelspace to see if the match is negated or not prior to doing the matching.

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
