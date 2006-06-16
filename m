From: "Mohammad Farooq" <mfarooq100@hotmail.com>
Subject: Filtering RTP packet
Date: Fri, 16 Jun 2006 16:34:06 -0500
Message-ID: <BAY108-F244CD8F0A5DFE0141CD6AB97830@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi All,

I have a linux box which sits between the two RTP clients. I would like to 
have a kernel module which looks at the RTP packets. If this packet 
contailns DTMF digit, it passes the packet to the user space otherwise it 
forwards the packet to the destination address without any change. As we 
know RTP protocol sits on top of UDP. I am new to iptables and not very 
familar with the kernel module development. I would appreciate if someone 
point me to the right direction.  Thanks in advance.

M. Farooq
