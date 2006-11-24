From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat tree updated
Date: Fri, 24 Nov 2006 07:24:33 +0100
Message-ID: <45669021.8060109@trash.net>
References: <4565C47E.3030907@trash.net>
	<Pine.LNX.4.64.0611240036380.21966@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611240036380.21966@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> There is a locking bug in the nat-core[2].patch I sent to the list:
> 
> @@ -659,7 +695,12 @@
>                 return NULL;
>         }
>  
> -       conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto);
> +       read_lock_bh(&nf_conntrack_lock);
> +       exp = find_expectation(tuple);
> +       read_unlock_bh(&nf_conntrack_lock);
> 
> find_expectation finds *and* deletes the expectation from the list so 
> write locking is required here.

I'll fix it up, thanks.

>>A few questions:
>>
>>- this seems like a good chance to get rid of the helper naming
>>  inconsistencies (nf_conntrack_helper_* vs nf_conntrack_*).
>>  Should we rename all helpers to nf_conntrack_helper_XXX? We
>>  have to provide module aliases for the old names anyway ..
> 
> 
> All helper modules are named as nf_conntrack_*. Only the file naming is 
> inconsistent. Or do you propose to rename all nf_conntrack_foo helper 
> module to nf_conntrack_helper_foo?

I mainly want to get rid of the inconsistent file naming, but unless
we add lots of special rules to the Makefile, that will affect the
module names as well.

>>- /proc-compatibility: since the plan is to get rid of the
>>  old IPv4-only connection tracking ASAP, we need to think
>>  of something to keep old scripts fiddling with /proc-files
>>  working. So we probably need to do some symlinking (is that
>>  possible?) of the old net/ipv4/netfilter files or just keep
>>  the around as normal files. 
> 
> 
> As I see symlinking is not possible, so we have to keep the old files.
> 
> 
>>  And we need a /proc/net/ip_conntrack that only shows IPv4 entries I 
>>  suppose.
> 
> 
> Yes! Missing /proc/net/ip_conntrack could break a lot of scripts.

I'll take care of the proc files.
