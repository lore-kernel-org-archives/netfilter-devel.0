From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] libnetfilter_queue naming problem
Date: Wed, 26 Oct 2005 09:58:02 +0200
Message-ID: <435F370A.6040703@eurodev.net>
References: <1130312714.4872.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1130312714.4872.57.camel@localhost.localdomain>
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

Hi Eric,

Eric Leblond wrote:
> I don't like the fact that it uses "struct nfattr* nfa[]" as parameter
> for high-level function because it is too much linked with the kernel
> implementation. But I do not have much time to find and propose a more
> elegant solution. Any idea ?

We can provide a higher level interface abstracted from the netlink 
sockets, let me see if I can do something.

In the meantime:

> Index: include/libnetfilter_queue/libnfnetlink_queue.h
> ===================================================================
> --- include/libnetfilter_queue/libnfnetlink_queue.h	(revision 4384)
> +++ include/libnetfilter_queue/libnfnetlink_queue.h	(working copy)
> @@ -1,87 +0,0 @@
> -/* libnfqnetlink.h: Header file for the Netfilter Queue library.
> Index: src/libnfnetlink_queue.c
> ===================================================================
> --- src/libnfnetlink_queue.c	(revision 4384)
> +++ src/libnfnetlink_queue.c	(working copy)
> @@ -1,375 +0,0 @@
> -/* libnfqnetlink.c: generic library for access to nf_queue

This patch kills libnfnetlink_queue.[h|c], despite that I guess that 
your intention is renaming them to libnetfilter_queue.c, correct? ;)

cheers,
Pablo
