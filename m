From: Gan HawK <ganhawk3@yahoo.com>
Subject: Caching of netfilter rules
Date: Sun, 8 Aug 2004 18:33:38 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040809013338.8559.qmail@web90103.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

I am interested in implementing a caching system for
netfilter rules. The cache would intercept all the
packets that have been accepted through all the rules,
and store its nfcache along with values of all the
nfcache bits that are set. (of course it will discard
if NFC_UNKNOWN or NFC_ALTERED or NFC_IP_PROTO_UNKNOWN
is set)

Then, when a packet comes in, the cache is first
checked to see if it can be accepted, else all the
netfilter rules are accepted (normal processing).

I have implemented a test system as kernel module to
develop and test the cache. The current testbed system
consists of two hooks. One hook in NF_IP_LOCAL_IN with
NF_IP_PRI_LAST that updates the cache with new entries
and  NF_IP_PRE_ROUTING that checks if the packet can
be accepted from the cache. Of course, for the end
system, I need to change the netfilter code itself to
accept packets without further processing. 

I would appreciate feedback or comments on the idea or
pointers on how to add a call to netfilter to accept
packets without further processing. I plan to
implement the cache as a module and it will use this
netfilter call to accept packets which are in the
cache.


thanks,
ganhawk



		
__________________________________
Do you Yahoo!?
Yahoo! Mail - You care about security. So do we.
http://promotions.yahoo.com/new_mail
