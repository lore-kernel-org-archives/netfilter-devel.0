From: "Peter 'Luna' Runestig" <peter@runestig.com>
Subject: Q about ip_conntrack_expect_related()/ip_nat_expect_register()
Date: Wed, 23 Oct 2002 15:48:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DB6A8B3.7050706@runestig.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all!

I'm thinking of trying to put together a helper module, and I'm looking 
at existing code (plus reading howto's and searching the mbox archive) 
to try to grasp the way it all works.

I actually have two questions:

1) I'm looking at ip_{conntrack,nat}_irc.c (2.4.19). The help() function 
registered with ip_nat_helper_register(), seems to assume that the 
struct ip_conntrack *ct pointer passed, points to the same struct 
ip_conntrack that was modified in the conntrack help() function earlier. 
Why is that, what is the link between them? Just that the tuple/mask 
pair was identical in the ip_conntrack_helper_register() / 
ip_nat_helper_register() calls?

2) I also wonder why irc_nat_expected() is called at all! :-) Is it so, 
that every callback that is registered with ip_nat_expect_register(), is 
called for every connection that is "flagged" by 
ip_conntrack_expect_related() and is nat'ed in any way?

TIA,
- Peter
-- 
Peter 'Luna' Runestig (fd. Altberg), Sweden <peter@runestig.com>
PGP Key ID: 0xD07BBE13
Fingerprint: 7B5C 1F48 2997 C061 DE4B  42EA CB99 A35C D07B BE13
AOL Instant Messenger Screenname: PRunestig
