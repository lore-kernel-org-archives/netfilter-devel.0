From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: when IPVS into netfilter?
Date: Sun, 11 May 2003 22:04:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBEACBC.2090202@wanadoo.es>
References: <3EB44BE7.3070602@wanadoo.es> <3EBCE288.5020801@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Roberto Nibali wrote:

> I think not for 2.4.x because we're changing too much of the
> netfilter/routing code to make it a smooth and acceptable merge. There
> is also some code most people use which is completely not acceptable
> within the scope of routing extensions (like the hidden patch or some
> DGD code).

I can't understand this, the code is not ready for to put into kernel but
it is ready for enterprise use ;-)

> For 2.5 it is already too late, feature freeze was already called in and
> we haven't talked to the netfilter people anyways ;).

well, never is too late for 2.5. A lot of features were included into
latest 2.4.xx. And ,in theory, it is more frozen than a penguin at north pole.

> Another point is that we (Wensong the most) never felt the urge to
> submit the code to the networking maintainers for approval and
> inclusion. At OLS 2000, Wensong, Horms, Rusty, me and some others talked
> about a possible inclusion of LVS into netfilter. It simply never
> happened because noone felt about doing more than talking of it.

if the code is not into the kernel, then it's little useful. Because
not all people are kernel hackers and they need official distribution
support. And custom kernels are not supported.

> Yet another point is that we never really agreed on having someone being
> the lead developer and responsible for a possible kernel inclusion and
> most of us simply do not have the time to be a maintainer. It's a tough
> and time consuming job even if the code works for 99.999% of the people.

It is not necessary to have a leader, bugs must go to mailing-list.

> You have to talk to other involved parties, you have to monitor API
> changes and you will need to be responsive to an increasing amount of
> emails addressed directly to you (for example package responsibles for a
> distribution), because you're in the MAINTAINERS list.

well, ipvs has 5 years of history. Versions are released every XX time.
Red Hat has sold 6.2 and next distributions with ipvs patch.
It works! And how many headaches has you gotten?

> Last but not least it is pretty easy to patch your kernel with LVS,
> There are as few as possible changes to the existing code, most of the
> patch is in form of additional code.

it is easy to patch kernel, for me it's not a problem.
But now LiNUX is not only a hacker OS, there are places where you need
to have distribution support because the boss wants it :-)

-thanks for your time-

regards,
-- 
Galiza nin perdoa nin esquence. Governo demision!
