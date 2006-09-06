From: Martijn Posthuma <m.posthuma@sangine.com>
Subject: SYN,URG combination considered INVALID by tcp conntrack
Date: Wed, 6 Sep 2006 14:47:46 +0200
Message-ID: <20060906144746.446d813c.m.posthuma@sangine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

We have been experiencing problems with tcp connection establishment  when (for some reason) the URG flag and pointer were set in the SYN segment. The problem did not affect all machines that were contacted but a subset. All affected machines were using netfilter-conntrack and firewalling. Inspection of the conntrack code (on a 2.6 linux kernel source) reveiled that the above mentioned combination of flags is not considered valid. The code I am referring to is in  nf_conntrack_proto_tcp.c version 2.2, lines 768 to 795:

#define TH_FIN  0x01
#define TH_SYN  0x02
#define TH_RST  0x04
#define TH_PUSH 0x08
#define TH_ACK  0x10
#define TH_URG  0x20
#define TH_ECE  0x40
#define TH_CWR  0x80

/* table of valid flag combinations - ECE and CWR are always valid */
static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
{
    [TH_SYN]            = 1,
    [TH_SYN|TH_ACK]         = 1,
    [TH_SYN|TH_PUSH]        = 1,
    [TH_SYN|TH_ACK|TH_PUSH]     = 1,
    [TH_RST]            = 1,
    [TH_RST|TH_ACK]         = 1,
    [TH_RST|TH_ACK|TH_PUSH]     = 1,
    [TH_FIN|TH_ACK]         = 1,
    [TH_ACK]            = 1,
    [TH_ACK|TH_PUSH]        = 1,
    [TH_ACK|TH_URG]         = 1,
    [TH_ACK|TH_URG|TH_PUSH]     = 1,
    [TH_FIN|TH_ACK|TH_PUSH]     = 1,
    [TH_FIN|TH_ACK|TH_URG]      = 1,
    [TH_FIN|TH_ACK|TH_URG|TH_PUSH]  = 1,
};

As you can see the SYN,URG combination is not considered valid. I can not find any justification for this in RFC793. I do realize that it is a rare combination of flags, but legal none the less. (In the RFC there is even an explicit mention of the fact that a SYN segment can contain data, so an URG flag is perfectly feasible in that case).

Does someone know of a good reason that this flag combination is excluded?

-- 
Martijn Posthuma - software engineer Sangine
www.sangine.com t:+32 (0)14 472 576 f:+32 (0)14 472 582
