From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Changing the conntrack / NATP information.
Date: Mon, 15 Mar 2004 17:12:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4055C7C3.2030003@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
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


Hi!

I wish to change the connection tracking / NAPT information of my target 
upon reception of a certain nf_conntrack event. Is it possible to do so 
by doing the following for example:

u_int32_t  ip_address;
conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip = ip_address;
conntrack->nat.info.manips[IP_CT_DIR_ORIGINAL].manip.ip = ip_address;

Or is there more complicated interactions that makes these operations 
not possible? (And then, do you have an advice on how to overcome them?)
To tell the truth, I am investigating the reasons of my kernel crashes :)

                Emmanuel
