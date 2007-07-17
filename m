From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: Re: ENOBUFS in nfq under heavy load
Date: Tue, 17 Jul 2007 17:13:46 +0100
Message-ID: <717e7cba0707170913t39a335beod068a9670e55808f@mail.gmail.com>
References: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
	<469CE69A.9010509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469CE69A.9010509@trash.net>
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

Sorry for private mails - my bad.

On 7/17/07, Eric Leblond <e.leblond@inl.fr> wrote:
> You could simply use the limit match to avoid "heavy" load.

Not an option - I need to balance some traffic - so it will get much
more connections than that by default :/

-----

On 7/17/07, Patrick McHardy <kaber@trash.net> wrote:
> Which kernel version? What exactly do you mean with "it stops"?

2.6.21.5 generic, stock - no patches

By stops I mean that it hangs on nfq_destroy_queue() if there was
ENOBUFS before.
When I connected gdb to it I got the stacktrace from the first post.
When I break it with ctrl+c, I get:

NFNETLINK answers: No such device

on console and program quits.
