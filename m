From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Tue, 15 Feb 2005 23:23:08 +0800
Message-ID: <200502152323.11942.fabrice@netfilter.org>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<200502030010.47260.fabrice.marie@fma-rms.com>
	<Pine.LNX.4.62.0502150219100.17929@bizon.gios.gov.pl>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0502150219100.17929@bizon.gios.gov.pl>
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


Hello,

On Tuesday 15 February 2005 09:20, Krzysztof Oledzki wrote:
> Any progress? ;-)

Yep. Sorry for the delay. The patch looks alright although I didn't test it.

As for the rest of the thread, right now like Brad mentioned, you need
2 rules to match the time period:
> To match 20:00 - 4:00 you currently need 2 rules:
>  1) match 20:00 - 23:59
>  2) match 0:00 - 4:00
> What I'm proposing is to allow this to be reduced to one rule.

The cleanest way to solve that in my opinion is to implement
the negative form of time match, in other words, to allow the usage
of the negative option (!) in the time match which is right now not allowed.
It shouldn't be very straight forward. On the other hand, this will require an additional
variable in the time structure passed from userspace to kernelspace,
and this would break binary compatibility with previously built iptables userpace
programs. But if you ask me, patches on extensions like ipt_time shouldn't bother
too much about backward compatibility headaches, since they are not shipped
in the kernel by default (and I guess never will). Backward compatibility for
standard-kernel-modules is important though.

Sorry again for the delay,

Have a nice day,

Fabrice.
--
"Silly hacker, root is for administrators" 
       -Unknown
