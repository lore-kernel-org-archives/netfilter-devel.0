From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4/2.6]: TTL target
Date: Mon, 26 Jul 2004 02:09:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41044BAC.7060705@trash.net>
References: <1400.192.168.1.16.1090797821.squirrel@192.168.1.16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <1400.192.168.1.16.1090797821.squirrel@192.168.1.16>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Nicolas,

Nicolas Bouliane wrote:
> Hi guys,
> 
> We attached three patches that fixe some problems with the TTL target.
> 
> 1) When using a value > 255 or < 0, there's an overflow with
>    u_int8_t value;
> 
>    This means that giving 256 as a value will create a rule with
>    a value of 0.
> 
>    The first patch adds some error controls in TTL library avoiding this.
> 
> 2) There is a little, but significative, bug in the TTL target module.
>    Instead of decreasing the TTL, this is increasing it.
> 
>    The second patch is for 2.4
> 
> 3) Same as second patch, but for 2.6
> 
> Let us know if there is some problems. Thanks you.

The kernel-part is fine, the userspace has some minor problems,
see my comments below. Could you please send a new version ?

Thanks,
Patrick

> 
> Patches below.
> 
> Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>
> 
> 
> diff -urpN extensions/libipt_TTL.c.orig extensions/libipt_TTL.c
> --- extensions/libipt_TTL.c.orig	2004-07-24 21:17:24.000000000 -0400
> +++ extensions/libipt_TTL.c	2004-07-25 18:00:39.000000000 -0400
> @@ -24,9 +24,9 @@ static void help(void)
>  {
>  	printf(
>  "TTL target v%s options\n"
> -"  --ttl-set value		Set TTL to <value>\n"
> -"  --ttl-dec value		Decrement TTL by <value>\n"
> -"  --ttl-inc value		Increment TTL by <value>\n"
> +"  --ttl-set value		Set TTL to <value 0-255>\n"
> +"  --ttl-dec value		Decrement TTL by <value 1-255>\n"
> +"  --ttl-inc value		Increment TTL by <value 1-255>\n"
>  , IPTABLES_VERSION);
>  }
> 
> @@ -35,7 +35,8 @@ static int parse(int c, char **argv, int
>  		struct ipt_entry_target **target)
>  {
>  	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
> -	u_int8_t value;
> +   u_int16_t value;
> +   u_int8_t alpha;

^^^ Indentation is broken, we use tabs not spaces

> 
>  	if (*flags & IPT_TTL_USED) {
>  		exit_error(PARAMETER_PROBLEM,
> @@ -49,28 +50,36 @@ static int parse(int c, char **argv, int
>  	if (check_inverse(optarg, &invert, NULL, 0))
>  		exit_error(PARAMETER_PROBLEM,
>  				"TTL: unexpected `!'");
> -
> -	value = atoi(optarg);
> -
> +
> +   if ((strlen(optarg) > 3) ||
> +      (sscanf(optarg, "%hd%c", &value, &alpha) != 1))

^^^ Why scan for characters and check for exactly one parsed item ?
     Use string_to_number with 0-255 as limit.

> +      exit_error(PARAMETER_PROBLEM,
> +            "TTL: Invalid value");
> +
>  	switch (c) {
> 
>  		case '1':
> +         if (value > 255) {
> +            exit_error(PARAMETER_PROBLEM,
> +               "TTL: Invalid value");
> +         }
> +
>  			info->mode = IPT_TTL_SET;
>  			break;
> 
>  		case '2':
> -			if (value == 0) {
> -				exit_error(PARAMETER_PROBLEM,
> -					"TTL: decreasing by 0?");
> +         if (value > 255 || value < 1) {
> +   			exit_error(PARAMETER_PROBLEM,
> +					"TTL: Invalid value");
^^^ The old message contained more information

>  			}
> 
>  			info->mode = IPT_TTL_DEC;
>  			break;
> 
>  		case '3':
> -			if (value == 0) {
> +         if (value > 255 || value < 1) {
>  				exit_error(PARAMETER_PROBLEM,
> -					"TTL: increasing by 0?");
> +   				"TTL: Invalid value");
>  			}
> 
>  			info->mode = IPT_TTL_INC;
> 
> 
> 
