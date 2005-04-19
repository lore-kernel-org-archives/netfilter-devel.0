From: Andy Furniss <andy.furniss@dsl.pipex.com>
Subject: Re: libipt_connbytes.c bug in iptables-1.3.1
Date: Tue, 19 Apr 2005 01:21:14 +0100
Message-ID: <42644EFA.2030803@dsl.pipex.com>
References: <20050417230927.GA23821@daleka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotrek Kaczmarek <kaczorek@k.daleka.net>
In-Reply-To: <20050417230927.GA23821@daleka.net>
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

Piotrek Kaczmarek wrote:
> I've spent couple of hours seaching for a fix for this bug... can you apply the patch below?
> 
> # iptables -t mangle -A PREROUTING -m connbytes --connbytes-mode packets
> iptables v1.3.1: Unknown arg `packets'
> Try `iptables -h' or 'iptables --help' for more information.
> 
> # iptables -t mangle -A PREROUTING -m connbytes --connbytes-mode bytes
> iptables v1.3.1: Unknown arg `bytes'
> Try `iptables -h' or 'iptables --help' for more information.
> 
> There's a patch:
> 
> ########### cut
> 
> --- libipt_connbytes.c.fucked   2005-04-18 01:00:28.000000000 +0200
> +++ libipt_connbytes.c  2005-04-18 00:56:10.000000000 +0200
> @@ -93,6 +93,7 @@
>                         exit_error(PARAMETER_PROBLEM,
>                                    "Unknown --connbytes-mode `%s'", optarg);
>                 *flags |= 4;
> +               break;
>         default:
>                 return 0;
>         }
> 
> ########### cut
> 

Thanks from me aswell Piotrek - I've got connbytes back :-)

Andy.
