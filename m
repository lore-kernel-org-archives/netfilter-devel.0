From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ctnetlink questions
Date: Tue, 21 Oct 2003 21:54:07 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310212149340.7523-100000@filer.marasystems.com>
References: <3F95630A.3090507@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F95630A.3090507@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Oct 2003, Patrick McHardy wrote:

> Ok there's another problem, for fast lookups by id (we don't want to
> search the entire hash) we need to encode the hash chain of a tuple 
> in the id. We basically have two choices now for the remaining bits:

You can always make the userspace ID larger by including the bucket
number. There is no need to extend the ID stored in the conntrack for
this as it is already known.

Regards
Henrik
