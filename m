From: Pablo Neira <pablo@eurodev.net>
Subject: Re: conntrack match and locking
Date: Fri, 28 May 2004 14:06:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B72B46.9050908@eurodev.net>
References: <Pine.LNX.4.44.0405261804070.31237-100000@filer.marasystems.com> <Pine.LNX.4.58.0405271104570.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi Chris,

Chris Wilson wrote:

>Is there some documentation which describes this process? I didn't find 
>anything in the netfilter hacking HOWTO.
>

no, only source code, have a look at netfilter-docbook patch which has 
comments about all functions used in ip_conntrack_core.c, but the 
current schema used is not documented.

> Are the conntrack entries 
>(original and reply) actually spin_locked, or just held in memory by the 
>reference?
>

Actually this is the process, when we read a conntrack from the 
conntrack table we read_lock the table and increase its refcount (see 
ip_conntrack_get). We don't lock a conntrack, we lock the table while 
reading the conntrack/tuples pair.

To write a conntrack, that is, we want to add/destroy/modify a conntrack 
, we write lock the table.

At this moment we lock the whole table, Joszef has some patches to make 
fine grain locking (instead of locking the whole table, per bucket 
locking) in pom-ng still in testing phase.

> If two packets are being processed at the same time on an SMP 
>machine, who holds what locks?
>  
>

As I told you, we only lock the table when reading/writing new entries, 
once we get the conntrack, we increase the refcount. Have also a look at 
ip_conntrack_put to understand the way refcounts are used when 
destroying a conntrack.

regards,
Pablo
