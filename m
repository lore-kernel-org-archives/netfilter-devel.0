From: Patrick McHardy <kaber@trash.net>
Subject: Re: Parsing ULOG message received on netlink socket
Date: Fri, 29 Sep 2006 15:40:43 +0200
Message-ID: <451D225B.6030908@trash.net>
References: <b322db070609272111o4e0b097cw9ee64dc4614810dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh Chadha <retesh.chadha@gmail.com>
In-Reply-To: <b322db070609272111o4e0b097cw9ee64dc4614810dc@mail.gmail.com>
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

Retesh Chadha wrote:
> Hi All
> I am trying to ULOG certain packets based on a iptable rule.
> 
> When the ulog daemon receives data on the netlink socket, it is raw
> data, which I dont know how to parse, apart from structure nlmsghdr,
> that is its header.
> 
> My requirement is to parse the received buffer on netlink socket so as
> to get the source IP address of the IP packet. Are there any routines
> or macros to do so? I think struct sk_buff is the buffer received on
> netlink socket, but not sure.
> 
> Please let me know if someone is aware of the same, or some pointers
> where I can get this info.

Check out ulogd or nfnetlink_log and libnfnetlink.
