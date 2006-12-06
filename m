From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Wed, 06 Dec 2006 11:25:58 +0100
Message-ID: <45769AB6.8090403@trash.net>
References: <200611300943.kAU9hhUn013373@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611300943.kAU9hhUn013373@toshiba.co.jp>
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
> Hi, all,
> 
> This patch series enables to unify matches/targets of ip[6]tables.
> 
> I've changed the only parts to unify register_{match,target} and
> moves duplicated functions to a file. Unfortunately, I had to change some
> arguments of the traditional APIs for them, but they are to avoid
> warning on compilation.
> 
> It might not be good time to submit this because of recent patch rush
> and it's just before next release of iptables, so it's just RFC this time.

I just released 1.3.7, so I think we could add this now.

Since the next version will be more than just a bugfix release,
one thing I wanted to bring up for some time ..

We currently have lots of extensions in iptables for non-mainline
matches and targets, some obsolete, some already decided against
merging and some that might be merged in the future. For the
extensions belonging to a feature that won't be merged, the same
argument applies as to POM, they increase the maintenance burden
and should really be maintained along with the kernel patch (and
pom already supports patching iptables).

More problematic are extensions for stuff that might get merged.
In many cases so far they were included by distributors if
compiled by default, but when merging a feature we often noticed
that the ABI had problems like 32/64 bit issues and needed to be
changed before merging, which effectively broke compatibility.
I think it would be preferable to have people wait until their
distribution releases a new version to use a new feature than
have strange and unexplained errors.

So, what I'm proposing is to remove all extensions that are
neither part of 2.4 or 2.6 from iptables, pushing those for
externally maintained patches to the patch maintainers, those
for patches maintained in pom to pom, and delete the rest.

Comments?
