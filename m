From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Using NF_DROP or NF_STOLEN?
Date: Mon, 22 Mar 2004 17:58:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405F0D34.6090609@netlab.hut.fi>
References: <4055C7C3.2030003@netlab.hut.fi> <20040317135934.GB21899@sunbeam.de.gnumonks.org>
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

I have a situation when I record in my module a packet for later 
processing. When I do that, I do not wish hte iptables to do anyhting 
with it anymore. As I do that operation in a conntrack  packet() 
function, should I then return NF_STOLEN or NF_DROP? For my operations 
it does not change anything as long as the packet is not in transit 
anymore. But what about the netfilter code? I do not know what 
operations iptables do regarding that flag.

Emmanuel
