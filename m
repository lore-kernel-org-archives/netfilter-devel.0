From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Wed, 06 Apr 2005 17:03:05 +0100
Message-ID: <42540839.8020405@ufomechanic.net>
References: <424747D5.8060500@eurodev.net> <42502B1B.7090309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42502B1B.7090309@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>> I sent this patch to Krisztian Kovacs some time ago in private but 
>> forgot to post it in mailing list. It is currently used by ct_sync.
>>
>> BTW, I also ported this to nf_conntrack some time ago:
>>
>> https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018219.html 
>>
>>
>> I guess that such patch doesn't apply anymore since Rusty's changes. 
>> If I ported it again, could it be merge to the nf_conntrack tree or 
>> better wait until it's pushed forward?
> 
> I think it would be better to wait to avoid delaying both.
> Is there already a user of this API for nf_conntrack?

It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) 
requires ct-event (although this is not listed in the pom-ng dependancies).

Pablo, can you confirm this?

Are these changes of Rusty likly to have been applied to the released 
kernel or to ip_tables?

Although this patch is against 2.6.11, are there any strong reasons for 
it to fail on 2.6.10? I ask because the layer 7 pattern matching which 
I'm also using is reported to leak memory with 2.6.11.

Right now ct-event fails badly to apply to 2.6.10 with context like:
  IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
missing entirely from the file-to-be-patched, but which is present in 
the 2.6.11 version.

Is there any sane route to getting Pablo's nfnetlink-ctnetlink-0.13 
applied to 2.6.10?

Looks like I'm bound to 2.6.11 and try and get nfnetlink-ctnetlink-0.13 
to apply, unless I have misunderstood something.

Thanks

Amin
