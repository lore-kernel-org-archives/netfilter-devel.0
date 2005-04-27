From: James Morris <jmorris@redhat.com>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 18:43:30 -0400 (EDT)
Message-ID: <Xine.LNX.4.44.0504271838530.19809-100000@thoron.boston.redhat.com>
References: <426FE9DD.80201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: juha.heljoranta@evtek.fi, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426FE9DD.80201@trash.net>
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

On Wed, 27 Apr 2005, Patrick McHardy wrote:

> I think what it comes down to is that we can filter in socket
> context, but the only useable attributes in both input- and
> output-path for owner-matching are
> sk->sk_socket->file->f_{uid,gid}. This should still be enough
> for many usage cases (and for mine), so I'm going to finish the
> patch.
> 
> @james: Out of interest, what are the requirements for selinux?

We only need to get at the inode associated with the receiving sk, which 
has security info already attached.

SELinux currently does this via an LSM hook in sk_filter() (see 
selinux_socket_sock_rcv_skb()).


- James
-- 
James Morris
<jmorris@redhat.com>
