From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Mon, 31 Oct 2005 05:41:59 +0100
Message-ID: <4365A097.1080001@eurodev.net>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>	<436281BB.2010100@fliegl.de>	<436373E8.7040606@eurodev.net>
	<436398C7.4070402@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <436398C7.4070402@fliegl.de>
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

Hi,

JFYI, I just commited the following changes to libconntrack_netfilter:

o Replace misleading flag NFCT_ANY_GROUP by NFCT_ALL_GROUPS
o Update test file to use NFCT_ALL_GROUPS
o Add missing check of CTA_PROTOINFO_TCP that resulted in a segfault in
conjuction with events
o Fix ICMP conntracks output
o Add missing prototype definition of nfct_default_expect_display_id in
libnetfilter_conntrack.h

and the following to conntrack:

o Replace misleading message "Not enough memory" by "Can't open handler"
o New option -i for expectation dumping: conntrack -L expect [-i]
o sed 's/VERSION/CONNTRACK_VERSION/g'
o Fix nfct_open flags, now uses NFCT_ALL_GROUPS when needed
o Bumped version to 0.94

AFAIK these fix the problems concerned with the dumping. The problem 
wasn't 64 bits arch specific at all, actually the matter was that I 
required some fast hardware to reproduce them that I don't have. Thanks 
to Deti Fiegl for providing me such fast hardware via SSH to reproduce 
the bugs ;)

I've been giving some testing to the conntrack tool and seems to work 
fine under big stress situation. If you spot any other bug, please let 
me know. I'm willing to do the first 1.0 official as soon as people 
don't complain about bugs.

-- 
Pablo
