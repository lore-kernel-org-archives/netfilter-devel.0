From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Wed, 06 Dec 2006 21:33:21 +0900 (JST)
Message-ID: <200612061233.kB6CXNYs016271@toshiba.co.jp>
References: <200611300943.kAU9hhUn013373@toshiba.co.jp>
	<45769AB6.8090403@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <45769AB6.8090403@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 06 Dec 2006 11:25:58 +0100

> I just released 1.3.7, so I think we could add this now.
> 
> Since the next version will be more than just a bugfix release,
> one thing I wanted to bring up for some time ..

I see, I'll keep rebase my tree.

> We currently have lots of extensions in iptables for non-mainline
> matches and targets, some obsolete, some already decided against
> merging and some that might be merged in the future. For the
> extensions belonging to a feature that won't be merged, the same
> argument applies as to POM, they increase the maintenance burden
> and should really be maintained along with the kernel patch (and
> pom already supports patching iptables).

Indeed, actually I had no way to do build test for some extensions with my
unification patches due to no kernel patches, then I pretended
I didn't see :)

> More problematic are extensions for stuff that might get merged.
> In many cases so far they were included by distributors if
> compiled by default, but when merging a feature we often noticed
> that the ABI had problems like 32/64 bit issues and needed to be
> changed before merging, which effectively broke compatibility.
>
> I think it would be preferable to have people wait until their
> distribution releases a new version to use a new feature than
> have strange and unexplained errors.
>
> So, what I'm proposing is to remove all extensions that are
> neither part of 2.4 or 2.6 from iptables, pushing those for
> externally maintained patches to the patch maintainers, those
> for patches maintained in pom to pom, and delete the rest.

I agree.

> Comments?

'make' should test whether kernel supports extensions or not.
Do distributors manually change -test[6] scripts and build them
these days ? Or you mean that distributors apply kernel patch to their
kernel as well ? In later case, that means that they definitely want to
support features. Then even if we moves them from source tree of iptables,
I think they will apply them and same things will happen.

But anyway, I think it's good idea to move extensions which is not
supported by mainline kernel.

-- Yasuyuki Kozakai
