From: Maximilian Wilhelm <max@rfc2324.org>
Subject: ct_sync-multigroup (was: Re: Made ct_sync running with 2.6.15.4...)
Date: Wed, 5 Apr 2006 01:37:45 +0200
Message-ID: <20060404233745.GA26006@rfc2324.org>
References: <20060311033122.GA23805@galois.math.uni-paderborn.de>
	<200603192258.27950@krak>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200603192258.27950@krak>
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

Am Sonntag, den 19. M?rz hub KOVACS Krisztian folgendes in die Tasten:

Hi!

[...]
>   However, merging these changes to SVN would still need some more work. 
> As the number of people working on ct_sync is very close to zero at the 
> moment, I think that all effort should be concentrated on a single branch 
> of the code. Because Harald has already put significant effort into 
> providing support for active-active setups I think that we should try and 
> get the linux-2.6-multigroup branch working first. Holger Eitzenberger 
> was also doing some tests using that version and provided multiple fixes 
> for problems he had found.

>   So I don't think we should put significant amount of work into updating 
> the old 2.6.10 branch. Instead, please give the -multigroup branch a try 
> and provide feedback.

I wanted to give it a shot and updated most of the patches to fit to
2.6.17-rc1 (as in the git version of linus kernel from some hours ago).
A diff against the svn.netfilter.org version can be found at [42].

I'm experiencing some lack of "knowledge" about the newest *tables ->
x_tables chances and want to ask if someone allready has put some effort
into updating the patches/code.

If someone did, I would love to get/test/use the updates :)

If not, I will try to fix this myself these days, but I don't know if I
will be able to do so even though git makes things easier.

> Of course if you think you have the time to prepare 
> an easily-committable patch for the linux-2.6 branch of ct_sync I'll be 
> more than happy to update the SVN repository. I'm just unwilling to spend 
> a significant amount of time updating that old branch.

At [42] there are still working patches for the "plain" ct_sync branch :)
(I splitted the patch in -fix and -cleanup)

[42] http://vvv.barbarossa.name/files/ct_sync/

Ciao
Max
-- 
	Follow the white penguin.
