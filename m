From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix twin tos argument.
Date: Mon, 20 Dec 2004 15:58:25 +1100
Message-ID: <1103518705.15405.0.camel@localhost.localdomain>
References: <35966.66.11.161.14.1103492451.squirrel@66.11.161.14>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <35966.66.11.161.14.1103492451.squirrel@66.11.161.14>
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

On Sun, 2004-12-19 at 16:40 -0500, Nicolas Bouliane wrote:
> I was writing an nfsim .sim for the match tos, when I realized that
> when
> we enter --tos twice the second overwrite the first.

Applied.

Thanks!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
