From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Wed, 08 Dec 2004 19:44:42 +0100
Message-ID: <41B74B9A.8090609@trash.net>
References: <1102503533.3363.48.camel@uganda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <1102503533.3363.48.camel@uganda>
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

Evgeniy Polyakov wrote:

>Since OSF originally was created in 2.5 environment 
>it is strange not to have 2.6 support for OSF.
>This(similar) patch was sent some time ago but was lost.
>Please apply.
>  
>
Please send patches that apply -p1 in the patch-o-matic-ng directory
in the future. Your patch doesn't apply at all:

~/src/nf/svn/netfilter/trunk/patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter$ 
patch -p6 </tmp/ipt_osf --dry-run
missing header for unified diff at line 3 of patch
(Stripping trailing CRs from patch.)
patching file ipt_osf.c
Hunk #1 succeeded at 52 with fuzz 2.
Hunk #2 FAILED at 77.
Hunk #3 FAILED at 154.
Hunk #4 FAILED at 185.
Hunk #5 FAILED at 414.
Hunk #6 FAILED at 603.
Hunk #7 FAILED at 616.
Hunk #8 FAILED at 636.
Hunk #9 FAILED at 855.
8 out of 9 hunks FAILED -- saving rejects to file ipt_osf.c.rej

To make osf fit for 2.6, you also need to handle non-linear skbs.

Regards
Patrick
