From: Bo Xiong <bxiong@actiontec.com>
Subject: Re: [PATCH 2.6] Use C99 initializers for conntrack sysctl tables
Date: Fri, 20 Feb 2004 19:57:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4036D735.E834F74A@actiontec.com>
References: <20040220210758.GV4797@sunbeam.de.gnumonks.org> <20040220151242.78536970.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

init_conntrack()  will creat a new conntrack, bu where add the new
conntrack to hash_list?
-Bo
