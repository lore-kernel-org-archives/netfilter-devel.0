From: Max Kellermann <max@duempel.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Tue, 8 Feb 2005 16:26:20 +0100
Message-ID: <20050208152620.GA30780@roonstrasse.net>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
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

On 2005/02/08 15:59, Harald Welte <laforge@netfilter.org> wrote:
[...]
> This is because the h245 helper is not registered with the core, and
> therefore the helper_unregister() function will only be called for h245,
> but not for h245.
> 
> The proposed solution:
> 
> 1) to make ip_conntrack_core:ip_conntrack_helper_unregister() work with
>    a helper that was never registered (and thus has an empty list.next)
> 2) to have ip_conntrack_h323 unregister the h245 helper.

I think your patch regarding ip_conntrack_core.c is a workaround, that
does not look clean to me. I prefer to make H.323 register the H.245
helper with a disabled mask (only to be activated internally by
H.225), and then unregister it cleanly.

I guess your proposition (1) would make another workaround.

Max
