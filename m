From: varun <varun@rocsys.com>
Subject: Doubt in kernel packet generation
Date: Thu, 11 Aug 2005 18:00:44 +0530
Message-ID: <1123763443.14923.123.camel@varun>
References: <20050809211249.GA29430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilters <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050809211249.GA29430@lst.de>
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

Hi all,

          I have a major doubt regarding how to generate my own icmp
packet from the kernel space. That is iam aware of raw sockets and
packet sockets but thats from user space. I want one of my kernel module
to generate a packet using skb and probably add it to the transmit
queue. Can anyone help me in this? 

                                                       Varun
