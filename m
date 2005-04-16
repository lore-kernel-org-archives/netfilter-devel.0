From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: struct nf_sockopt_ops
Date: Sat, 16 Apr 2005 16:31:24 +0200
Message-ID: <426121BC.2040808@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Forgive me if that has already been discussed.

I'm wondering why the get and set members of the struct take
some form of int as last parameter. Wouldn't be a long be the
more logical choice? I can see changing the type here wouldn't
help because nf_sockopt also accepting only an int for len.

struct nf_sockopt_ops
{
/* snip */
        int (*set)(struct sock *sk, int optval, void __user *user, unsigned int len);
/* snip */
        int (*get)(struct sock *sk, int optval, void __user *user, int *len);
/* snip */
};

Or at least the last parameter of the set member being a
signed int to match the parameter to nf_sockopt.

Any insight into why the parameters were chosen that way
would be truly appreciated.


Regards,
Carl-Daniel
