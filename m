From: Patrick McHardy <kaber@trash.net>
Subject: Re: ENOBUFS in nfq under heavy load
Date: Tue, 17 Jul 2007 18:14:22 +0200
Message-ID: <469CEADE.9080104@trash.net>
References: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>	<469CE69A.9010509@trash.net>
	<717e7cba0707170913t39a335beod068a9670e55808f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-1?Q?Stanis=B3aw_Pitucha?= <viraptor@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707170913t39a335beod068a9670e55808f@mail.gmail.com>
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

Stanis=B3aw Pitucha wrote:
>
> On 7/17/07, Patrick McHardy <kaber@trash.net> wrote:
>> Which kernel version? What exactly do you mean with "it stops"?
>
> 2.6.21.5 generic, stock - no patches
>
> By stops I mean that it hangs on nfq_destroy_queue() if there was
> ENOBUFS before.

Please try to find out what the kernel is doing using sysrq.

> When I connected gdb to it I got the stacktrace from the first post.
> When I break it with ctrl+c, I get:
>
> NFNETLINK answers: No such device
>
> on console and program quits.
>

ENODEV can happen when sending a verdict for or unbinding a non-existant
queue.
