From: James Morris <jmorris@redhat.com>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 09:59:51 -0400 (EDT)
Message-ID: <Xine.LNX.4.44.0504270958400.17685-100000@thoron.boston.redhat.com>
References: <426F64C8.1070601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426F64C8.1070601@trash.net>
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

Also, I wonder, if we're doing the socket lookup early (in Netfilter), 
perhaps there's some way of caching this so we don't have to do it again 
later.

If this is racy, then the initial lookup is also racy :-)


- James
-- 
James Morris
<jmorris@redhat.com>
