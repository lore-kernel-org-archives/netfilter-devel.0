From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Wed, 2 Jun 2004 07:13:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040602051338.GA18783@alpha.home.local>
References: <Pine.LNX.4.33.0406011128390.4755-100000@blackhole.kfki.hu> <40BC760B.4010705@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <40BC760B.4010705@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Tue, Jun 01, 2004 at 02:26:51PM +0200, Pablo Neira wrote:
> Jozsef, I attached a patch to this email to clean up the way we handle 
> trimmed off FIN packets, let me know if it's worth it. Still one 
> question, should we update the timeout in this case?

I like your cleanup with the notion of "commit", it's much cleaner than
changing things then repairing them afterwards. You're right IMHO, if we
ignore a packet, we should not update the timeout.

BTW, there's something else we could change. There are several fields
that we have re-used and abused to store information during evolution.
For example, 'stored_seq' is used to maintain the combination of flags seen
last ! Not very obvious from the name, and we could change it to something
more consistent with other names, such as 'last_index' or 'last_flags'.
Perhaps we should audit all these variables again and propose to change
a few names to something more explicit ? And we could use unions when
some field are shared for several purpose. Another example, stored_seq
is between 0 and 4 or 5 (don't remember, sorry), and last_dir is only
0 or 1, state is <13... Well, 8 bits are enough to store these 3 fields
together in an efficient way (we would have to adjust some #defines so
that we avoid bit shifts). The same is true for 'loose' and 'flags' in
struct ip_ct_tcp_state. With proper arrangement and due to alignment
constraints we could save 4 or 8 bytes. Well, perhaps I'm going too far
again :-)

Regards,
willy
