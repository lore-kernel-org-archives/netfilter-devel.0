From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] New behaviour for early_drop()
Date: Mon, 14 Apr 2003 13:06:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030414110617.GA24421@oknodo.bof.de>
References: <200304141140.18647.francesco@unipg.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Francesco Sportolari <francesco@unipg.it>
Content-Disposition: inline
In-Reply-To: <200304141140.18647.francesco@unipg.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Francesco,

> this is a little patch to modify the behaviour of the early_drop() function; 
> now it uses the ip_conntrack_drop_list, a double-linked list of all the 
> non-assured connections. It costs 2 bytes more for the ip_conntrack struct
> and a pair of list_append() and list_del() ops, but would have to do better 
> under heavy loads and some type of attacks against the hash chains.

I have some comments. First, thanks for taking the effort to implement
this idea.  Regarding space overhead, it's 8 byte (two 4-byte pointers)
for the struct list_head, not 2 byte. By itself, that's still acceptable.
However, the additional locking (cross-CPU) will have an impact on
high packet load performance. The traditional early_drop does not
influence normal (nondropping case) operation in any way, so that's
a new, additional serialization. I feel that's reason enough to make
the whole thing optional, in some way.

Finally, a stylistic comment, also directed at the other developers here:
you add a list_pop() macro to the netfilter listhelp.h file. I notice
that about half the macros in that file are written in BIG_LETTERS(),
the rest is small_caps(). Why this variance? I cannot see any system!

best regards
  Patrick
