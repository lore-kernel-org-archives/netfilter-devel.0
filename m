From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Wed, 08 Dec 2004 19:48:44 +0100
Message-ID: <41B74C8C.20607@trash.net>
References: <1102503533.3363.48.camel@uganda> <1102503753.3363.50.camel@uganda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <1102503753.3363.50.camel@uganda>
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

>On Wed, 2004-12-08 at 13:58 +0300, Evgeniy Polyakov wrote:
>  
>
>>Since OSF originally was created in 2.5 environment 
>>it is strange not to have 2.6 support for OSF.
>>This(similar) patch was sent some time ago but was lost.
>>Please apply.
>>
>>Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
>>    
>>
>
>My dear hands, please contact my brain before doing anything.
>Thanks.
>  
>
And I need to read first before complaining :)

>Proper patch attached.
>  
>
Still doesn't apply, it seems to be present already. The latest
change was two month ago.

~/src/nf/svn/netfilter/trunk/patch-o-matic-ng$ patch -p1 </tmp/pom.diff  
--dry-run
(Stripping trailing CRs from patch.)
patching file osf/info
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file osf/info.rej
The next patch would create the file 
osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h,
which already exists!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h.rej
The next patch would create the file 
osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c,
which already exists!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c.rej
The next patch would create the file 
osf/linux-2.6/net/ipv4/netfilter/Kconfig.ladd,
which already exists!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
osf/linux-2.6/net/ipv4/netfilter/Kconfig.ladd.rej
The next patch would create the file 
osf/linux-2.6/net/ipv4/netfilter/Makefile.ladd,
which already exists!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
osf/linux-2.6/net/ipv4/netfilter/Makefile.ladd.rej

Anyhow, it still needs to handle non-linear skbs. Have a look
at the other matches and their use of skb_header_pointer.

Regards
Patrick
