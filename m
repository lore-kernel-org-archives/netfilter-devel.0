From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 10:15:18 +0100
Message-ID: <42564BA6.3040702@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>
	<42555F99.8010201@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42555F99.8010201@ufomechanic.net>
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

Amin Azez wrote:
>> After your new patch (which applies cleanly to 2.6.11) trying to 
>> compile libctnetlink fails on not finding nfnetlink_conntrack.h which 
>> can't be found in any kernel sources (patched or otherwise) but only 
>> be found in:
>> patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/nfnetlink_conntrack.h 
>>
>> Do I still need to grab any files from nfnetlink-ctnetlink-0.13 in 
>> pom-ng?

I've transferred the whole source files from nfnetlink-ctnetlink-0.13 to 
the 2.6.11 source tree and read the pom-ng source to work out what ladd 
files are for, and I'm applying those by hand.

There seems to be a conceptual clash between IP_NF_CONNTRACK_NETLINK in 
Kconfig and IP_NF_NETLINK_CONNTRACK in the ladd file which both have 
exactly the same description "Connection tracking netlink interface", 
similar names but different dependancies

// from Kconfig ipv4/netfilter (2.6.11)
config IP_NF_CONNTRACK_NETLINK
         tristate 'Connection tracking netlink interface'
         depends on IP_NF_CONNTRACK && 
NETFILTER_NETLINK&&IP_NF_CONNTRACK_EVENTS

//from Kconfig.ladd (nfnetlink-ctnetlink-0.13)
config IP_NF_NETLINK_CONNTRACK
         tristate  'Connection tracking netlink interface'
         depends on IP_NF_NETLINK && IP_NF_CONNTRACK


Kconfig depends on NETFILTER_NETLINK which might be the same as the 
KConfig.ladd's IP_NF_NETLINK

The indication then is, that in kernel 2.6.11.6 the 
IP_NF_CONNTRACK_NETLINK fragment is trying to do the same thing as the 
IP_NF_NETLINK_CONNTRACK fragment in the ladd file.

As neither of these definitions seems to be used in any of the source it 
is all the more puzzling as there are no clues to resolve the question.

Anyway, it looks like only the Makefile.ladd and the whole source files 
from the pomg-ng/nfnetlink-ctnetlink-0.13 need importing in conjunction 
with Pablo's new combined patch.

So I'm giving that a go.

Sam
