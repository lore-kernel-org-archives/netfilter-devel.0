From: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
Subject: raw/NOTRACK + TARPIT = good idea?
Date: Fri, 21 Nov 2003 19:55:53 -0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBE89E9.1020307@vialink.com.br>
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

I'm thinking about the TARPIT target, and that it's a shame it will use resources if my box does conntrack. But if I previously pass them through -t raw -j NOTRACK, can I have the best of both worlds, i.e., a routing NAT box who is able to tarpit undesired packets itself?
