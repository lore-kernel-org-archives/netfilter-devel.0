From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in
	br_nf_dev_queue_xmit
Date: Mon, 28 Apr 2014 16:37:08 +0400
Message-ID: <535E4B74.4050107@parallels.com>
References: <534FB7D2.3020705@parallels.com> <53535C35.7070108@parallels.com>
	<20140424163243.GN31953@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: bridge@lists.linux-foundation.org, Patrick McHardy <kaber@trash.net>,
	Stephen Hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20140424163243.GN31953@breakpoint.cc>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

On 04/24/2014 08:32 PM, Florian Westphal wrote:
> Vasily Averin <vvs@parallels.com> wrote:
>> Please do not apply my patch, probably it breaks processing of VLAN packets.
> 
> Why would it break VLAN?
Sorry, seems it was false alert.

We got report about problem on RHEL6-based OpenVZ kernel:
large UDP and ICMP packets was dropped on bridge without incrementing of any failcounters.
Connection tracking was disabled on this node , nf_conntrack module was unloaded
Ftrace pointed that it was happen because nfct check.

I've unloaded nf_conntrack module and problem was reproduced again
After removing nfct check problem went away.

The check was added by patch that fixed processing of VLAN packets.
I did not tested this scenario and therefore asked to delay processing of my patch,
to investigate this case more carefully.

IS_VLAN_IP() check on RHEL6 kernels seems is not depend on nfct check,
in current mainline we do not have this code at all, 
therefore removing of nfct check should not affect this case too.

Therefore I believe that my patch is still correct, however now I think we also need 
to remove #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) in br_nf_dev_queue_xmit().

> In fact, the same dicussion came up couple of days back and I think the
> nfct test is wrong.  There is no guarantee that skb->nfct == NULL means
> that packet was not defragmented via nf_defrag (e.g. rror in l4 protocol
> tracker, nf_defrag_ipv4 loaded but no nf_conntrack_ipv4)

Thank you for explanation,
In my case ftrace also shows that packets was defragmented in ipv4_conntrack_defrag().
However this module does not depend on NF_CONNTRACK_IPV4.
