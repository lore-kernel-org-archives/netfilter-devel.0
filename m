From: Nuutti Kotivuori <naked@iki.fi>
Subject: tcp-window-tracking for 2.6? (Re: [PATCH] patch-o-matic-ng
 reorganization and updated patches)
Date: Thu, 19 Feb 2004 21:22:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87vfm27u28.fsf@iki.fi>
References: <Pine.LNX.4.33.0402191309230.14327-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> Upcoming modifications:

[...]

> - 2.6 ports of tcp-window-tracking and conntrack_foo patches

I am personally very interested in the state of the
tcp-window-tracking patch, especially for 2.6 kernels. It is very nice
to know it is being ported for 2.6.

What I would be doing would either be a patch that depends on the
tcp-window-tracking patch to work at all - or it would do something
similar itself which would most probably make it conflict with the
tcp-window-tracking patch.

Does anyone know of the status it? How far is it from being integrated
into the mainline netfilter? Are there any blocking issues why it
cannot be or will not be integrated?

Thanks,
-- Naked
