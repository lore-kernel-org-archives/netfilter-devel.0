From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Mon, 06 Jan 2003 16:33:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E19A1D8.7080605@trash.net>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr>        <20030106020219.GC423@comet.rv-int>        <3E193B0E.9030602@trash.net> <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Costa Tsaousis <costa@tsaousis.gr>
In-Reply-To: <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Costa Tsaousis wrote:

>Patrick McHardy said:
>  
>
>>I did, here is the (untested) patch, hopefully i didn't miss any.
>>I didn't change any of the "save"-functions, this patch just replaces
>>all uses
>>of optarg after check_inverse by argv[optind-1].
>>    
>>
>
>I didn't test it, but keep in mind that the ! in certain cases has to be
>placed *before* the argument and its value.
>
>For example:
>
>--uid-owner ! squid
>
>is not accepted either ("user '!' not found"). The correct is:
>
>! --uid-owner squid
>  
>
In fact ! is used in many matches in a non-boolean context.
After the patch is applied, both it always possible
(! --uid-owner xxx / --uid-owner ! xxx).
It would still be nice to have the helptexts unified concerning
the use of '!', i think.

Regards,
Patrick
