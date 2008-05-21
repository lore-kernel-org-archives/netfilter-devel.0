From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 10:25:51 -0400
Message-ID: <dd45289d0805210725r4409b860if06bc8adb68059be@mail.gmail.com>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
	 <4833F119.7080206@netfilter.org>
	 <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>
	 <48342C03.10204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:20652 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYEUOZx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 10:25:53 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2611074rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 07:25:51 -0700 (PDT)
In-Reply-To: <48342C03.10204@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

It fixed the strdup(). But now:

cc1: warnings being treated as errors
read_config_lex.c: In function 'yylex':
read_config_lex.c:3846: warning: label 'find_rule' defined but not used
make[1]: *** [read_config_lex.o] Error 1


if I strip this label (find_rule), then I get:

read_config_lex.c:3593: warning: 'yy_full_match' defined but not used
make[1]: *** [read_config_lex.o] Error 1
make[1]: Leaving directory `/usr/local/src/conntrack-tools/src'
make: *** [all-recursive] Error 1


If I remove this function (yy_full_match), then I get:

cc1: warnings being treated as errors
read_config_lex.c: In function 'yylex':
read_config_lex.c:3782: warning: 'yy_act' may be used uninitialized in
this function
make[1]: *** [read_config_lex.o] Error 1

If I initialize this var (register int yy_act = 0;), then I get:

everything compile now.

I'm using a version I compiled without the -Werror flag, it was more clean.

Nick



On Wed, May 21, 2008 at 10:04 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> NICOLAS BOULIANE wrote:
>> Hi,
>>
>> thank you for your comments.
>> ---
>>
>> Pablo:
>>
>> cc1: warnings being treated as errors
>> read_config_lex.l: In function 'yylex':
>> read_config_lex.l:113: warning: incompatible implicit declaration of
>> built-in function 'strdup'
>> read_config_lex.l:114: warning: incompatible implicit declaration of
>> built-in function 'strdup'
>> read_config_lex.l:115: warning: incompatible implicit declaration of
>> built-in function 'strdup'
>> read_config_lex.l:126: warning: incompatible implicit declaration of
>> built-in function 'strdup'
>> read_config_lex.c:3845: warning: label 'find_rule' defined but not used
>> make[1]: *** [read_config_lex.o] Error 1
>>
>> I get this while compiling the last git snapshot
>> probably string.h is missing ?
>
> Does the patch attached fix it?
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>
> diff --git a/src/read_config_lex.l b/src/read_config_lex.l
> index eb3368a..7daaeab 100644
> --- a/src/read_config_lex.l
> +++ b/src/read_config_lex.l
> @@ -19,6 +19,8 @@
>  * Description: configuration file syntax
>  */
>
> +#include <string.h>
> +
>  #include "read_config_yy.h"
>  %}
>
>
>
