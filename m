From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack match and locking
Date: Thu, 27 May 2004 12:28:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405271218340.11108-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0405271104570.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0405271104570.27895@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 May 2004, Chris Wilson wrote:

> Is there some documentation which describes this process? I didn't find 
> anything in the netfilter hacking HOWTO. Are the conntrack entries 
> (original and reply) actually spin_locked, or just held in memory by the 
> reference?

There is just one conntrack. The reply and original directions is just 
different fields within the same conntrack.

The conntrakc is just held in memory by the reference. Most fields is 
read-only except for a few atomic status fields and expected connection 
references (expected connection updates is protected by another lock and 
the reference)

> If two packets are being processed at the same time on an SMP 
> machine, who holds what locks?

Both holds a reference. The reference counter is atomic and protected
during increase by a read lock on the global conntrack hash table.

Regards
Henrik
