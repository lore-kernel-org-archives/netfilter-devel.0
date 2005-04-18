From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 07:22:07 -0400
Message-ID: <876ef97a050418042210d7779e@mail.gmail.com>
References: <20050418171657.0370.LARK@linux.net.cn>
	<876ef97a05041802571f302bfe@mail.gmail.com>
	<426393C7.1020006@ufomechanic.net>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <426393C7.1020006@ufomechanic.net>
Content-Disposition: inline
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

On 4/18/05, Amin Azez <azez@ufomechanic.net> wrote:
> What I found confusing initially was that "put" in "ip_conntrack_put"
> means "release" or "refcount--" instead of "write" or "store" which
> would have been my first guess.

In the Linux kernel sources, *_get() usually increments a reference
count on an object, and *_put() decrements it. This is a common naming
convention, although I can see how it could be confusing.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
