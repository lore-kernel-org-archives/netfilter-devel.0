From: "raquel toribio" <raqueltoribio@hotmail.com>
Subject: Using -j QUEUE
Date: Tue, 26 Nov 2002 12:02:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F188P1Ny1WafSqy4YkV0000addd@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
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

Hello,
I am using the following rule in iptables:

iptables -A INPUT -p TCP -j QUEUE

and I would expect all incoming tcp traffic, independently of the 
destination IP to be fetched by my userspace program. Nevertheless, what I 
get, is that only tcp packets destined for the linux machine arrive to the 
userspace program. Is that the correct behaviour? If so, how should I 
configure the iptables to get all the tcp packets independently of the 
destination IP?

Regards
Raquel



_________________________________________________________________
Charla con tus amigos en línea mediante MSN Messenger: 
http://messenger.microsoft.com/es
