From: Patrick McHardy <kaber@trash.net>
Subject: Re: struct nf_sockopt_ops
Date: Mon, 18 Apr 2005 00:05:05 +0200
Message-ID: <4262DD91.20203@trash.net>
References: <426121BC.2040808@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <426121BC.2040808@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Forgive me if that has already been discussed.
> 
> I'm wondering why the get and set members of the struct take
> some form of int as last parameter. Wouldn't be a long be the
> more logical choice? I can see changing the type here wouldn't
> help because nf_sockopt also accepting only an int for len.
> 
> struct nf_sockopt_ops
> {
> /* snip */
>         int (*set)(struct sock *sk, int optval, void __user *user, unsigned int len);
> /* snip */
>         int (*get)(struct sock *sk, int optval, void __user *user, int *len);
> /* snip */
> };
> 
> Or at least the last parameter of the set member being a
> signed int to match the parameter to nf_sockopt.
> 
> Any insight into why the parameters were chosen that way
> would be truly appreciated.

For compatibility. setsockopt(2):

The fifth argument of getsockopt and setsockopt is in  reality  an  int
[*]  (and  this  is what BSD 4.* and libc4 and libc5 have).  Some POSIX
confusion resulted in the present socklen_t, also used by  glibc.   See
also accept(2).

Regards
Patrick
