From: "Andy Schmeder" <andy@a2hd.com>
Subject: Re: standalone target module??
Date: Mon, 10 Feb 2003 13:03:15 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <33713.192.168.1.5.1044910995.squirrel@secure.a2hd.com>
References: <33492.192.168.1.5.1044308966.squirrel@secure.a2hd.com>
     <20030209094415.GQ13269@naboo.fugue.com>
Reply-To: andy@a2hd.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20030209094415.GQ13269@naboo.fugue.com>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<quote who="Harald Welte">
> You seem to have misunderstood how iptables extensions are working.
> There are always two parts, one in userspace and one in the kernel.
> Please look at the source of libipt_MIRROR.c in the
> 'userspace/extensions' directory of the netfilter CVS tree.  This is the
> userspace counterpart to ipt_MIRROR.c inside the kernel.

Yup, that's it exactly.  I've got it working now, thanks.  I looked at the
code for ULOG in CVS and that helped a lot.


Andy.
