From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Using Netfilter hooks - how to log connection attempts?
Date: Mon, 12 Apr 2004 19:43:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404121941420.3467-100000@filer.marasystems.com>
References: <20040412015536.91BF03894F0@smtp1.utdallas.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Faraz <faraz@utdallas.edu>
In-Reply-To: <20040412015536.91BF03894F0@smtp1.utdallas.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Apr 2004, Faraz wrote:

> How can I keep a track of connection attempt form each IP? 

You need some kind of registry for this. As the size may grow rather large 
I would recommend sending the details to userspace, but you may obviously 
also keep the registry in your kernel module..

Regards
Henrik
