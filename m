From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Sun, 22 Aug 2004 01:48:07 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru> <4127CCF9.2030505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: johnpol@2ka.mipt.ru, Harald Welte <laforge@netfilter.org>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4127CCF9.2030505@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 22 Aug 2004, Patrick McHardy wrote:

> How is this supposed to fix it ?

The switch from sprintf to snprintf is a good start.


>               log("%s [%s]", f->genre, f->details);
>
> -               count += sprintf(buf+count, "%s - %s[%s] : %s",
> +               err = snprintf(buf+count, __count-count, "%s - %s[%s] : %s",
>                                       f->genre, f->version,
>                                       f->subtype, f->details);
> -
> +               if (err < 0)

This should read something like follows I think:

 		  if (err < 0 || err > __count-count)

> +                       break;
> +               else
> +                       count += err;
>               if (f->opt_num)
>               {
>                       loga(" OPT: ");
>
> snprintf returns the number of characters written if n <= limit, otherwise
> the number of characters that would have been generated for the given input,
> but never < 0. You can also use vscnprintf to get the real number of bytes
> written.

There may still be systems around with old snprintf implementations 
returning -1 on overflow unless this is kernel code.

Regards
Henrik
