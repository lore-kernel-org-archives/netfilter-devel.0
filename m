From: Patrick Schaaf <bof@bof.de>
Subject: possible race in init_conntrack()?
Date: Tue, 2 Jul 2002 11:14:51 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702111451.D7684@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi devel,

please have a look at init_conntrack(), in ip_conntrack_core.c.

        static unsigned int drop_next = 0;
	...
	if (drop_next >= ip_conntrack_htable_size)
		drop_next = 0;
	if (!early_drop(&ip_conntrack_hash[drop_next++])

I see no locking around drop_next. init_conntrack() is entered
from ip_conntrack_in(), and that can run on two CPUs at the
same time, right? Then the following story seems possible (though
very unlikely):

Let drop_next be ip_conntrack_htable_size-1.
CPU0 does the bounds check, it passes.
CPU1 does the bounds check, it passes.
CPU0 writes back the incremented value.
CPU1 for whatever reason, CPU1 rereads the incremented value, and happily
accesses ip_conntrack_hash[ip_conntrack_htable_size].
Boom (very faint, very low frequency, but Boom).

Did I overlook something? Making drop_next atomic_t should be a good fix.

best regards
  Patrick
