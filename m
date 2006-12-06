From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Wed, 06 Dec 2006 18:40:19 +0100
Message-ID: <45770083.306@trash.net>
References: <200611300943.kAU9hhUn013373@toshiba.co.jp>	<45769AB6.8090403@trash.net>
	<200612061233.kB6CXNxL024591@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200612061233.kB6CXNxL024591@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 06 Dec 2006 11:25:58 +0100
> 
>>So, what I'm proposing is to remove all extensions that are
>>neither part of 2.4 or 2.6 from iptables, pushing those for
>>externally maintained patches to the patch maintainers, those
>>for patches maintained in pom to pom, and delete the rest.
> 
> 
> I agree.
> 
> 
>>Comments?
> 
> 
> 'make' should test whether kernel supports extensions or not.

Yes, that would be an alternative (currently some do, some don't).
But the testing and maintenance problems would still persist.

> Do distributors manually change -test[6] scripts and build them
> these days ? Or you mean that distributors apply kernel patch to their
> kernel as well ? In later case, that means that they definitely want to
> support features. Then even if we moves them from source tree of iptables,
> I think they will apply them and same things will happen.

The later. In that case its out of our control of course, but currently
we are encouraging it by building unsupported extensions by default.

> But anyway, I think it's good idea to move extensions which is not
> supported by mainline kernel.

I'm going to go over them in the next days and make a list of those
to be deleted/pushed to patch maintainers.
