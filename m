From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BROKEN] ipt_ wrappers for xt_ functions (WAS: Problems
 Compiling Geoip on linux-2.6.21-rc3)
Date: Fri, 16 Mar 2007 05:10:02 +0100
Message-ID: <45FA189A.8070605@trash.net>
References: <200703080637.WAA05730@NickAndBarb.net>
	<twig.1173969394.3980@bugmachine.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, jengelh@gmx.de,
	Nick Pasich <NewsLetters@NickAndBarb.net>
To: jix@bugmachine.ca
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <twig.1173969394.3980@bugmachine.ca>
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

Samuel Jean wrote:
> How do we workaround the missing wrappers ? Another #if KERNEL_VERSION
> declarations ?

I'm afraid so. The good news is that I've planned to encapsulate the
tons of (often unused) arguments to match/target functions in a
structure, so future changes at least won't change the function
signatures anymore.
