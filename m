From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: System with really big statetable crashing while doing "cat
 /proc/net/ip_conntrack | wc -l"
Date: Fri, 23 Apr 2004 12:21:51 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0404231212130.32062@chris.camcom.co.uk>
References: <40875ECE.1000405@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jens Hektor <hektor@rz.rwth-aachen.de>
In-Reply-To: <40875ECE.1000405@rz.rwth-aachen.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jens,

> So we only can guess for if doing
> 
> 	cat /proc/net/ip_conntrack | wc -l
> 
> the system reproducably crashes.
>
> we are running a production packetfilter based on Fedora Core-1
> actual vanilla  2.4.22-1.2179.nptl-smp.

Do you have ip_conntrack_tftp loaded? If so, try unloading it. It's known 
to create corrupt conntrack entries that will crash the system eventually. 

Phil Oester <kernel@linuxace.com> posted a patch earlier week (subject: 
Orphaned Expectations) which fixes occasional problems with conntrack 
(probably only the TFTP helper, but it may affect others too, e.g. 
Amanda). You could try that patch to see if it helps.

Please let us know if that helps,

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
