From: Patrick McHardy <kaber@trash.net>
Subject: Re: childlevel's pom comment
Date: Thu, 04 Mar 2004 06:33:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4046BFB9.809@trash.net>
References: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net> <40469E10.7080100@trash.net> <Pine.LNX.4.60.0403032150000.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.60.0403032150000.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matthew Strait wrote:
>>I'm going to add your updated help-text. But I have doubts about whether
>>a new match is required at all. A connection can only have a childlevel
>>of one because only masters have helpers assigned to them, although in
>>theory the expect-function could register more expectations. So you can
>>basically match if a connection was expected or not. The same can also
>>be achieved by a trivial change to the helper match, just allow
>>zero-string length and use them as a special value. This should also
>>allow full userspace compatibility. What do you think ?
> 
> 
> Sounds like a good idea.  The only variation I'd make is to have the
> helper match take "any" as the special value, because it's hard to pass an
> empty string to iptables.  (Trying to pass "" gets you an error message
> and trying to pass \"\" ends up giving the module literal quotation marks.
> If I'm missing something obvious, let me know.  Here are the changes
> needed in the kernel:
> 
> --- ipt_helper.c.old    2004-03-03 21:34:05.625216688 -0600
> +++ ipt_helper.c        2004-03-03 22:32:06.239867656 -0600
> @@ -48,7 +48,7 @@
> 
>         if (!ct->master) {
>                 DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
> -               return 0;
> +               return info->invert;
>         }
> 
>         exp = ct->master;
> @@ -68,8 +68,11 @@
>         DEBUGP("master's name = %s , info->name = %s\n",
>                 exp->expectant->helper->name, info->name);
> 
> -       ret = !strncmp(exp->expectant->helper->name, info->name,
> -                      strlen(exp->expectant->helper->name)) ^
> info->invert;
> +       if(!strcmp(info->name, "any"))
> +               ret = 1 ^ info->invert;
> +       else
> +               ret = !strncmp(exp->expectant->helper->name, info->name,
> +                              strlen(exp->expectant->helper->name)) ^
> info->invert;

I would prefer if "any" wouldn't need to be matched in the kernel,
something like:

if (info->name[0] == '\0')
	ret = !info->invert;
else
	...

and have userspace do the "any" <=> "" translation.

>  out_unlock:
>         READ_UNLOCK(&ip_conntrack_lock);
>         return ret;
> 
> 
> I have to change the 0 to info->invert so that "! --helper any" means
> "packets that aren't from any helper".  With the 0, that rule would never
> match.  It seems to me that this is the correct behavior even without
> adding the "any" special case.  If I ask for "! --helper ftp", I would
> expect master packets to match, because they are not from an ftp helper.

That is correct. Can you send a seperate patch for this, as a bugfix
this should be submitted to the kernel anyway.

> 
> Trivial documentational changes in userspace:
> 
> --- libipt_helper.c.old 2004-03-03 21:39:07.255361936 -0600
> +++ libipt_helper.c     2004-03-03 21:52:10.838861040 -0600
> @@ -15,6 +15,7 @@
>         printf(
>  "helper match v%s options:\n"
>  "[!] --helper string        Match helper identified by string\n"
> +"                           (or any helper if string is "any")\n"
>  "\n",
>  IPTABLES_VERSION);
>  }
> 
> --- iptables.8.old      2004-03-03 22:18:55.017383552 -0600
> +++ iptables.8  2004-03-03 22:20:43.137999928 -0600
> @@ -458,6 +458,8 @@
>  For other ports append -portnr to the value, ie. "ftp-2121".
>  .PP
>  Same rules apply for other conntrack-helpers.
> +.PP
> +Use "any" to match any helper.
>  .RE
>  .SS icmp
>  This extension is loaded if `--protocol icmp' is specified.  It
> 
> 
> 
> 
> If this patch is accepted, I don't see any reason to keep childlevel in
> patch-o-matic.

Can you please send a new patch which removes the "any" strcmp ?
We can ask Martin about his opinion then (he is the author of
the helper match), but I don't think there will be a problem.

Regards
Patrick

> 
> -matthew
> 
