From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Counter problem in a new nat target.
Date: Wed, 10 Dec 2003 12:15:48 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312101211500.9708-100000@filer.marasystems.com>
References: <3FD6FCB5.20205@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Jesse Peng <jesse@deansoft.com.tw>,
   KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FD6FCB5.20205@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Dec 2003, Emmanuel Guiton wrote:

> Thus, if I could get a pointer to this user data when decreasinging my 
> counters, the problem would be solved.

Won't work, and very dangerous.

You should maintain the storage within your module, and then add pointers 
to this to conntrack and the target userinfo.

> I don't think it really fits in the ip_conntrack_destroyed function but
> why not in the notifier function?

They are the same, and both fits well (except that ip_conntrack_destroyed 
is reserved for use by NAT).

> What about modifying the conntrack notifier system so that it includes
> also a pointer to the user data, or then make a brand new notifier
> system (because at first sight I don't see how to include a pointer to
> the user data in the current conntrack notifier system)?

You don't. You need to store the information you need in the conntrack if 
it cannot be derived from the addressing information or other information 
already present in conntrack.

I would really recommend you to extend conntrack with a custom field for 
the purpose than to abuse the helper slots.

Regards
Henrik
