From: mjc22 <mjc22@drexel.edu>
Subject: possible libipq bug
Date: Wed, 26 Mar 2003 20:57:31 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E854994@webmail.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
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

Hi...

I am currently using 2 files...

iptables -A INPUT -j QUEUE
iptables -A OUTPUT -j QUEUE

I have a libipq program that hooks in.  I can get packets, going both ways, 
fine. However, the ID in the iphdr is incorrect,  it is the ID of the previous 
packet.  Everything else looks ok (source port, dest port, seq ...), just not 
the iphdr ID.

Any ideas?

Thanks
