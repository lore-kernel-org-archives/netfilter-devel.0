From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 11:58:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405211156380.22237-100000@filer.marasystems.com>
References: <40AD6835.2060105@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>, Jozsef Kadlecsik <kadlec@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40AD6835.2060105@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Patrick McHardy wrote:

> It should be, on x86 set_bit locks the bus:

Which was my second question.. does this set_bit really need to be atomic 
with a memory barrier?

Regards
Henrik
