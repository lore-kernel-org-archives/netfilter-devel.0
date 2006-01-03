From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Tue, 03 Jan 2006 13:10:58 +0100
Message-ID: <43BA69D2.8020703@trash.net>
References: <925A849792280C4E80C5461017A4B8A26D46@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A26D46@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
> Yup, the h323 modules are broken.  The h323 modules reference a function
> named ip_conntrack_expect_free.  But searching through the entire kernel
> and POM source trees, I find no reference to any files named similarly.
> And searching through the netfilter-devel archives from Dec. 2005
> through June 2005, I find no mention of this string.  Have I hit a brick
> wall or can I remove the references to this function in the effected
> h323 modules?  If yes, I will even try my hand at making a patch.

Expectations are now reference counted, which means you need to
use ip_conntrack_expect_put(). Beware that the semantic has changed,
you need to put every expectation, independant of the success of
ip_conntrack_expect_register(). IIRC the H323 helper has a few other
critical problems, it doesn't set expectfn to NULL in the H.245 helper
(which crashes when the NAT helper is not loaded) and also doesn't
initialize the flags member in the expectation (needs to be 0).

I have a majorly reworked version for some older kernel, it doesn't
compile currently, but I plan to continue working on it in the
near future.
