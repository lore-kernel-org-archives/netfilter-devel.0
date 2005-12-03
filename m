From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: cntl_test fail
Date: Sat, 03 Dec 2005 12:55:12 +0100
Message-ID: <439187A0.3010604@eurodev.net>
References: <43905DC0.9020805@minag.gob.pe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Geffrey Velasquez <gvelasquez@minag.gob.pe>
In-Reply-To: <43905DC0.9020805@minag.gob.pe>
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

Geffrey Velasquez wrote:
> Hi pals, I'm trying to understand the code of libnetfilter_conntrack
> (starting with the example from utils) but the cntl_test fail with this
> errors:
> 
> Test for libnetfilter_conntrack
> 
> NFNETLINK answers: Invalid argument
> TEST 1: create conntrack (-22)
> TEST 2: dump conntrack table and reset (-22)
> TEST 3: dump conntrack table (-22)
> TEST 4: get conntrack (-22)
> TEST 5: update conntrack (-22)
> NFNETLINK answers: Invalid argument
> TEST 6: delete conntrack (-22)
> nfnl_open: bind(netlink): Operation not permitted
> Can't open handler

modprobe ip_conntrack_netlink, the load on demand of
ip_conntrack_netlink was inserted in 2.6.15 :(

-- 
Pablo
