From: scott comer <wert@metreos.com>
Subject: extra space in packet for iptables mangle table extension
Date: Thu, 22 Jun 2006 19:01:53 -0500
Message-ID: <772C6A8C-06CE-44E2-B082-0F1787B4093E@metreos.com>
Mime-Version: 1.0 (Apple Message framework v750)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

we are developing a mangle table extension which adds a bit of info  
to the end of a udp packet.

when our extension gets a packet, sometimes there is enough extra  
space in the buffer to add what we want, but sometimes there isn't.  
in the latter case we have to allocate a new buffer with enough extra  
room and copy the data. is there any way to request a certain minimum  
amount of extra space in the buffers?

thanks,
scott
