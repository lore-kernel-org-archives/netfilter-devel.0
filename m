From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Sat, 11 Jan 2003 19:36:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E20644A.9020001@fugmann.dhs.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <20030110131315.GS1353@sunbeam.de.gnumonks.org> <3E1ECF6B.5080109@fugmann.dhs.org> <200301111713.25263.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@gnumonks.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200301111713.25263.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Bart De Schuymer wrote:
> On Friday 10 January 2003 14:49, Anders Fugmann wrote:
> 
>>One thing I have noticed is that the module usage count for 'ip_tables'
>>gets incremented twice when loading a module that depends on the
>>ip_tables module. Unloading the module again also decrements usage count
>>on ip_tables with 2. This happens both on vanilla 2.5.55 and 2.5.55 with
>>the patch applied. It does not happen on 2.4.20 though.
> 
> 
> It seems the generic module code already increments the usage count. The 
> iptables code also increments it, so that results in +2.
Yes. I think that this will be cured by removing all MOD_INC_USE_COUNT
(see below).
> 
> 
>>One question. Why is the module count increased (code wise) whenever a
>>new module is loaded, that depends on the current module? Eg. When
>>loading ipt_MARK, the module count for ip_tables is increased. The
>>dependancies are still kept by the kernel so ip_tables cannot be
>>unloaded anyhow.
> 
> 
> It's in Rusty's FAQ for his new module scheme: 
> http://www.kernel.org/pub/linux/kernel/people/rusty/modules/FAQ
> MOD_INC_USE_COUNT is deprecated and should be removed.
> 
> Your patch has some problems:
> 
> -       MOD_INC_USE_COUNT;
> +       try_module_get(THIS_MODULE);
> 
> (see above)
Thanks. I will make an update to the patch.
(In which basically all MOD_INC_USE_COUNT and MOD_DEC_USE_COUNTS will be 
removed.)

> 
> 
> -       if (match->me)
> -               __MOD_INC_USE_COUNT(match->me);
> +       try_module_get(match->me);
I will see how this can be done. The probem is not rerutning the error, 
but rather handling it correctly (Reporting back to userspace that a 
module could not be loaded or is beeing loaded).

Regards
Anders Fugmann
